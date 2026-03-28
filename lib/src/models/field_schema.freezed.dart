// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field_schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FieldSchema {

 String get id; FieldType get type; String get label; bool get required; List<String>? get options; String? get dependsOn; dynamic get visibleWhenEquals; String? get dateFormat; String? get regex; DateTime? get minDate; DateTime? get maxDate; Properties? get properties; KeyboardInputType? get keyboardType; dynamic get defaultValue;// ==========================================
// Layout Properties (for field-level control)
// ==========================================
/// Group ID for fields that should appear side-by-side.
/// Fields with the same rowGroup will be placed in a row together.
/// Example: Two checkboxes with rowGroup: "terms" will appear side-by-side.
 String? get rowGroup;/// Flex value for horizontal sizing within a row group.
/// Default is 1 (equal width). Set to 2 for double width, 0.5 for half, etc.
 double get flex;/// For grid layouts: how many columns this field should span.
/// Default is 1. Set to 2 to span two columns in a grid.
 int get columnSpan;/// Forces this field to start on a new row.
 bool get startNewRow;
/// Create a copy of FieldSchema
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FieldSchemaCopyWith<FieldSchema> get copyWith => _$FieldSchemaCopyWithImpl<FieldSchema>(this as FieldSchema, _$identity);

  /// Serializes this FieldSchema to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FieldSchema&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.dependsOn, dependsOn) || other.dependsOn == dependsOn)&&const DeepCollectionEquality().equals(other.visibleWhenEquals, visibleWhenEquals)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.regex, regex) || other.regex == regex)&&(identical(other.minDate, minDate) || other.minDate == minDate)&&(identical(other.maxDate, maxDate) || other.maxDate == maxDate)&&(identical(other.properties, properties) || other.properties == properties)&&(identical(other.keyboardType, keyboardType) || other.keyboardType == keyboardType)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&(identical(other.rowGroup, rowGroup) || other.rowGroup == rowGroup)&&(identical(other.flex, flex) || other.flex == flex)&&(identical(other.columnSpan, columnSpan) || other.columnSpan == columnSpan)&&(identical(other.startNewRow, startNewRow) || other.startNewRow == startNewRow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,label,required,const DeepCollectionEquality().hash(options),dependsOn,const DeepCollectionEquality().hash(visibleWhenEquals),dateFormat,regex,minDate,maxDate,properties,keyboardType,const DeepCollectionEquality().hash(defaultValue),rowGroup,flex,columnSpan,startNewRow);

@override
String toString() {
  return 'FieldSchema(id: $id, type: $type, label: $label, required: $required, options: $options, dependsOn: $dependsOn, visibleWhenEquals: $visibleWhenEquals, dateFormat: $dateFormat, regex: $regex, minDate: $minDate, maxDate: $maxDate, properties: $properties, keyboardType: $keyboardType, defaultValue: $defaultValue, rowGroup: $rowGroup, flex: $flex, columnSpan: $columnSpan, startNewRow: $startNewRow)';
}


}

/// @nodoc
abstract mixin class $FieldSchemaCopyWith<$Res>  {
  factory $FieldSchemaCopyWith(FieldSchema value, $Res Function(FieldSchema) _then) = _$FieldSchemaCopyWithImpl;
@useResult
$Res call({
 String id, FieldType type, String label, bool required, List<String>? options, String? dependsOn, dynamic visibleWhenEquals, String? dateFormat, String? regex, DateTime? minDate, DateTime? maxDate, Properties? properties, KeyboardInputType? keyboardType, dynamic defaultValue, String? rowGroup, double flex, int columnSpan, bool startNewRow
});


$PropertiesCopyWith<$Res>? get properties;

}
/// @nodoc
class _$FieldSchemaCopyWithImpl<$Res>
    implements $FieldSchemaCopyWith<$Res> {
  _$FieldSchemaCopyWithImpl(this._self, this._then);

  final FieldSchema _self;
  final $Res Function(FieldSchema) _then;

/// Create a copy of FieldSchema
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? label = null,Object? required = null,Object? options = freezed,Object? dependsOn = freezed,Object? visibleWhenEquals = freezed,Object? dateFormat = freezed,Object? regex = freezed,Object? minDate = freezed,Object? maxDate = freezed,Object? properties = freezed,Object? keyboardType = freezed,Object? defaultValue = freezed,Object? rowGroup = freezed,Object? flex = null,Object? columnSpan = null,Object? startNewRow = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FieldType,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,dependsOn: freezed == dependsOn ? _self.dependsOn : dependsOn // ignore: cast_nullable_to_non_nullable
as String?,visibleWhenEquals: freezed == visibleWhenEquals ? _self.visibleWhenEquals : visibleWhenEquals // ignore: cast_nullable_to_non_nullable
as dynamic,dateFormat: freezed == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String?,regex: freezed == regex ? _self.regex : regex // ignore: cast_nullable_to_non_nullable
as String?,minDate: freezed == minDate ? _self.minDate : minDate // ignore: cast_nullable_to_non_nullable
as DateTime?,maxDate: freezed == maxDate ? _self.maxDate : maxDate // ignore: cast_nullable_to_non_nullable
as DateTime?,properties: freezed == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Properties?,keyboardType: freezed == keyboardType ? _self.keyboardType : keyboardType // ignore: cast_nullable_to_non_nullable
as KeyboardInputType?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as dynamic,rowGroup: freezed == rowGroup ? _self.rowGroup : rowGroup // ignore: cast_nullable_to_non_nullable
as String?,flex: null == flex ? _self.flex : flex // ignore: cast_nullable_to_non_nullable
as double,columnSpan: null == columnSpan ? _self.columnSpan : columnSpan // ignore: cast_nullable_to_non_nullable
as int,startNewRow: null == startNewRow ? _self.startNewRow : startNewRow // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FieldSchema
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PropertiesCopyWith<$Res>? get properties {
    if (_self.properties == null) {
    return null;
  }

  return $PropertiesCopyWith<$Res>(_self.properties!, (value) {
    return _then(_self.copyWith(properties: value));
  });
}
}


/// Adds pattern-matching-related methods to [FieldSchema].
extension FieldSchemaPatterns on FieldSchema {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FieldSchema value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FieldSchema() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FieldSchema value)  $default,){
final _that = this;
switch (_that) {
case _FieldSchema():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FieldSchema value)?  $default,){
final _that = this;
switch (_that) {
case _FieldSchema() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  FieldType type,  String label,  bool required,  List<String>? options,  String? dependsOn,  dynamic visibleWhenEquals,  String? dateFormat,  String? regex,  DateTime? minDate,  DateTime? maxDate,  Properties? properties,  KeyboardInputType? keyboardType,  dynamic defaultValue,  String? rowGroup,  double flex,  int columnSpan,  bool startNewRow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FieldSchema() when $default != null:
return $default(_that.id,_that.type,_that.label,_that.required,_that.options,_that.dependsOn,_that.visibleWhenEquals,_that.dateFormat,_that.regex,_that.minDate,_that.maxDate,_that.properties,_that.keyboardType,_that.defaultValue,_that.rowGroup,_that.flex,_that.columnSpan,_that.startNewRow);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  FieldType type,  String label,  bool required,  List<String>? options,  String? dependsOn,  dynamic visibleWhenEquals,  String? dateFormat,  String? regex,  DateTime? minDate,  DateTime? maxDate,  Properties? properties,  KeyboardInputType? keyboardType,  dynamic defaultValue,  String? rowGroup,  double flex,  int columnSpan,  bool startNewRow)  $default,) {final _that = this;
switch (_that) {
case _FieldSchema():
return $default(_that.id,_that.type,_that.label,_that.required,_that.options,_that.dependsOn,_that.visibleWhenEquals,_that.dateFormat,_that.regex,_that.minDate,_that.maxDate,_that.properties,_that.keyboardType,_that.defaultValue,_that.rowGroup,_that.flex,_that.columnSpan,_that.startNewRow);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  FieldType type,  String label,  bool required,  List<String>? options,  String? dependsOn,  dynamic visibleWhenEquals,  String? dateFormat,  String? regex,  DateTime? minDate,  DateTime? maxDate,  Properties? properties,  KeyboardInputType? keyboardType,  dynamic defaultValue,  String? rowGroup,  double flex,  int columnSpan,  bool startNewRow)?  $default,) {final _that = this;
switch (_that) {
case _FieldSchema() when $default != null:
return $default(_that.id,_that.type,_that.label,_that.required,_that.options,_that.dependsOn,_that.visibleWhenEquals,_that.dateFormat,_that.regex,_that.minDate,_that.maxDate,_that.properties,_that.keyboardType,_that.defaultValue,_that.rowGroup,_that.flex,_that.columnSpan,_that.startNewRow);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FieldSchema implements FieldSchema {
  const _FieldSchema({required this.id, required this.type, required this.label, this.required = false, final  List<String>? options, this.dependsOn, this.visibleWhenEquals, this.dateFormat, this.regex, this.minDate, this.maxDate, this.properties, this.keyboardType, this.defaultValue, this.rowGroup, this.flex = 1.0, this.columnSpan = 1, this.startNewRow = false}): _options = options;
  factory _FieldSchema.fromJson(Map<String, dynamic> json) => _$FieldSchemaFromJson(json);

@override final  String id;
@override final  FieldType type;
@override final  String label;
@override@JsonKey() final  bool required;
 final  List<String>? _options;
@override List<String>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? dependsOn;
@override final  dynamic visibleWhenEquals;
@override final  String? dateFormat;
@override final  String? regex;
@override final  DateTime? minDate;
@override final  DateTime? maxDate;
@override final  Properties? properties;
@override final  KeyboardInputType? keyboardType;
@override final  dynamic defaultValue;
// ==========================================
// Layout Properties (for field-level control)
// ==========================================
/// Group ID for fields that should appear side-by-side.
/// Fields with the same rowGroup will be placed in a row together.
/// Example: Two checkboxes with rowGroup: "terms" will appear side-by-side.
@override final  String? rowGroup;
/// Flex value for horizontal sizing within a row group.
/// Default is 1 (equal width). Set to 2 for double width, 0.5 for half, etc.
@override@JsonKey() final  double flex;
/// For grid layouts: how many columns this field should span.
/// Default is 1. Set to 2 to span two columns in a grid.
@override@JsonKey() final  int columnSpan;
/// Forces this field to start on a new row.
@override@JsonKey() final  bool startNewRow;

/// Create a copy of FieldSchema
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FieldSchemaCopyWith<_FieldSchema> get copyWith => __$FieldSchemaCopyWithImpl<_FieldSchema>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FieldSchemaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FieldSchema&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.label, label) || other.label == label)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.dependsOn, dependsOn) || other.dependsOn == dependsOn)&&const DeepCollectionEquality().equals(other.visibleWhenEquals, visibleWhenEquals)&&(identical(other.dateFormat, dateFormat) || other.dateFormat == dateFormat)&&(identical(other.regex, regex) || other.regex == regex)&&(identical(other.minDate, minDate) || other.minDate == minDate)&&(identical(other.maxDate, maxDate) || other.maxDate == maxDate)&&(identical(other.properties, properties) || other.properties == properties)&&(identical(other.keyboardType, keyboardType) || other.keyboardType == keyboardType)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&(identical(other.rowGroup, rowGroup) || other.rowGroup == rowGroup)&&(identical(other.flex, flex) || other.flex == flex)&&(identical(other.columnSpan, columnSpan) || other.columnSpan == columnSpan)&&(identical(other.startNewRow, startNewRow) || other.startNewRow == startNewRow));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,label,required,const DeepCollectionEquality().hash(_options),dependsOn,const DeepCollectionEquality().hash(visibleWhenEquals),dateFormat,regex,minDate,maxDate,properties,keyboardType,const DeepCollectionEquality().hash(defaultValue),rowGroup,flex,columnSpan,startNewRow);

@override
String toString() {
  return 'FieldSchema(id: $id, type: $type, label: $label, required: $required, options: $options, dependsOn: $dependsOn, visibleWhenEquals: $visibleWhenEquals, dateFormat: $dateFormat, regex: $regex, minDate: $minDate, maxDate: $maxDate, properties: $properties, keyboardType: $keyboardType, defaultValue: $defaultValue, rowGroup: $rowGroup, flex: $flex, columnSpan: $columnSpan, startNewRow: $startNewRow)';
}


}

/// @nodoc
abstract mixin class _$FieldSchemaCopyWith<$Res> implements $FieldSchemaCopyWith<$Res> {
  factory _$FieldSchemaCopyWith(_FieldSchema value, $Res Function(_FieldSchema) _then) = __$FieldSchemaCopyWithImpl;
@override @useResult
$Res call({
 String id, FieldType type, String label, bool required, List<String>? options, String? dependsOn, dynamic visibleWhenEquals, String? dateFormat, String? regex, DateTime? minDate, DateTime? maxDate, Properties? properties, KeyboardInputType? keyboardType, dynamic defaultValue, String? rowGroup, double flex, int columnSpan, bool startNewRow
});


@override $PropertiesCopyWith<$Res>? get properties;

}
/// @nodoc
class __$FieldSchemaCopyWithImpl<$Res>
    implements _$FieldSchemaCopyWith<$Res> {
  __$FieldSchemaCopyWithImpl(this._self, this._then);

  final _FieldSchema _self;
  final $Res Function(_FieldSchema) _then;

/// Create a copy of FieldSchema
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? label = null,Object? required = null,Object? options = freezed,Object? dependsOn = freezed,Object? visibleWhenEquals = freezed,Object? dateFormat = freezed,Object? regex = freezed,Object? minDate = freezed,Object? maxDate = freezed,Object? properties = freezed,Object? keyboardType = freezed,Object? defaultValue = freezed,Object? rowGroup = freezed,Object? flex = null,Object? columnSpan = null,Object? startNewRow = null,}) {
  return _then(_FieldSchema(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FieldType,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,dependsOn: freezed == dependsOn ? _self.dependsOn : dependsOn // ignore: cast_nullable_to_non_nullable
as String?,visibleWhenEquals: freezed == visibleWhenEquals ? _self.visibleWhenEquals : visibleWhenEquals // ignore: cast_nullable_to_non_nullable
as dynamic,dateFormat: freezed == dateFormat ? _self.dateFormat : dateFormat // ignore: cast_nullable_to_non_nullable
as String?,regex: freezed == regex ? _self.regex : regex // ignore: cast_nullable_to_non_nullable
as String?,minDate: freezed == minDate ? _self.minDate : minDate // ignore: cast_nullable_to_non_nullable
as DateTime?,maxDate: freezed == maxDate ? _self.maxDate : maxDate // ignore: cast_nullable_to_non_nullable
as DateTime?,properties: freezed == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Properties?,keyboardType: freezed == keyboardType ? _self.keyboardType : keyboardType // ignore: cast_nullable_to_non_nullable
as KeyboardInputType?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as dynamic,rowGroup: freezed == rowGroup ? _self.rowGroup : rowGroup // ignore: cast_nullable_to_non_nullable
as String?,flex: null == flex ? _self.flex : flex // ignore: cast_nullable_to_non_nullable
as double,columnSpan: null == columnSpan ? _self.columnSpan : columnSpan // ignore: cast_nullable_to_non_nullable
as int,startNewRow: null == startNewRow ? _self.startNewRow : startNewRow // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FieldSchema
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PropertiesCopyWith<$Res>? get properties {
    if (_self.properties == null) {
    return null;
  }

  return $PropertiesCopyWith<$Res>(_self.properties!, (value) {
    return _then(_self.copyWith(properties: value));
  });
}
}


/// @nodoc
mixin _$Properties {

 bool get inline;
/// Create a copy of Properties
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertiesCopyWith<Properties> get copyWith => _$PropertiesCopyWithImpl<Properties>(this as Properties, _$identity);

  /// Serializes this Properties to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Properties&&(identical(other.inline, inline) || other.inline == inline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inline);

@override
String toString() {
  return 'Properties(inline: $inline)';
}


}

/// @nodoc
abstract mixin class $PropertiesCopyWith<$Res>  {
  factory $PropertiesCopyWith(Properties value, $Res Function(Properties) _then) = _$PropertiesCopyWithImpl;
@useResult
$Res call({
 bool inline
});




}
/// @nodoc
class _$PropertiesCopyWithImpl<$Res>
    implements $PropertiesCopyWith<$Res> {
  _$PropertiesCopyWithImpl(this._self, this._then);

  final Properties _self;
  final $Res Function(Properties) _then;

/// Create a copy of Properties
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inline = null,}) {
  return _then(_self.copyWith(
inline: null == inline ? _self.inline : inline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Properties].
extension PropertiesPatterns on Properties {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Properties value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Properties() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Properties value)  $default,){
final _that = this;
switch (_that) {
case _Properties():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Properties value)?  $default,){
final _that = this;
switch (_that) {
case _Properties() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool inline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Properties() when $default != null:
return $default(_that.inline);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool inline)  $default,) {final _that = this;
switch (_that) {
case _Properties():
return $default(_that.inline);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool inline)?  $default,) {final _that = this;
switch (_that) {
case _Properties() when $default != null:
return $default(_that.inline);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Properties implements Properties {
  const _Properties({this.inline = false});
  factory _Properties.fromJson(Map<String, dynamic> json) => _$PropertiesFromJson(json);

@override@JsonKey() final  bool inline;

/// Create a copy of Properties
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertiesCopyWith<_Properties> get copyWith => __$PropertiesCopyWithImpl<_Properties>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertiesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Properties&&(identical(other.inline, inline) || other.inline == inline));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inline);

@override
String toString() {
  return 'Properties(inline: $inline)';
}


}

/// @nodoc
abstract mixin class _$PropertiesCopyWith<$Res> implements $PropertiesCopyWith<$Res> {
  factory _$PropertiesCopyWith(_Properties value, $Res Function(_Properties) _then) = __$PropertiesCopyWithImpl;
@override @useResult
$Res call({
 bool inline
});




}
/// @nodoc
class __$PropertiesCopyWithImpl<$Res>
    implements _$PropertiesCopyWith<$Res> {
  __$PropertiesCopyWithImpl(this._self, this._then);

  final _Properties _self;
  final $Res Function(_Properties) _then;

/// Create a copy of Properties
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inline = null,}) {
  return _then(_Properties(
inline: null == inline ? _self.inline : inline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
