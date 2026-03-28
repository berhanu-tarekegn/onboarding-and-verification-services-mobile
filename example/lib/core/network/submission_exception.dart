/// Thrown when POST `/api/v1/submissions` fails (HTTP error or unusable response).
class SubmissionFailureException implements Exception {
  SubmissionFailureException(this.userMessage, {this.statusCode});

  /// Human-readable message safe to show in UI.
  final String userMessage;

  final int? statusCode;

  @override
  String toString() => userMessage;
}
