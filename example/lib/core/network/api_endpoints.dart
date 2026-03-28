/// REST paths appended to [AppConfig.baseUrl] (no trailing slash on base).
abstract final class ApiEndpoints {
  /// `GET /api/v1/templates/{templateId}/definitions/{definitionId}`
  static String templateDefinition(String templateId, String definitionId) =>
      '/api/v1/templates/$templateId/definitions/$definitionId';

  static const String submissions = '/api/v1/submissions';
}
