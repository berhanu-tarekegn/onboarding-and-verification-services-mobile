import 'package:kifiya_rendering_engine/kifiya_rendering_engine.dart';
import 'package:kifiya_rendering_engine_example/core/models/form_template_model.dart';

/// Maps backend [FormTemplateModel] into the plugin's [FormSchema] so
/// [DynamicForm] stays unchanged.
///
/// - Flattens [InitialVersionModel.questionGroups] (and optional top-level
///   [InitialVersionModel.questions]) sorted by `display_order`.
/// - `unique_key` → [FieldSchema.id], `field_type` → [FieldType].
/// - Inline `options` → [FieldSchema.options] (`value` strings, sorted).
/// - `rules.options_source` (e.g. `iso_countries`) uses a small static list
///   for UI until the real catalog is loaded separately.
/// - `min_length` / `max_length` → [FieldSchema.regex] where possible.
FormSchema mapFormTemplateToFormSchema(
  FormTemplateModel template, {
  String submitApiUrl = '',
  String nextFormApiUrl = '',
  String buttonColor = '',
  bool sequentialFileUpload = false,
}) {
  final v = template.initialVersion;
  final fields = _collectFieldSchemas(v);
  return FormSchema(
    title: template.name,
    fields: fields,
    submitApiUrl: submitApiUrl,
    nextFormApiUrl: nextFormApiUrl,
    buttonColor: buttonColor,
    sequentialFileUpload: sequentialFileUpload,
  );
}

/// One wizard step: a single [QuestionGroupModel] → [FormSchema] (title = group title).
FormSchema mapQuestionGroupToFormSchema(
  QuestionGroupModel group, {
  String submitApiUrl = '',
  String nextFormApiUrl = '',
  String buttonColor = '',
  bool? sequentialFileUpload,
}) {
  final questions = [...group.questions]
    ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  final fields = questions.map(_questionToFieldSchema).toList();
  final effectiveSubmit = submitApiUrl.isNotEmpty
      ? submitApiUrl
      : (group.submitApiUrl ?? '');
  final effectiveSequential =
      sequentialFileUpload ?? group.sequentialFileUpload ?? false;
  return FormSchema(
    title: group.title,
    fields: fields,
    submitApiUrl: effectiveSubmit,
    nextFormApiUrl: nextFormApiUrl,
    buttonColor: buttonColor,
    sequentialFileUpload: effectiveSequential,
  );
}

List<FieldSchema> _collectFieldSchemas(InitialVersionModel v) {
  final out = <FieldSchema>[];

  final groups = [...v.questionGroups]
    ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

  for (final group in groups) {
    final questions = [...group.questions]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    for (final q in questions) {
      out.add(_questionToFieldSchema(q));
    }
  }

  final orphans = [...v.questions]
    ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  for (final q in orphans) {
    out.add(_questionToFieldSchema(q));
  }

  return out;
}

FieldSchema _questionToFieldSchema(QuestionModel q) {
  final type = _parseFieldType(q.fieldType);
  final options = _resolveOptions(q);
  final fromRules = _lengthRegexFromRules(q.rules);
  final effectiveRegex = (q.regex != null && q.regex!.trim().isNotEmpty)
      ? q.regex
      : fromRules;

  return FieldSchema(
    id: q.uniqueKey,
    type: type,
    label: q.label,
    required: q.isRequired,
    options: options,
    regex: effectiveRegex,
    dependsOn: q.dependsOnUniqueKey,
    visibleWhenEquals: q.visibleWhenEquals,
  );
}

FieldType _parseFieldType(String raw) {
  final n = raw.trim().toLowerCase().replaceAll('-', '_');
  switch (n) {
    case 'text':
      return FieldType.text;
    case 'dropdown':
    case 'select':
      return FieldType.dropdown;
    case 'radio':
      return FieldType.radio;
    case 'date':
      return FieldType.date;
    case 'checkbox':
      return FieldType.checkbox;
    case 'file':
    case 'file_upload':
    case 'fileupload':
      return FieldType.fileUpload;
    case 'signature':
      return FieldType.signature;
    case 'image_capture':
    case 'imagecapture':
      return FieldType.imageCapture;
    default:
      return FieldType.text;
  }
}

List<String>? _resolveOptions(QuestionModel q) {
  if (q.options != null && q.options!.isNotEmpty) {
    final sorted = [...q.options!]
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return sorted.map((e) => e.value).toList();
  }

  final source = q.rules?['options_source'];
  if (source is String && source == 'iso_countries') {
    return List<String>.from(_sampleCountryLabels);
  }

  if (q.fieldType.toLowerCase() == 'dropdown' ||
      q.fieldType.toLowerCase() == 'select') {
    return List<String>.from(_sampleCountryLabels);
  }

  return null;
}

/// Subset of labels for demo when API only sends `options_source`.
const _sampleCountryLabels = <String>[
  'Ethiopia',
  'Kenya',
  'Uganda',
  'United States',
  'United Kingdom',
  'Other',
];

String? _lengthRegexFromRules(Map<String, dynamic>? rules) {
  if (rules == null) return null;

  final minRaw = rules['min_length'];
  final maxRaw = rules['max_length'];
  final minL = _toPositiveInt(minRaw);
  final maxL = _toPositiveInt(maxRaw);
  if (minL == null && maxL == null) return null;

  final min = minL ?? 0;
  if (maxL != null) {
    return '^.' '{$min,$maxL}\$';
  }
  return '^.' '{$min,}\$';
}

int? _toPositiveInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return null;
}
