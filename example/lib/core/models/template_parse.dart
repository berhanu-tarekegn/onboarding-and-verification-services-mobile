import 'package:kifiya_rendering_engine_example/core/models/form_template_model.dart';

/// Supports legacy wrapped KYB JSON (`initial_version`) and flat definition API JSON.
TemplateDefinitionModel parseTemplateDefinition(Map<String, dynamic> json) {
  if (json.containsKey('initial_version')) {
    return TemplateDefinitionModel.fromLegacy(
      FormTemplateModel.fromJson(json),
    );
  }
  return TemplateDefinitionModel.fromJson(json);
}
