// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'storage_summary_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StorageSummaryState {

 StorageSummaryStatus get status; int get bookCount; int get usedBytes;
/// Create a copy of StorageSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageSummaryStateCopyWith<StorageSummaryState> get copyWith => _$StorageSummaryStateCopyWithImpl<StorageSummaryState>(this as StorageSummaryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageSummaryState&&(identical(other.status, status) || other.status == status)&&(identical(other.bookCount, bookCount) || other.bookCount == bookCount)&&(identical(other.usedBytes, usedBytes) || other.usedBytes == usedBytes));
}


@override
int get hashCode => Object.hash(runtimeType,status,bookCount,usedBytes);

@override
String toString() {
  return 'StorageSummaryState(status: $status, bookCount: $bookCount, usedBytes: $usedBytes)';
}


}

/// @nodoc
abstract mixin class $StorageSummaryStateCopyWith<$Res>  {
  factory $StorageSummaryStateCopyWith(StorageSummaryState value, $Res Function(StorageSummaryState) _then) = _$StorageSummaryStateCopyWithImpl;
@useResult
$Res call({
 StorageSummaryStatus status, int bookCount, int usedBytes
});




}
/// @nodoc
class _$StorageSummaryStateCopyWithImpl<$Res>
    implements $StorageSummaryStateCopyWith<$Res> {
  _$StorageSummaryStateCopyWithImpl(this._self, this._then);

  final StorageSummaryState _self;
  final $Res Function(StorageSummaryState) _then;

/// Create a copy of StorageSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? bookCount = null,Object? usedBytes = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StorageSummaryStatus,bookCount: null == bookCount ? _self.bookCount : bookCount // ignore: cast_nullable_to_non_nullable
as int,usedBytes: null == usedBytes ? _self.usedBytes : usedBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageSummaryState].
extension StorageSummaryStatePatterns on StorageSummaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageSummaryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageSummaryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageSummaryState value)  $default,){
final _that = this;
switch (_that) {
case _StorageSummaryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageSummaryState value)?  $default,){
final _that = this;
switch (_that) {
case _StorageSummaryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StorageSummaryStatus status,  int bookCount,  int usedBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageSummaryState() when $default != null:
return $default(_that.status,_that.bookCount,_that.usedBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StorageSummaryStatus status,  int bookCount,  int usedBytes)  $default,) {final _that = this;
switch (_that) {
case _StorageSummaryState():
return $default(_that.status,_that.bookCount,_that.usedBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StorageSummaryStatus status,  int bookCount,  int usedBytes)?  $default,) {final _that = this;
switch (_that) {
case _StorageSummaryState() when $default != null:
return $default(_that.status,_that.bookCount,_that.usedBytes);case _:
  return null;

}
}

}

/// @nodoc


class _StorageSummaryState implements StorageSummaryState {
  const _StorageSummaryState({this.status = StorageSummaryStatus.loading, this.bookCount = 0, this.usedBytes = 0});
  

@override@JsonKey() final  StorageSummaryStatus status;
@override@JsonKey() final  int bookCount;
@override@JsonKey() final  int usedBytes;

/// Create a copy of StorageSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageSummaryStateCopyWith<_StorageSummaryState> get copyWith => __$StorageSummaryStateCopyWithImpl<_StorageSummaryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageSummaryState&&(identical(other.status, status) || other.status == status)&&(identical(other.bookCount, bookCount) || other.bookCount == bookCount)&&(identical(other.usedBytes, usedBytes) || other.usedBytes == usedBytes));
}


@override
int get hashCode => Object.hash(runtimeType,status,bookCount,usedBytes);

@override
String toString() {
  return 'StorageSummaryState(status: $status, bookCount: $bookCount, usedBytes: $usedBytes)';
}


}

/// @nodoc
abstract mixin class _$StorageSummaryStateCopyWith<$Res> implements $StorageSummaryStateCopyWith<$Res> {
  factory _$StorageSummaryStateCopyWith(_StorageSummaryState value, $Res Function(_StorageSummaryState) _then) = __$StorageSummaryStateCopyWithImpl;
@override @useResult
$Res call({
 StorageSummaryStatus status, int bookCount, int usedBytes
});




}
/// @nodoc
class __$StorageSummaryStateCopyWithImpl<$Res>
    implements _$StorageSummaryStateCopyWith<$Res> {
  __$StorageSummaryStateCopyWithImpl(this._self, this._then);

  final _StorageSummaryState _self;
  final $Res Function(_StorageSummaryState) _then;

/// Create a copy of StorageSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? bookCount = null,Object? usedBytes = null,}) {
  return _then(_StorageSummaryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StorageSummaryStatus,bookCount: null == bookCount ? _self.bookCount : bookCount // ignore: cast_nullable_to_non_nullable
as int,usedBytes: null == usedBytes ? _self.usedBytes : usedBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
