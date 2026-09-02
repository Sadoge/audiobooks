// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shelf_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShelfFolder {

/// The directory path, or the document tree URI, depending on [access].
 String get location; ShelfFolderAccess get access;
/// Create a copy of ShelfFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShelfFolderCopyWith<ShelfFolder> get copyWith => _$ShelfFolderCopyWithImpl<ShelfFolder>(this as ShelfFolder, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShelfFolder&&(identical(other.location, location) || other.location == location)&&(identical(other.access, access) || other.access == access));
}


@override
int get hashCode => Object.hash(runtimeType,location,access);

@override
String toString() {
  return 'ShelfFolder(location: $location, access: $access)';
}


}

/// @nodoc
abstract mixin class $ShelfFolderCopyWith<$Res>  {
  factory $ShelfFolderCopyWith(ShelfFolder value, $Res Function(ShelfFolder) _then) = _$ShelfFolderCopyWithImpl;
@useResult
$Res call({
 String location, ShelfFolderAccess access
});




}
/// @nodoc
class _$ShelfFolderCopyWithImpl<$Res>
    implements $ShelfFolderCopyWith<$Res> {
  _$ShelfFolderCopyWithImpl(this._self, this._then);

  final ShelfFolder _self;
  final $Res Function(ShelfFolder) _then;

/// Create a copy of ShelfFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? location = null,Object? access = null,}) {
  return _then(_self.copyWith(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as ShelfFolderAccess,
  ));
}

}


/// Adds pattern-matching-related methods to [ShelfFolder].
extension ShelfFolderPatterns on ShelfFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShelfFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShelfFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShelfFolder value)  $default,){
final _that = this;
switch (_that) {
case _ShelfFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShelfFolder value)?  $default,){
final _that = this;
switch (_that) {
case _ShelfFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String location,  ShelfFolderAccess access)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShelfFolder() when $default != null:
return $default(_that.location,_that.access);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String location,  ShelfFolderAccess access)  $default,) {final _that = this;
switch (_that) {
case _ShelfFolder():
return $default(_that.location,_that.access);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String location,  ShelfFolderAccess access)?  $default,) {final _that = this;
switch (_that) {
case _ShelfFolder() when $default != null:
return $default(_that.location,_that.access);case _:
  return null;

}
}

}

/// @nodoc


class _ShelfFolder extends ShelfFolder {
  const _ShelfFolder({required this.location, required this.access}): super._();
  

/// The directory path, or the document tree URI, depending on [access].
@override final  String location;
@override final  ShelfFolderAccess access;

/// Create a copy of ShelfFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShelfFolderCopyWith<_ShelfFolder> get copyWith => __$ShelfFolderCopyWithImpl<_ShelfFolder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShelfFolder&&(identical(other.location, location) || other.location == location)&&(identical(other.access, access) || other.access == access));
}


@override
int get hashCode => Object.hash(runtimeType,location,access);

@override
String toString() {
  return 'ShelfFolder(location: $location, access: $access)';
}


}

/// @nodoc
abstract mixin class _$ShelfFolderCopyWith<$Res> implements $ShelfFolderCopyWith<$Res> {
  factory _$ShelfFolderCopyWith(_ShelfFolder value, $Res Function(_ShelfFolder) _then) = __$ShelfFolderCopyWithImpl;
@override @useResult
$Res call({
 String location, ShelfFolderAccess access
});




}
/// @nodoc
class __$ShelfFolderCopyWithImpl<$Res>
    implements _$ShelfFolderCopyWith<$Res> {
  __$ShelfFolderCopyWithImpl(this._self, this._then);

  final _ShelfFolder _self;
  final $Res Function(_ShelfFolder) _then;

/// Create a copy of ShelfFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? location = null,Object? access = null,}) {
  return _then(_ShelfFolder(
location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as ShelfFolderAccess,
  ));
}


}

// dart format on
