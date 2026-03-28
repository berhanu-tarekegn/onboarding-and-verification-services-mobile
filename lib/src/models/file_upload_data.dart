import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_upload_data.freezed.dart';
part 'file_upload_data.g.dart';

/// Model to hold structured file upload metadata.
/// Used for file upload fields that require additional information
/// like document number, issue date, and expiry date.
@freezed
abstract class FileUploadData with _$FileUploadData {
  const FileUploadData._();

  const factory FileUploadData({
    /// The file path of the uploaded file
    String? filePath,

    /// Document number associated with the uploaded file
    String? documentNumber,

    /// Issue date of the document (ISO 8601 format)
    String? issuedDate,

    /// Expiry date of the document (ISO 8601 format)
    String? expiredDate,
  }) = _FileUploadData;

  factory FileUploadData.fromJson(Map<String, dynamic> json) =>
      _$FileUploadDataFromJson(json);

  /// Returns true if all required metadata is filled.
  /// A file upload is considered complete when it has:
  /// - A file path
  /// - A document number
  /// - An issued date
  /// - An expiry date (optional based on document type, but included for completeness)
  bool get isComplete =>
      filePath != null &&
      filePath!.isNotEmpty &&
      documentNumber != null &&
      documentNumber!.isNotEmpty &&
      issuedDate != null &&
      issuedDate!.isNotEmpty &&
      expiredDate != null &&
      expiredDate!.isNotEmpty;

  /// Returns true if at least a file has been selected
  bool get hasFile => filePath != null && filePath!.isNotEmpty;
}
