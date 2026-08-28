// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_playback_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioPlaybackSnapshot {

 PlaybackStatus get status; String? get bookId; String? get chapterId; int get chapterIndex; int get chapterCount; Duration get position; Duration get bufferedPosition; Duration get duration; Duration get bookPosition; Duration get bookDuration; double get speed; String? get errorMessage;
/// Create a copy of AudioPlaybackSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioPlaybackSnapshotCopyWith<AudioPlaybackSnapshot> get copyWith => _$AudioPlaybackSnapshotCopyWithImpl<AudioPlaybackSnapshot>(this as AudioPlaybackSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioPlaybackSnapshot&&(identical(other.status, status) || other.status == status)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.chapterIndex, chapterIndex) || other.chapterIndex == chapterIndex)&&(identical(other.chapterCount, chapterCount) || other.chapterCount == chapterCount)&&(identical(other.position, position) || other.position == position)&&(identical(other.bufferedPosition, bufferedPosition) || other.bufferedPosition == bufferedPosition)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.bookPosition, bookPosition) || other.bookPosition == bookPosition)&&(identical(other.bookDuration, bookDuration) || other.bookDuration == bookDuration)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,bookId,chapterId,chapterIndex,chapterCount,position,bufferedPosition,duration,bookPosition,bookDuration,speed,errorMessage);

@override
String toString() {
  return 'AudioPlaybackSnapshot(status: $status, bookId: $bookId, chapterId: $chapterId, chapterIndex: $chapterIndex, chapterCount: $chapterCount, position: $position, bufferedPosition: $bufferedPosition, duration: $duration, bookPosition: $bookPosition, bookDuration: $bookDuration, speed: $speed, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $AudioPlaybackSnapshotCopyWith<$Res>  {
  factory $AudioPlaybackSnapshotCopyWith(AudioPlaybackSnapshot value, $Res Function(AudioPlaybackSnapshot) _then) = _$AudioPlaybackSnapshotCopyWithImpl;
@useResult
$Res call({
 PlaybackStatus status, String? bookId, String? chapterId, int chapterIndex, int chapterCount, Duration position, Duration bufferedPosition, Duration duration, Duration bookPosition, Duration bookDuration, double speed, String? errorMessage
});




}
/// @nodoc
class _$AudioPlaybackSnapshotCopyWithImpl<$Res>
    implements $AudioPlaybackSnapshotCopyWith<$Res> {
  _$AudioPlaybackSnapshotCopyWithImpl(this._self, this._then);

  final AudioPlaybackSnapshot _self;
  final $Res Function(AudioPlaybackSnapshot) _then;

/// Create a copy of AudioPlaybackSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? bookId = freezed,Object? chapterId = freezed,Object? chapterIndex = null,Object? chapterCount = null,Object? position = null,Object? bufferedPosition = null,Object? duration = null,Object? bookPosition = null,Object? bookDuration = null,Object? speed = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaybackStatus,bookId: freezed == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String?,chapterId: freezed == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String?,chapterIndex: null == chapterIndex ? _self.chapterIndex : chapterIndex // ignore: cast_nullable_to_non_nullable
as int,chapterCount: null == chapterCount ? _self.chapterCount : chapterCount // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,bufferedPosition: null == bufferedPosition ? _self.bufferedPosition : bufferedPosition // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,bookPosition: null == bookPosition ? _self.bookPosition : bookPosition // ignore: cast_nullable_to_non_nullable
as Duration,bookDuration: null == bookDuration ? _self.bookDuration : bookDuration // ignore: cast_nullable_to_non_nullable
as Duration,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioPlaybackSnapshot].
extension AudioPlaybackSnapshotPatterns on AudioPlaybackSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioPlaybackSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioPlaybackSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioPlaybackSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _AudioPlaybackSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioPlaybackSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _AudioPlaybackSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlaybackStatus status,  String? bookId,  String? chapterId,  int chapterIndex,  int chapterCount,  Duration position,  Duration bufferedPosition,  Duration duration,  Duration bookPosition,  Duration bookDuration,  double speed,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioPlaybackSnapshot() when $default != null:
return $default(_that.status,_that.bookId,_that.chapterId,_that.chapterIndex,_that.chapterCount,_that.position,_that.bufferedPosition,_that.duration,_that.bookPosition,_that.bookDuration,_that.speed,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlaybackStatus status,  String? bookId,  String? chapterId,  int chapterIndex,  int chapterCount,  Duration position,  Duration bufferedPosition,  Duration duration,  Duration bookPosition,  Duration bookDuration,  double speed,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _AudioPlaybackSnapshot():
return $default(_that.status,_that.bookId,_that.chapterId,_that.chapterIndex,_that.chapterCount,_that.position,_that.bufferedPosition,_that.duration,_that.bookPosition,_that.bookDuration,_that.speed,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlaybackStatus status,  String? bookId,  String? chapterId,  int chapterIndex,  int chapterCount,  Duration position,  Duration bufferedPosition,  Duration duration,  Duration bookPosition,  Duration bookDuration,  double speed,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _AudioPlaybackSnapshot() when $default != null:
return $default(_that.status,_that.bookId,_that.chapterId,_that.chapterIndex,_that.chapterCount,_that.position,_that.bufferedPosition,_that.duration,_that.bookPosition,_that.bookDuration,_that.speed,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _AudioPlaybackSnapshot implements AudioPlaybackSnapshot {
  const _AudioPlaybackSnapshot({this.status = PlaybackStatus.idle, this.bookId, this.chapterId, this.chapterIndex = -1, this.chapterCount = 0, this.position = Duration.zero, this.bufferedPosition = Duration.zero, this.duration = Duration.zero, this.bookPosition = Duration.zero, this.bookDuration = Duration.zero, this.speed = 1, this.errorMessage});
  

@override@JsonKey() final  PlaybackStatus status;
@override final  String? bookId;
@override final  String? chapterId;
@override@JsonKey() final  int chapterIndex;
@override@JsonKey() final  int chapterCount;
@override@JsonKey() final  Duration position;
@override@JsonKey() final  Duration bufferedPosition;
@override@JsonKey() final  Duration duration;
@override@JsonKey() final  Duration bookPosition;
@override@JsonKey() final  Duration bookDuration;
@override@JsonKey() final  double speed;
@override final  String? errorMessage;

/// Create a copy of AudioPlaybackSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioPlaybackSnapshotCopyWith<_AudioPlaybackSnapshot> get copyWith => __$AudioPlaybackSnapshotCopyWithImpl<_AudioPlaybackSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioPlaybackSnapshot&&(identical(other.status, status) || other.status == status)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.chapterIndex, chapterIndex) || other.chapterIndex == chapterIndex)&&(identical(other.chapterCount, chapterCount) || other.chapterCount == chapterCount)&&(identical(other.position, position) || other.position == position)&&(identical(other.bufferedPosition, bufferedPosition) || other.bufferedPosition == bufferedPosition)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.bookPosition, bookPosition) || other.bookPosition == bookPosition)&&(identical(other.bookDuration, bookDuration) || other.bookDuration == bookDuration)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,bookId,chapterId,chapterIndex,chapterCount,position,bufferedPosition,duration,bookPosition,bookDuration,speed,errorMessage);

@override
String toString() {
  return 'AudioPlaybackSnapshot(status: $status, bookId: $bookId, chapterId: $chapterId, chapterIndex: $chapterIndex, chapterCount: $chapterCount, position: $position, bufferedPosition: $bufferedPosition, duration: $duration, bookPosition: $bookPosition, bookDuration: $bookDuration, speed: $speed, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$AudioPlaybackSnapshotCopyWith<$Res> implements $AudioPlaybackSnapshotCopyWith<$Res> {
  factory _$AudioPlaybackSnapshotCopyWith(_AudioPlaybackSnapshot value, $Res Function(_AudioPlaybackSnapshot) _then) = __$AudioPlaybackSnapshotCopyWithImpl;
@override @useResult
$Res call({
 PlaybackStatus status, String? bookId, String? chapterId, int chapterIndex, int chapterCount, Duration position, Duration bufferedPosition, Duration duration, Duration bookPosition, Duration bookDuration, double speed, String? errorMessage
});




}
/// @nodoc
class __$AudioPlaybackSnapshotCopyWithImpl<$Res>
    implements _$AudioPlaybackSnapshotCopyWith<$Res> {
  __$AudioPlaybackSnapshotCopyWithImpl(this._self, this._then);

  final _AudioPlaybackSnapshot _self;
  final $Res Function(_AudioPlaybackSnapshot) _then;

/// Create a copy of AudioPlaybackSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? bookId = freezed,Object? chapterId = freezed,Object? chapterIndex = null,Object? chapterCount = null,Object? position = null,Object? bufferedPosition = null,Object? duration = null,Object? bookPosition = null,Object? bookDuration = null,Object? speed = null,Object? errorMessage = freezed,}) {
  return _then(_AudioPlaybackSnapshot(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaybackStatus,bookId: freezed == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String?,chapterId: freezed == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String?,chapterIndex: null == chapterIndex ? _self.chapterIndex : chapterIndex // ignore: cast_nullable_to_non_nullable
as int,chapterCount: null == chapterCount ? _self.chapterCount : chapterCount // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,bufferedPosition: null == bufferedPosition ? _self.bufferedPosition : bufferedPosition // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,bookPosition: null == bookPosition ? _self.bookPosition : bookPosition // ignore: cast_nullable_to_non_nullable
as Duration,bookDuration: null == bookDuration ? _self.bookDuration : bookDuration // ignore: cast_nullable_to_non_nullable
as Duration,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
