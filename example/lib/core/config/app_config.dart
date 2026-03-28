import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App configuration loaded from `.env` (see `.env.example`).
class AppConfig {
  const AppConfig({
    required this.baseUrl,
    required this.useMockApi,
    required this.tenantId,
    required this.templateId,
    required this.definitionId,
    required this.submitterId,
  });

  final String baseUrl;
  final bool useMockApi;

  /// Sent as `X-Tenant-ID` on every API request when non-empty.
  final String tenantId;

  /// Path segment: `GET /api/v1/templates/{templateId}/definitions/{definitionId}`
  final String templateId;
  final String definitionId;

  /// Included in POST `/api/v1/submissions` as `submitter_id`.
  final String submitterId;

  factory AppConfig.fromEnv() {
    return AppConfig(
      baseUrl: dotenv.env['BASE_URL']?.trim().isNotEmpty == true
          ? dotenv.env['BASE_URL']!.trim()
          : 'https://api.example.com',
      useMockApi: _parseBool(dotenv.env['USE_MOCK_API']),
      tenantId: dotenv.env['TENANT_ID']?.trim() ?? '',
      templateId: dotenv.env['TEMPLATE_ID']?.trim() ?? '',
      definitionId: dotenv.env['DEFINITION_ID']?.trim() ?? '',
      submitterId: dotenv.env['SUBMITTER_ID']?.trim().isNotEmpty == true
          ? dotenv.env['SUBMITTER_ID']!.trim()
          : 'demo_submitter',
    );
  }

  static bool _parseBool(String? value) {
    if (value == null) return true;
    final v = value.trim().toLowerCase();
    return v == '1' || v == 'true' || v == 'yes';
  }
}
