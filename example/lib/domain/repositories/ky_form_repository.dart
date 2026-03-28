import 'package:kifiya_rendering_engine_example/core/models/form_template_model.dart';
import 'package:kifiya_rendering_engine_example/domain/entities/form_submission_request.dart';

/// Fetches KYB / form templates and submits completed forms.
abstract class KyFormRepository {
  /// GET template definition (then cache locally on success).
  Future<TemplateDefinitionModel> fetchTemplate();

  /// POST submission body to the backend (mock skips HTTP).
  Future<void> submitForm(FormSubmissionRequest request);
}
