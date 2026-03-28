import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kifiya_rendering_engine_example/core/config/app_config.dart';
import 'package:kifiya_rendering_engine_example/core/network/api_endpoints.dart';
import 'package:kifiya_rendering_engine_example/core/network/submission_exception.dart';

/// Remote API: fetch template JSON + POST submission.
abstract class TemplateRemoteDataSource {
  Future<Map<String, dynamic>> fetchTemplateJson();

  Future<void> submitSubmissionJson(Map<String, dynamic> body);
}

class TemplateRemoteDataSourceImpl implements TemplateRemoteDataSource {
  TemplateRemoteDataSourceImpl({required Dio dio, required AppConfig config})
    : _dio = dio,
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

    try {
      await _dio.post<dynamic>(ApiEndpoints.submissions, data: body);
    } on DioException catch (e) {
      throw _mapSubmissionDioException(e);
    }
  }

  SubmissionFailureException _mapSubmissionDioException(DioException e) {
    final code = e.response?.statusCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return SubmissionFailureException(
          'Request timed out. Check your connection and try again.',
          statusCode: code,
        );
      case DioExceptionType.connectionError:
        return SubmissionFailureException(
          'Could not reach the server. Check your network or BASE_URL.',
          statusCode: code,
        );
      case DioExceptionType.badCertificate:
        return SubmissionFailureException(
          'Secure connection failed.',
          statusCode: code,
        );
      case DioExceptionType.cancel:
        return SubmissionFailureException(
          'Request was cancelled.',
          statusCode: code,
        );
      default:
        break;
    }

    final msg = _extractApiErrorMessage(e);
    final prefix = code != null ? 'Error $code' : 'Submission failed';
    return SubmissionFailureException(
      msg.isNotEmpty ? '$prefix: $msg' : prefix,
      statusCode: code,
    );
  }

  String _extractApiErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      for (final key in ['detail', 'message', 'error', 'title']) {
        final v = map[key];
        if (v != null) {
          if (v is String && v.isNotEmpty) return v;
          if (v is List && v.isNotEmpty) return v.join(', ');
        }
      }
      final errors = map['errors'];
      if (errors is Map) return errors.toString();
      return map.toString();
    }
    if (data is String && data.isNotEmpty) {
      return data;
    }
    return e.message ?? '';
  }
}
