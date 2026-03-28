import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kifiya_rendering_engine/src/models/field_schema.dart';
part 'form_schema.freezed.dart';
part 'form_schema.g.dart';

@freezed
abstract class FormSchema with _$FormSchema {
  const factory FormSchema({
    required String title,
    required List<FieldSchema> fields,
    required String submitApiUrl,

    /// Deprecated: Use KifiyaFormTheme or FormBuilders for styling.
    /// This field will be removed in a future version.
    @Default('') String buttonColor,
    required String nextFormApiUrl,

    /// When true, file upload fields activate sequentially.
    /// The first file field is always active, subsequent fields unlock
    /// only after the previous one is completely filled.
    @Default(false) bool sequentialFileUpload,
  }) = _FormSchema;

  factory FormSchema.fromJson(Map<String, dynamic> json) =>
      _$FormSchemaFromJson(json);
}
