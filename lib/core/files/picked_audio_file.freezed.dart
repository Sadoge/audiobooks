// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'picked_audio_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PickedAudioFile {

 String get name; int get sizeBytes; String get extension; String? get path; String? get persistentUri;
/// Create a copy of PickedAudioFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PickedAudioFileCopyWith<PickedAudioFile> get copyWith => _$PickedAudioFileCopyWithImpl<PickedAudioFile>(this as PickedAudioFile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PickedAudioFile&&(identical(other.name, name) || other.name == name)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.path, path) || other.path == path)&&(identical(other.persistentUri, persistentUri) || other.persistentUri == persistentUri));
}


@override
int get hashCode => Object.hash(runtimeType,name,sizeBytes,extension,path,persistentUri);

@override
String toString() {
  return 'PickedAudioFile(name: $name, sizeBytes: $sizeBytes, extension: $extension, path: $path, persistentUri: $persistentUri)';
}


}

/// @nodoc
abstract mixin class $PickedAudioFileCopyWith<$Res>  {
  factory $PickedAudioFileCopyWith(PickedAudioFile value, $Res Function(PickedAudioFile) _then) = _$PickedAudioFileCopyWithImpl;
@useResult
$Res call({
 String name, int sizeBytes, String extension, String? path, String? persistentUri
});




}
/// @nodoc
class _$PickedAudioFileCopyWithImpl<$Res>
    implements $PickedAudioFileCopyWith<$Res> {
  _$PickedAudioFileCopyWithImpl(this._self, this._then);

  final PickedAudioFile _self;
  final $Res Function(PickedAudioFile) _then;

/// Create a copy of PickedAudioFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? sizeBytes = null,Object? extension = null,Object? path = freezed,Object? persistentUri = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,persistentUri: freezed == persistentUri ? _self.persistentUri : persistentUri // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PickedAudioFile].
extension PickedAudioFilePatterns on PickedAudioFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PickedAudioFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PickedAudioFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PickedAudioFile value)  $default,){
final _that = this;
switch (_that) {
case _PickedAudioFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PickedAudioFile value)?  $default,){
final _that = this;
switch (_that) {
case _PickedAudioFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int sizeBytes,  String extension,  String? path,  String? persistentUri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PickedAudioFile() when $default != null:
return $default(_that.name,_that.sizeBytes,_that.extension,_that.path,_that.persistentUri);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int sizeBytes,  String extension,  String? path,  String? persistentUri)  $default,) {final _that = this;
switch (_that) {
case _PickedAudioFile():
return $default(_that.name,_that.sizeBytes,_that.extension,_that.path,_that.persistentUri);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int sizeBytes,  String extension,  String? path,  String? persistentUri)?  $default,) {final _that = this;
switch (_that) {
case _PickedAudioFile() when $default != null:
return $default(_that.name,_that.sizeBytes,_that.extension,_that.path,_that.persistentUri);case _:
  return null;

}
}

}

/// @nodoc


class _PickedAudioFile implements PickedAudioFile {
  const _PickedAudioFile({required this.name, required this.sizeBytes, required this.extension, this.path, this.persistentUri});


@override final  String name;
@override final  int sizeBytes;
@override final  String extension;
@override final  String? path;
@override final  String? persistentUri;

/// Create a copy of PickedAudioFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PickedAudioFileCopyWith<_PickedAudioFile> get copyWith => __$PickedAudioFileCopyWithImpl<_PickedAudioFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PickedAudioFile&&(identical(other.name, name) || other.name == name)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.path, path) || other.path == path)&&(identical(other.persistentUri, persistentUri) || other.persistentUri == persistentUri));
}


@override
int get hashCode => Object.hash(runtimeType,name,sizeBytes,extension,path,persistentUri);

@override
String toString() {
  return 'PickedAudioFile(name: $name, sizeBytes: $sizeBytes, extension: $extension, path: $path, persistentUri: $persistentUri)';
}


}

/// @nodoc
abstract mixin class _$PickedAudioFileCopyWith<$Res> implements $PickedAudioFileCopyWith<$Res> {
  factory _$PickedAudioFileCopyWith(_PickedAudioFile value, $Res Function(_PickedAudioFile) _then) = __$PickedAudioFileCopyWithImpl;
@override @useResult
$Res call({
 String name, int sizeBytes, String extension, String? path, String? persistentUri
});




}
/// @nodoc
class __$PickedAudioFileCopyWithImpl<$Res>
    implements _$PickedAudioFileCopyWith<$Res> {
  __$PickedAudioFileCopyWithImpl(this._self, this._then);

  final _PickedAudioFile _self;
  final $Res Function(_PickedAudioFile) _then;

/// Create a copy of PickedAudioFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? sizeBytes = null,Object? extension = null,Object? path = freezed,Object? persistentUri = freezed,}) {
  return _then(_PickedAudioFile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,persistentUri: freezed == persistentUri ? _self.persistentUri : persistentUri // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
