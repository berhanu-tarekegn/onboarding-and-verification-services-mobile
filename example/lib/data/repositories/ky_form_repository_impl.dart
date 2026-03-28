import 'package:kifiya_rendering_engine_example/core/models/template_parse.dart';
import 'package:kifiya_rendering_engine_example/core/models/form_template_model.dart';
import 'package:kifiya_rendering_engine_example/data/datasources/template_local_data_source.dart';
import 'package:kifiya_rendering_engine_example/data/datasources/template_remote_data_source.dart';
import 'package:kifiya_rendering_engine_example/domain/entities/form_submission_request.dart';
import 'package:kifiya_rendering_engine_example/domain/repositories/ky_form_repository.dart';

class KyFormRepositoryImpl implements KyFormRepository {
  KyFormRepositoryImpl({
    required TemplateRemoteDataSource remote,
    required TemplateLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final TemplateRemoteDataSource _remote;
  final TemplateLocalDataSource _local;

  @override
  Future<TemplateDefinitionModel> fetchTemplate() async {
    try {
      final map = await _remote.fetchTemplateJson();
      final model = parseTemplateDefinition(map);
      await _local.writeTemplate(model);
      return model;
    } catch (_) {
      final cached = _local.readCachedTemplate();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<void> submitForm(FormSubmissionRequest request) async {
    await _remote.submitSubmissionJson(request.toJson());
  }
}
