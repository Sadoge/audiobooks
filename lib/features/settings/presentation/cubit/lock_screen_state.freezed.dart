// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lock_screen_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LockScreenState {

 LockScreenStatus get status;/// What the system said, when the session could not be started.
 String? get errorMessage;
/// Create a copy of LockScreenState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LockScreenStateCopyWith<LockScreenState> get copyWith => _$LockScreenStateCopyWithImpl<LockScreenState>(this as LockScreenState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LockScreenState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage);

@override
String toString() {
  return 'LockScreenState(status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $LockScreenStateCopyWith<$Res>  {
  factory $LockScreenStateCopyWith(LockScreenState value, $Res Function(LockScreenState) _then) = _$LockScreenStateCopyWithImpl;
@useResult
$Res call({
 LockScreenStatus status, String? errorMessage
});




}
/// @nodoc
class _$LockScreenStateCopyWithImpl<$Res>
    implements $LockScreenStateCopyWith<$Res> {
  _$LockScreenStateCopyWithImpl(this._self, this._then);

  final LockScreenState _self;
  final $Res Function(LockScreenState) _then;

/// Create a copy of LockScreenState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LockScreenStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LockScreenState].
extension LockScreenStatePatterns on LockScreenState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LockScreenState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LockScreenState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LockScreenState value)  $default,){
final _that = this;
switch (_that) {
case _LockScreenState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LockScreenState value)?  $default,){
final _that = this;
switch (_that) {
case _LockScreenState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LockScreenStatus status,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LockScreenState() when $default != null:
return $default(_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LockScreenStatus status,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _LockScreenState():
return $default(_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LockScreenStatus status,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _LockScreenState() when $default != null:
return $default(_that.status,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _LockScreenState implements LockScreenState {
  const _LockScreenState({this.status = LockScreenStatus.checking, this.errorMessage});
  

@override@JsonKey() final  LockScreenStatus status;
/// What the system said, when the session could not be started.
@override final  String? errorMessage;

/// Create a copy of LockScreenState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LockScreenStateCopyWith<_LockScreenState> get copyWith => __$LockScreenStateCopyWithImpl<_LockScreenState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LockScreenState&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,errorMessage);

@override
String toString() {
  return 'LockScreenState(status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$LockScreenStateCopyWith<$Res> implements $LockScreenStateCopyWith<$Res> {
  factory _$LockScreenStateCopyWith(_LockScreenState value, $Res Function(_LockScreenState) _then) = __$LockScreenStateCopyWithImpl;
@override @useResult
$Res call({
 LockScreenStatus status, String? errorMessage
});




}
/// @nodoc
class __$LockScreenStateCopyWithImpl<$Res>
    implements _$LockScreenStateCopyWith<$Res> {
  __$LockScreenStateCopyWithImpl(this._self, this._then);

  final _LockScreenState _self;
  final $Res Function(_LockScreenState) _then;

/// Create a copy of LockScreenState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_LockScreenState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LockScreenStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
