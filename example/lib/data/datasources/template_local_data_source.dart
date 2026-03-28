import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kifiya_rendering_engine_example/core/models/form_template_model.dart';
import 'package:kifiya_rendering_engine_example/core/models/template_parse.dart';

/// Persists last successfully fetched template definition as JSON in Hive.
abstract class TemplateLocalDataSource {
  TemplateDefinitionModel? readCachedTemplate();

  Future<void> writeTemplate(TemplateDefinitionModel template);
}

class TemplateLocalDataSourceImpl implements TemplateLocalDataSource {
  TemplateLocalDataSourceImpl({required Box<String> box}) : _box = box;

  final Box<String> _box;

  static const _cacheKey = 'kyb_template_definition_cache_v2';

  @override
  TemplateDefinitionModel? readCachedTemplate() {
    final raw = _box.get(_cacheKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final decoded = json.decode(raw);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    return parseTemplateDefinition(decoded);
  }

  @override
  Future<void> writeTemplate(TemplateDefinitionModel template) async {
    await _box.put(_cacheKey, json.encode(template.toJson()));
  }
}
