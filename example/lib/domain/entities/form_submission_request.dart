/// Payload for POST `/api/v1/submissions`.
class FormSubmissionRequest {
  const FormSubmissionRequest({
    required this.templateId,
    required this.formData,
    required this.submitterId,
  });

  /// From the template definition response (`template_id`).
  final String templateId;

  /// Answers keyed by question `unique_key` → value (strings, numbers, nested maps if needed).
  final Map<String, dynamic> formData;

  /// Caller / device identity for audit (see `SUBMITTER_ID` in `.env`).
  final String submitterId;

  Map<String, dynamic> toJson() => {
        'template_id': templateId,
        'form_data': formData,
        'submitter_id': submitterId,
      };
}
