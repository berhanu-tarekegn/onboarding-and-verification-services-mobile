// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_upload_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileUploadData {

/// The file path of the uploaded file
 String? get filePath;/// Document number associated with the uploaded file
 String? get documentNumber;/// Issue date of the document (ISO 8601 format)
 String? get issuedDate;/// Expiry date of the document (ISO 8601 format)
 String? get expiredDate;
/// Create a copy of FileUploadData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileUploadDataCopyWith<FileUploadData> get copyWith => _$FileUploadDataCopyWithImpl<FileUploadData>(this as FileUploadData, _$identity);

  /// Serializes this FileUploadData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileUploadData&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.documentNumber, documentNumber) || other.documentNumber == documentNumber)&&(identical(other.issuedDate, issuedDate) || other.issuedDate == issuedDate)&&(identical(other.expiredDate, expiredDate) || other.expiredDate == expiredDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filePath,documentNumber,issuedDate,expiredDate);

@override
String toString() {
  return 'FileUploadData(filePath: $filePath, documentNumber: $documentNumber, issuedDate: $issuedDate, expiredDate: $expiredDate)';
}


}

/// @nodoc
abstract mixin class $FileUploadDataCopyWith<$Res>  {
  factory $FileUploadDataCopyWith(FileUploadData value, $Res Function(FileUploadData) _then) = _$FileUploadDataCopyWithImpl;
@useResult
$Res call({
 String? filePath, String? documentNumber, String? issuedDate, String? expiredDate
});




}
/// @nodoc
class _$FileUploadDataCopyWithImpl<$Res>
    implements $FileUploadDataCopyWith<$Res> {
  _$FileUploadDataCopyWithImpl(this._self, this._then);

  final FileUploadData _self;
  final $Res Function(FileUploadData) _then;

/// Create a copy of FileUploadData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filePath = freezed,Object? documentNumber = freezed,Object? issuedDate = freezed,Object? expiredDate = freezed,}) {
  return _then(_self.copyWith(
filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,documentNumber: freezed == documentNumber ? _self.documentNumber : documentNumber // ignore: cast_nullable_to_non_nullable
as String?,issuedDate: freezed == issuedDate ? _self.issuedDate : issuedDate // ignore: cast_nullable_to_non_nullable
as String?,expiredDate: freezed == expiredDate ? _self.expiredDate : expiredDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FileUploadData].
extension FileUploadDataPatterns on FileUploadData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileUploadData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileUploadData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileUploadData value)  $default,){
final _that = this;
switch (_that) {
case _FileUploadData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileUploadData value)?  $default,){
final _that = this;
switch (_that) {
case _FileUploadData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? filePath,  String? documentNumber,  String? issuedDate,  String? expiredDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileUploadData() when $default != null:
return $default(_that.filePath,_that.documentNumber,_that.issuedDate,_that.expiredDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? filePath,  String? documentNumber,  String? issuedDate,  String? expiredDate)  $default,) {final _that = this;
switch (_that) {
case _FileUploadData():
return $default(_that.filePath,_that.documentNumber,_that.issuedDate,_that.expiredDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? filePath,  String? documentNumber,  String? issuedDate,  String? expiredDate)?  $default,) {final _that = this;
switch (_that) {
case _FileUploadData() when $default != null:
return $default(_that.filePath,_that.documentNumber,_that.issuedDate,_that.expiredDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileUploadData extends FileUploadData {
  const _FileUploadData({this.filePath, this.documentNumber, this.issuedDate, this.expiredDate}): super._();
  factory _FileUploadData.fromJson(Map<String, dynamic> json) => _$FileUploadDataFromJson(json);

/// The file path of the uploaded file
@override final  String? filePath;
/// Document number associated with the uploaded file
@override final  String? documentNumber;
/// Issue date of the document (ISO 8601 format)
@override final  String? issuedDate;
/// Expiry date of the document (ISO 8601 format)
@override final  String? expiredDate;

/// Create a copy of FileUploadData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileUploadDataCopyWith<_FileUploadData> get copyWith => __$FileUploadDataCopyWithImpl<_FileUploadData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileUploadDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileUploadData&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.documentNumber, documentNumber) || other.documentNumber == documentNumber)&&(identical(other.issuedDate, issuedDate) || other.issuedDate == issuedDate)&&(identical(other.expiredDate, expiredDate) || other.expiredDate == expiredDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filePath,documentNumber,issuedDate,expiredDate);

@override
String toString() {
  return 'FileUploadData(filePath: $filePath, documentNumber: $documentNumber, issuedDate: $issuedDate, expiredDate: $expiredDate)';
}


}

/// @nodoc
abstract mixin class _$FileUploadDataCopyWith<$Res> implements $FileUploadDataCopyWith<$Res> {
  factory _$FileUploadDataCopyWith(_FileUploadData value, $Res Function(_FileUploadData) _then) = __$FileUploadDataCopyWithImpl;
@override @useResult
$Res call({
 String? filePath, String? documentNumber, String? issuedDate, String? expiredDate
});




}
/// @nodoc
class __$FileUploadDataCopyWithImpl<$Res>
    implements _$FileUploadDataCopyWith<$Res> {
  __$FileUploadDataCopyWithImpl(this._self, this._then);

  final _FileUploadData _self;
  final $Res Function(_FileUploadData) _then;

/// Create a copy of FileUploadData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filePath = freezed,Object? documentNumber = freezed,Object? issuedDate = freezed,Object? expiredDate = freezed,}) {
  return _then(_FileUploadData(
filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,documentNumber: freezed == documentNumber ? _self.documentNumber : documentNumber // ignore: cast_nullable_to_non_nullable
as String?,issuedDate: freezed == issuedDate ? _self.issuedDate : issuedDate // ignore: cast_nullable_to_non_nullable
as String?,expiredDate: freezed == expiredDate ? _self.expiredDate : expiredDate // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
