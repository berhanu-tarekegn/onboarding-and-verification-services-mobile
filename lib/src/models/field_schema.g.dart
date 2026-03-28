// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_schema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FieldSchema _$FieldSchemaFromJson(Map<String, dynamic> json) => _FieldSchema(
  id: json['id'] as String,
  type: $enumDecode(_$FieldTypeEnumMap, json['type']),
  label: json['label'] as String,
  required: json['required'] as bool? ?? false,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  dependsOn: json['dependsOn'] as String?,
  visibleWhenEquals: json['visibleWhenEquals'],
  dateFormat: json['dateFormat'] as String?,
  regex: json['regex'] as String?,
  minDate: json['minDate'] == null
      ? null
      : DateTime.parse(json['minDate'] as String),
  maxDate: json['maxDate'] == null
      ? null
      : DateTime.parse(json['maxDate'] as String),
  properties: json['properties'] == null
      ? null
      : Properties.fromJson(json['properties'] as Map<String, dynamic>),
  keyboardType: $enumDecodeNullable(
    _$KeyboardInputTypeEnumMap,
    json['keyboardType'],
  ),
  defaultValue: json['defaultValue'],
  rowGroup: json['rowGroup'] as String?,
  flex: (json['flex'] as num?)?.toDouble() ?? 1.0,
  columnSpan: (json['columnSpan'] as num?)?.toInt() ?? 1,
  startNewRow: json['startNewRow'] as bool? ?? false,
);

Map<String, dynamic> _$FieldSchemaToJson(_FieldSchema instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$FieldTypeEnumMap[instance.type]!,
      'label': instance.label,
      'required': instance.required,
      'options': instance.options,
      'dependsOn': instance.dependsOn,
      'visibleWhenEquals': instance.visibleWhenEquals,
      'dateFormat': instance.dateFormat,
      'regex': instance.regex,
      'minDate': instance.minDate?.toIso8601String(),
      'maxDate': instance.maxDate?.toIso8601String(),
      'properties': instance.properties,
      'keyboardType': _$KeyboardInputTypeEnumMap[instance.keyboardType],
      'defaultValue': instance.defaultValue,
      'rowGroup': instance.rowGroup,
      'flex': instance.flex,
      'columnSpan': instance.columnSpan,
      'startNewRow': instance.startNewRow,
    };

const _$FieldTypeEnumMap = {
  FieldType.text: 'text',
  FieldType.dropdown: 'dropdown',
  FieldType.radio: 'radio',
  FieldType.date: 'date',
  FieldType.checkbox: 'checkbox',
  FieldType.fileUpload: 'fileUpload',
  FieldType.signature: 'signature',
  FieldType.imageCapture: 'imageCapture',
};

const _$KeyboardInputTypeEnumMap = {
  KeyboardInputType.text: 'text',
  KeyboardInputType.number: 'number',
  KeyboardInputType.email: 'email',
  KeyboardInputType.phone: 'phone',
};

_Properties _$PropertiesFromJson(Map<String, dynamic> json) =>
    _Properties(inline: json['inline'] as bool? ?? false);

Map<String, dynamic> _$PropertiesToJson(_Properties instance) =>
    <String, dynamic>{'inline': instance.inline};
