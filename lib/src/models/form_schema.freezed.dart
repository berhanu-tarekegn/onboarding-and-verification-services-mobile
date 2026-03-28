// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'form_schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FormSchema {

 String get title; List<FieldSchema> get fields; String get submitApiUrl;/// Deprecated: Use KifiyaFormTheme or FormBuilders for styling.
/// This field will be removed in a future version.
 String get buttonColor; String get nextFormApiUrl;/// When true, file upload fields activate sequentially.
/// The first file field is always active, subsequent fields unlock
/// only after the previous one is completely filled.
 bool get sequentialFileUpload;
/// Create a copy of FormSchema
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FormSchemaCopyWith<FormSchema> get copyWith => _$FormSchemaCopyWithImpl<FormSchema>(this as FormSchema, _$identity);

  /// Serializes this FormSchema to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormSchema&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.submitApiUrl, submitApiUrl) || other.submitApiUrl == submitApiUrl)&&(identical(other.buttonColor, buttonColor) || other.buttonColor == buttonColor)&&(identical(other.nextFormApiUrl, nextFormApiUrl) || other.nextFormApiUrl == nextFormApiUrl)&&(identical(other.sequentialFileUpload, sequentialFileUpload) || other.sequentialFileUpload == sequentialFileUpload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(fields),submitApiUrl,buttonColor,nextFormApiUrl,sequentialFileUpload);

@override
String toString() {
  return 'FormSchema(title: $title, fields: $fields, submitApiUrl: $submitApiUrl, buttonColor: $buttonColor, nextFormApiUrl: $nextFormApiUrl, sequentialFileUpload: $sequentialFileUpload)';
}


}

/// @nodoc
abstract mixin class $FormSchemaCopyWith<$Res>  {
  factory $FormSchemaCopyWith(FormSchema value, $Res Function(FormSchema) _then) = _$FormSchemaCopyWithImpl;
@useResult
$Res call({
 String title, List<FieldSchema> fields, String submitApiUrl, String buttonColor, String nextFormApiUrl, bool sequentialFileUpload
});




}
/// @nodoc
class _$FormSchemaCopyWithImpl<$Res>
    implements $FormSchemaCopyWith<$Res> {
  _$FormSchemaCopyWithImpl(this._self, this._then);

  final FormSchema _self;
  final $Res Function(FormSchema) _then;

/// Create a copy of FormSchema
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? fields = null,Object? submitApiUrl = null,Object? buttonColor = null,Object? nextFormApiUrl = null,Object? sequentialFileUpload = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<FieldSchema>,submitApiUrl: null == submitApiUrl ? _self.submitApiUrl : submitApiUrl // ignore: cast_nullable_to_non_nullable
as String,buttonColor: null == buttonColor ? _self.buttonColor : buttonColor // ignore: cast_nullable_to_non_nullable
as String,nextFormApiUrl: null == nextFormApiUrl ? _self.nextFormApiUrl : nextFormApiUrl // ignore: cast_nullable_to_non_nullable
as String,sequentialFileUpload: null == sequentialFileUpload ? _self.sequentialFileUpload : sequentialFileUpload // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FormSchema].
extension FormSchemaPatterns on FormSchema {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FormSchema value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FormSchema() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FormSchema value)  $default,){
final _that = this;
switch (_that) {
case _FormSchema():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FormSchema value)?  $default,){
final _that = this;
switch (_that) {
case _FormSchema() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  List<FieldSchema> fields,  String submitApiUrl,  String buttonColor,  String nextFormApiUrl,  bool sequentialFileUpload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FormSchema() when $default != null:
return $default(_that.title,_that.fields,_that.submitApiUrl,_that.buttonColor,_that.nextFormApiUrl,_that.sequentialFileUpload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  List<FieldSchema> fields,  String submitApiUrl,  String buttonColor,  String nextFormApiUrl,  bool sequentialFileUpload)  $default,) {final _that = this;
switch (_that) {
case _FormSchema():
return $default(_that.title,_that.fields,_that.submitApiUrl,_that.buttonColor,_that.nextFormApiUrl,_that.sequentialFileUpload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  List<FieldSchema> fields,  String submitApiUrl,  String buttonColor,  String nextFormApiUrl,  bool sequentialFileUpload)?  $default,) {final _that = this;
switch (_that) {
case _FormSchema() when $default != null:
return $default(_that.title,_that.fields,_that.submitApiUrl,_that.buttonColor,_that.nextFormApiUrl,_that.sequentialFileUpload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FormSchema implements FormSchema {
  const _FormSchema({required this.title, required final  List<FieldSchema> fields, required this.submitApiUrl, this.buttonColor = '', required this.nextFormApiUrl, this.sequentialFileUpload = false}): _fields = fields;
  factory _FormSchema.fromJson(Map<String, dynamic> json) => _$FormSchemaFromJson(json);

@override final  String title;
 final  List<FieldSchema> _fields;
@override List<FieldSchema> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

@override final  String submitApiUrl;
/// Deprecated: Use KifiyaFormTheme or FormBuilders for styling.
/// This field will be removed in a future version.
@override@JsonKey() final  String buttonColor;
@override final  String nextFormApiUrl;
/// When true, file upload fields activate sequentially.
/// The first file field is always active, subsequent fields unlock
/// only after the previous one is completely filled.
@override@JsonKey() final  bool sequentialFileUpload;

/// Create a copy of FormSchema
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FormSchemaCopyWith<_FormSchema> get copyWith => __$FormSchemaCopyWithImpl<_FormSchema>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FormSchemaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FormSchema&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._fields, _fields)&&(identical(other.submitApiUrl, submitApiUrl) || other.submitApiUrl == submitApiUrl)&&(identical(other.buttonColor, buttonColor) || other.buttonColor == buttonColor)&&(identical(other.nextFormApiUrl, nextFormApiUrl) || other.nextFormApiUrl == nextFormApiUrl)&&(identical(other.sequentialFileUpload, sequentialFileUpload) || other.sequentialFileUpload == sequentialFileUpload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_fields),submitApiUrl,buttonColor,nextFormApiUrl,sequentialFileUpload);

@override
String toString() {
  return 'FormSchema(title: $title, fields: $fields, submitApiUrl: $submitApiUrl, buttonColor: $buttonColor, nextFormApiUrl: $nextFormApiUrl, sequentialFileUpload: $sequentialFileUpload)';
}


}

/// @nodoc
abstract mixin class _$FormSchemaCopyWith<$Res> implements $FormSchemaCopyWith<$Res> {
  factory _$FormSchemaCopyWith(_FormSchema value, $Res Function(_FormSchema) _then) = __$FormSchemaCopyWithImpl;
@override @useResult
$Res call({
 String title, List<FieldSchema> fields, String submitApiUrl, String buttonColor, String nextFormApiUrl, bool sequentialFileUpload
});




}
/// @nodoc
class __$FormSchemaCopyWithImpl<$Res>
    implements _$FormSchemaCopyWith<$Res> {
  __$FormSchemaCopyWithImpl(this._self, this._then);

  final _FormSchema _self;
  final $Res Function(_FormSchema) _then;

/// Create a copy of FormSchema
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? fields = null,Object? submitApiUrl = null,Object? buttonColor = null,Object? nextFormApiUrl = null,Object? sequentialFileUpload = null,}) {
  return _then(_FormSchema(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<FieldSchema>,submitApiUrl: null == submitApiUrl ? _self.submitApiUrl : submitApiUrl // ignore: cast_nullable_to_non_nullable
as String,buttonColor: null == buttonColor ? _self.buttonColor : buttonColor // ignore: cast_nullable_to_non_nullable
as String,nextFormApiUrl: null == nextFormApiUrl ? _self.nextFormApiUrl : nextFormApiUrl // ignore: cast_nullable_to_non_nullable
as String,sequentialFileUpload: null == sequentialFileUpload ? _self.sequentialFileUpload : sequentialFileUpload // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
