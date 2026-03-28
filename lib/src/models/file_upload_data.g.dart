// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileUploadData _$FileUploadDataFromJson(Map<String, dynamic> json) =>
    _FileUploadData(
      filePath: json['filePath'] as String?,
      documentNumber: json['documentNumber'] as String?,
      issuedDate: json['issuedDate'] as String?,
      expiredDate: json['expiredDate'] as String?,
    );

Map<String, dynamic> _$FileUploadDataToJson(_FileUploadData instance) =>
    <String, dynamic>{
      'filePath': instance.filePath,
      'documentNumber': instance.documentNumber,
      'issuedDate': instance.issuedDate,
      'expiredDate': instance.expiredDate,
    };
