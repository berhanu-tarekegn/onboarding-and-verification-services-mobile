import 'package:dio/dio.dart';

/// Factory for a shared [Dio] instance (timeouts, JSON, base URL, tenant header).
class DioClient {
  DioClient._();

  static Dio create({
    required String baseUrl,
    String tenantId = '',
  }) {
    final normalized = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    final headers = <String, dynamic>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (tenantId.isNotEmpty) {
      headers['X-Tenant-ID'] = tenantId;
    }

    return Dio(
      BaseOptions(
        baseUrl: normalized,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: headers,
      ),
    );
  }
}
