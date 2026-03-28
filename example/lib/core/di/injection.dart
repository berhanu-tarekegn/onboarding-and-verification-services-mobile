import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kifiya_rendering_engine_example/core/config/app_config.dart';
import 'package:kifiya_rendering_engine_example/core/network/dio_client.dart';
import 'package:kifiya_rendering_engine_example/data/datasources/template_local_data_source.dart';
import 'package:kifiya_rendering_engine_example/data/datasources/template_remote_data_source.dart';
import 'package:kifiya_rendering_engine_example/data/repositories/ky_form_repository_impl.dart';
import 'package:kifiya_rendering_engine_example/domain/repositories/ky_form_repository.dart';
import 'package:kifiya_rendering_engine_example/passkey/agent_auth_storage.dart';

/// Hive box for string-backed cache (override in `main` after `openBox`).
final hiveBoxProvider = Provider<Box<String>>((ref) {
  throw StateError('hiveBoxProvider must be overridden in main()');
});

final agentAuthStorageProvider = Provider<AgentAuthStorage>((ref) {
  return AgentAuthStorage(ref.watch(hiveBoxProvider));
});

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.fromEnv());

final dioProvider = Provider<Dio>((ref) {
  final cfg = ref.watch(appConfigProvider);
  return DioClient.create(baseUrl: cfg.baseUrl, tenantId: cfg.tenantId);
});

final templateRemoteDataSourceProvider = Provider<TemplateRemoteDataSource>((
  ref,
) {
  return TemplateRemoteDataSourceImpl(
    dio: ref.watch(dioProvider),
    config: ref.watch(appConfigProvider),
  );
});

final templateLocalDataSourceProvider = Provider<TemplateLocalDataSource>((
  ref,
) {
  return TemplateLocalDataSourceImpl(box: ref.watch(hiveBoxProvider));
});

final kyFormRepositoryProvider = Provider<KyFormRepository>((ref) {
  return KyFormRepositoryImpl(
    remote: ref.watch(templateRemoteDataSourceProvider),
    local: ref.watch(templateLocalDataSourceProvider),
  );
});
