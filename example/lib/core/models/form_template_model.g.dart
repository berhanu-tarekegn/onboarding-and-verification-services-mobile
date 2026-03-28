// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormTemplateModel _$FormTemplateModelFromJson(Map<String, dynamic> json) =>
    FormTemplateModel(
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      templateType: json['template_type'] as String,
      level: (json['level'] as num).toInt(),
      initialVersion: InitialVersionModel.fromJson(
        json['initial_version'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$FormTemplateModelToJson(FormTemplateModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'template_type': instance.templateType,
      'level': instance.level,
      'initial_version': instance.initialVersion.toJson(),
    };

InitialVersionModel _$InitialVersionModelFromJson(Map<String, dynamic> json) =>
    InitialVersionModel(
      versionTag: json['version_tag'] as String,
      changelog: json['changelog'] as String,
      rulesConfig: RulesConfigModel.fromJson(
        json['rules_config'] as Map<String, dynamic>,
      ),
      questionGroups: (json['question_groups'] as List<dynamic>)
          .map((e) => QuestionGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      questions:
          (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$InitialVersionModelToJson(
  InitialVersionModel instance,
) => <String, dynamic>{
  'version_tag': instance.versionTag,
  'changelog': instance.changelog,
  'rules_config': instance.rulesConfig.toJson(),
  'question_groups': instance.questionGroups.map((e) => e.toJson()).toList(),
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};

RulesConfigModel _$RulesConfigModelFromJson(Map<String, dynamic> json) =>
    RulesConfigModel(
      riskTier: json['risk_tier'] as String,
      verificationMethods:
          json['verification_methods'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$RulesConfigModelToJson(RulesConfigModel instance) =>
    <String, dynamic>{
      'risk_tier': instance.riskTier,
      'verification_methods': instance.verificationMethods,
    };

TemplateDefinitionModel _$TemplateDefinitionModelFromJson(
  Map<String, dynamic> json,
) => TemplateDefinitionModel(
  id: json['id'] as String?,
  templateId: json['template_id'] as String?,
  name: json['name'] as String?,
  versionTag: json['version_tag'] as String,
  changelog: json['changelog'] as String,
  rulesConfig: json['rules_config'] as Map<String, dynamic>?,
  questionGroups: (json['question_groups'] as List<dynamic>)
      .map((e) => QuestionGroupModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  ungroupedQuestions:
      (json['ungrouped_questions'] as List<dynamic>?)
          ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TemplateDefinitionModelToJson(
  TemplateDefinitionModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'template_id': instance.templateId,
  'name': instance.name,
  'version_tag': instance.versionTag,
  'changelog': instance.changelog,
  'rules_config': instance.rulesConfig,
  'question_groups': instance.questionGroups.map((e) => e.toJson()).toList(),
  'ungrouped_questions': instance.ungroupedQuestions
      .map((e) => e.toJson())
      .toList(),
};

QuestionGroupModel _$QuestionGroupModelFromJson(Map<String, dynamic> json) =>
    QuestionGroupModel(
      uniqueKey: json['unique_key'] as String,
      title: json['title'] as String,
      displayOrder: (json['display_order'] as num).toInt(),
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      submitApiUrl: json['submit_api_url'] as String?,
      sequentialFileUpload: json['sequential_file_upload'] as bool?,
    );

Map<String, dynamic> _$QuestionGroupModelToJson(QuestionGroupModel instance) =>
    <String, dynamic>{
      'unique_key': instance.uniqueKey,
      'title': instance.title,
      'display_order': instance.displayOrder,
      'questions': instance.questions.map((e) => e.toJson()).toList(),
      'submit_api_url': instance.submitApiUrl,
      'sequential_file_upload': instance.sequentialFileUpload,
    };

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      uniqueKey: json['unique_key'] as String,
      label: json['label'] as String,
      fieldType: json['field_type'] as String,
      isRequired: json['required'] as bool,
      displayOrder: (json['display_order'] as num).toInt(),
      rules: json['rules'] as Map<String, dynamic>?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => QuestionOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      regex: json['regex'] as String?,
      dependsOnUniqueKey: json['depends_on_unique_key'] as String?,
      visibleWhenEquals: json['visible_when_equals'],
      keyboardType: json['keyboard_type'] as String?,
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'unique_key': instance.uniqueKey,
      'label': instance.label,
      'field_type': instance.fieldType,
      'required': instance.isRequired,
      'display_order': instance.displayOrder,
      'rules': instance.rules,
      'options': instance.options?.map((e) => e.toJson()).toList(),
      'regex': instance.regex,
      'depends_on_unique_key': instance.dependsOnUniqueKey,
      'visible_when_equals': instance.visibleWhenEquals,
      'keyboard_type': instance.keyboardType,
    };

QuestionOptionModel _$QuestionOptionModelFromJson(Map<String, dynamic> json) =>
    QuestionOptionModel(
      value: json['value'] as String,
      displayOrder: (json['display_order'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionOptionModelToJson(
  QuestionOptionModel instance,
) => <String, dynamic>{
  'value': instance.value,
  'display_order': instance.displayOrder,
};
