import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kifiya_rendering_engine_example/core/config/app_config.dart';
import 'package:kifiya_rendering_engine_example/core/network/api_endpoints.dart';

/// Remote API: fetch template JSON + POST submission.
abstract class TemplateRemoteDataSource {
  Future<Map<String, dynamic>> fetchTemplateJson();

  Future<void> submitSubmissionJson(Map<String, dynamic> body);
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  TemplateRemoteDataSourceImpl({
    required Dio dio,
    required AppConfig config,
  })  : _dio = dio,
        _config = config;

  final Dio _dio;
  final AppConfig _config;

  static const _mockTemplateAsset = 'assets/mock/kyb_template.json';

  String get _liveDefinitionPath {
    final t = _config.templateId;
    final d = _config.definitionId;
    if (t.isEmpty || d.isEmpty) {
      throw StateError(
        'Set TEMPLATE_ID and DEFINITION_ID in .env when USE_MOCK_API is false.',
      );
    }
    return ApiEndpoints.templateDefinition(t, d);
  }

  @override
  Future<Map<String, dynamic>> fetchTemplateJson() async {
    if (_config.useMockApi) {
      final raw = await rootBundle.loadString(_mockTemplateAsset);
      final decoded = json.decode(raw);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Mock template must be a JSON object');
      }
      return decoded;
    }

    final response = await _dio.get<dynamic>(_liveDefinitionPath);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw FormatException('Template response must be a JSON object', data);
  }

  @override
  Future<void> submitSubmissionJson(Map<String, dynamic> body) async {
    if (_config.useMockApi) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return;
    }
    await _dio.post<dynamic>(ApiEndpoints.submissions, data: body);
  }
}
