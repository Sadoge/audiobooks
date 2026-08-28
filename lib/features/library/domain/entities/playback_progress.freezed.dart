// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaybackProgress {

 String get bookId;/// Null for books that have no chapters at all.
 String? get chapterId;/// Offset inside [chapterId], or inside the book when it has no chapters.
 Duration get position;/// Offset on the whole book timeline, used for library progress.
 Duration get bookPosition; DateTime get updatedAt;
/// Create a copy of PlaybackProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackProgressCopyWith<PlaybackProgress> get copyWith => _$PlaybackProgressCopyWithImpl<PlaybackProgress>(this as PlaybackProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackProgress&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.position, position) || other.position == position)&&(identical(other.bookPosition, bookPosition) || other.bookPosition == bookPosition)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,bookId,chapterId,position,bookPosition,updatedAt);

@override
String toString() {
  return 'PlaybackProgress(bookId: $bookId, chapterId: $chapterId, position: $position, bookPosition: $bookPosition, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PlaybackProgressCopyWith<$Res>  {
  factory $PlaybackProgressCopyWith(PlaybackProgress value, $Res Function(PlaybackProgress) _then) = _$PlaybackProgressCopyWithImpl;
@useResult
$Res call({
 String bookId, String? chapterId, Duration position, Duration bookPosition, DateTime updatedAt
});




}
/// @nodoc
class _$PlaybackProgressCopyWithImpl<$Res>
    implements $PlaybackProgressCopyWith<$Res> {
  _$PlaybackProgressCopyWithImpl(this._self, this._then);

  final PlaybackProgress _self;
  final $Res Function(PlaybackProgress) _then;

/// Create a copy of PlaybackProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookId = null,Object? chapterId = freezed,Object? position = null,Object? bookPosition = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,chapterId: freezed == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,bookPosition: null == bookPosition ? _self.bookPosition : bookPosition // ignore: cast_nullable_to_non_nullable
as Duration,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaybackProgress].
extension PlaybackProgressPatterns on PlaybackProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackProgress value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackProgress value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String bookId,  String? chapterId,  Duration position,  Duration bookPosition,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackProgress() when $default != null:
return $default(_that.bookId,_that.chapterId,_that.position,_that.bookPosition,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String bookId,  String? chapterId,  Duration position,  Duration bookPosition,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PlaybackProgress():
return $default(_that.bookId,_that.chapterId,_that.position,_that.bookPosition,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String bookId,  String? chapterId,  Duration position,  Duration bookPosition,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackProgress() when $default != null:
return $default(_that.bookId,_that.chapterId,_that.position,_that.bookPosition,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _PlaybackProgress implements PlaybackProgress {
  const _PlaybackProgress({required this.bookId, this.chapterId, required this.position, this.bookPosition = Duration.zero, required this.updatedAt});
  

@override final  String bookId;
/// Null for books that have no chapters at all.
@override final  String? chapterId;
/// Offset inside [chapterId], or inside the book when it has no chapters.
@override final  Duration position;
/// Offset on the whole book timeline, used for library progress.
@override@JsonKey() final  Duration bookPosition;
@override final  DateTime updatedAt;

/// Create a copy of PlaybackProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackProgressCopyWith<_PlaybackProgress> get copyWith => __$PlaybackProgressCopyWithImpl<_PlaybackProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackProgress&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.position, position) || other.position == position)&&(identical(other.bookPosition, bookPosition) || other.bookPosition == bookPosition)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,bookId,chapterId,position,bookPosition,updatedAt);

@override
String toString() {
  return 'PlaybackProgress(bookId: $bookId, chapterId: $chapterId, position: $position, bookPosition: $bookPosition, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PlaybackProgressCopyWith<$Res> implements $PlaybackProgressCopyWith<$Res> {
  factory _$PlaybackProgressCopyWith(_PlaybackProgress value, $Res Function(_PlaybackProgress) _then) = __$PlaybackProgressCopyWithImpl;
@override @useResult
$Res call({
 String bookId, String? chapterId, Duration position, Duration bookPosition, DateTime updatedAt
});




}
/// @nodoc
class __$PlaybackProgressCopyWithImpl<$Res>
    implements _$PlaybackProgressCopyWith<$Res> {
  __$PlaybackProgressCopyWithImpl(this._self, this._then);

  final _PlaybackProgress _self;
  final $Res Function(_PlaybackProgress) _then;

/// Create a copy of PlaybackProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookId = null,Object? chapterId = freezed,Object? position = null,Object? bookPosition = null,Object? updatedAt = null,}) {
  return _then(_PlaybackProgress(
bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,chapterId: freezed == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,bookPosition: null == bookPosition ? _self.bookPosition : bookPosition // ignore: cast_nullable_to_non_nullable
as Duration,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
