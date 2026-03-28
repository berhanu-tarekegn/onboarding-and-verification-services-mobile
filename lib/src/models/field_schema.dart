import 'package:freezed_annotation/freezed_annotation.dart';
part 'field_schema.freezed.dart';
part 'field_schema.g.dart';

enum KeyboardInputType { text, number, email, phone }

enum FieldType {
  text,
  dropdown,
  radio,
  date,
  checkbox,
  fileUpload,
  signature,
  imageCapture,
}

@freezed
abstract class FieldSchema with _$FieldSchema {
  const factory FieldSchema({
    required String id,
    required FieldType type,
    required String label,
    @Default(false) bool required,
    List<String>? options,
    String? dependsOn,
    dynamic visibleWhenEquals,
    String? dateFormat,
    String? regex,
    DateTime? minDate,
    DateTime? maxDate,
    Properties? properties,
    KeyboardInputType? keyboardType,
    dynamic defaultValue,

    // ==========================================
    // Layout Properties (for field-level control)
    // ==========================================

    /// Group ID for fields that should appear side-by-side.
    /// Fields with the same rowGroup will be placed in a row together.
    /// Example: Two checkboxes with rowGroup: "terms" will appear side-by-side.
    String? rowGroup,

    /// Flex value for horizontal sizing within a row group.
    /// Default is 1 (equal width). Set to 2 for double width, 0.5 for half, etc.
    @Default(1.0) double flex,

    /// For grid layouts: how many columns this field should span.
    /// Default is 1. Set to 2 to span two columns in a grid.
    @Default(1) int columnSpan,

    /// Forces this field to start on a new row.
    @Default(false) bool startNewRow,
  }) = _FieldSchema;

  factory FieldSchema.fromJson(Map<String, dynamic> json) =>
      _$FieldSchemaFromJson(json);
}

@freezed
abstract class Properties with _$Properties {
  const factory Properties({@Default(false) bool inline}) = _Properties;

  factory Properties.fromJson(Map<String, dynamic> json) =>
      _$PropertiesFromJson(json);
}
