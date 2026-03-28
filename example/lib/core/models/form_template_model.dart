import 'package:json_annotation/json_annotation.dart';

part 'form_template_model.g.dart';

/// Backend KYB wrapper payload (mock / legacy) with [initial_version].
@JsonSerializable(explicitToJson: true)
class FormTemplateModel {
  const FormTemplateModel({
    required this.name,
    required this.description,
    required this.category,
    required this.templateType,
    required this.level,
    required this.initialVersion,
  });

  final String name;
  final String description;
  final String category;
  @JsonKey(name: 'template_type')
  final String templateType;
  final int level;
  @JsonKey(name: 'initial_version')
  final InitialVersionModel initialVersion;

  factory FormTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$FormTemplateModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormTemplateModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class InitialVersionModel {
  const InitialVersionModel({
    required this.versionTag,
    required this.changelog,
    required this.rulesConfig,
    required this.questionGroups,
    this.questions = const [],
  });

  @JsonKey(name: 'version_tag')
  final String versionTag;
  final String changelog;
  @JsonKey(name: 'rules_config')
  final RulesConfigModel rulesConfig;
  @JsonKey(name: 'question_groups')
  final List<QuestionGroupModel> questionGroups;
  final List<QuestionModel> questions;

  factory InitialVersionModel.fromJson(Map<String, dynamic> json) =>
      _$InitialVersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$InitialVersionModelToJson(this);
}

@JsonSerializable()
class RulesConfigModel {
  const RulesConfigModel({
    required this.riskTier,
    this.verificationMethods = const [],
  });

  @JsonKey(name: 'risk_tier')
  final String riskTier;
  @JsonKey(name: 'verification_methods')
  final List<dynamic> verificationMethods;

  factory RulesConfigModel.fromJson(Map<String, dynamic> json) =>
      _$RulesConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$RulesConfigModelToJson(this);
}

/// API template **definition** document (GET …/templates/{tid}/definitions/{did}).
/// Preserves [rulesConfig] as arbitrary JSON (verification flows, decisions, etc.).
@JsonSerializable(explicitToJson: true)
class TemplateDefinitionModel {
  const TemplateDefinitionModel({
    this.id,
    this.templateId,
    this.name,
    required this.versionTag,
    required this.changelog,
    this.rulesConfig,
    required this.questionGroups,
    this.ungroupedQuestions = const [],
  });

  final String? id;
  @JsonKey(name: 'template_id')
  final String? templateId;

  /// Optional display name (legacy); many definitions only have ids.
  final String? name;

  @JsonKey(name: 'version_tag')
  final String versionTag;
  final String changelog;

  /// Full backend rules blob (submission search, verification_flow, …).
  @JsonKey(name: 'rules_config')
  final Map<String, dynamic>? rulesConfig;

  @JsonKey(name: 'question_groups')
  final List<QuestionGroupModel> questionGroups;

  @JsonKey(name: 'ungrouped_questions')
  final List<QuestionModel> ungroupedQuestions;

  /// App bar / flow label fallback.
  String get displayTitle => name ?? templateId ?? id ?? 'Form';

  factory TemplateDefinitionModel.fromJson(Map<String, dynamic> json) =>
      _$TemplateDefinitionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateDefinitionModelToJson(this);

  factory TemplateDefinitionModel.fromLegacy(FormTemplateModel legacy) {
    return TemplateDefinitionModel(
      name: legacy.name,
      templateId: null,
      id: null,
      versionTag: legacy.initialVersion.versionTag,
      changelog: legacy.initialVersion.changelog,
      rulesConfig: {
        'risk_tier': legacy.initialVersion.rulesConfig.riskTier,
        'verification_methods':
            legacy.initialVersion.rulesConfig.verificationMethods,
      },
      questionGroups: legacy.initialVersion.questionGroups,
      ungroupedQuestions: legacy.initialVersion.questions,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class QuestionGroupModel {
  const QuestionGroupModel({
    required this.uniqueKey,
    required this.title,
    required this.displayOrder,
    required this.questions,
    this.submitApiUrl,
    this.sequentialFileUpload,
  });

  @JsonKey(name: 'unique_key')
  final String uniqueKey;
  final String title;
  @JsonKey(name: 'display_order')
  final int displayOrder;
  final List<QuestionModel> questions;
  @JsonKey(name: 'submit_api_url')
  final String? submitApiUrl;
  @JsonKey(name: 'sequential_file_upload')
  final bool? sequentialFileUpload;

  factory QuestionGroupModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionGroupModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class QuestionModel {
  const QuestionModel({
    required this.uniqueKey,
    required this.label,
    required this.fieldType,
    required this.isRequired,
    required this.displayOrder,
    this.rules,
    this.options,
    this.regex,
    this.dependsOnUniqueKey,
    this.visibleWhenEquals,
    this.keyboardType,
  });

  @JsonKey(name: 'unique_key')
  final String uniqueKey;
  final String label;
  @JsonKey(name: 'field_type')
  final String fieldType;
  @JsonKey(name: 'required')
  final bool isRequired;
  @JsonKey(name: 'display_order')
  final int displayOrder;
  final Map<String, dynamic>? rules;
  final List<QuestionOptionModel>? options;

  /// API may send regex on the question (not only inside [rules]).
  final String? regex;
  @JsonKey(name: 'depends_on_unique_key')
  final String? dependsOnUniqueKey;
  @JsonKey(name: 'visible_when_equals')
  final dynamic visibleWhenEquals;
  @JsonKey(name: 'keyboard_type')
  final String? keyboardType;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

@JsonSerializable()
class QuestionOptionModel {
  const QuestionOptionModel({
    required this.value,
    required this.displayOrder,
  });

  final String value;
  @JsonKey(name: 'display_order')
  final int displayOrder;

  factory QuestionOptionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionOptionModelToJson(this);
}
