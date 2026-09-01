// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaybackSettings {

/// The speed every book opens at.
 double get speed;/// What the rewind key on the wheel steps back by.
 Duration get rewindInterval;/// What the forward key on the wheel steps on by.
 Duration get forwardInterval;/// How far back a resumed book picks up from where it was left, which is
/// how a listener catches the run-up to the sentence they stopped on.
/// Zero resumes exactly where they were.
 Duration get resumeRewind;
/// Create a copy of PlaybackSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackSettingsCopyWith<PlaybackSettings> get copyWith => _$PlaybackSettingsCopyWithImpl<PlaybackSettings>(this as PlaybackSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackSettings&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.rewindInterval, rewindInterval) || other.rewindInterval == rewindInterval)&&(identical(other.forwardInterval, forwardInterval) || other.forwardInterval == forwardInterval)&&(identical(other.resumeRewind, resumeRewind) || other.resumeRewind == resumeRewind));
}


@override
int get hashCode => Object.hash(runtimeType,speed,rewindInterval,forwardInterval,resumeRewind);

@override
String toString() {
  return 'PlaybackSettings(speed: $speed, rewindInterval: $rewindInterval, forwardInterval: $forwardInterval, resumeRewind: $resumeRewind)';
}


}

/// @nodoc
abstract mixin class $PlaybackSettingsCopyWith<$Res>  {
  factory $PlaybackSettingsCopyWith(PlaybackSettings value, $Res Function(PlaybackSettings) _then) = _$PlaybackSettingsCopyWithImpl;
@useResult
$Res call({
 double speed, Duration rewindInterval, Duration forwardInterval, Duration resumeRewind
});




}
/// @nodoc
class _$PlaybackSettingsCopyWithImpl<$Res>
    implements $PlaybackSettingsCopyWith<$Res> {
  _$PlaybackSettingsCopyWithImpl(this._self, this._then);

  final PlaybackSettings _self;
  final $Res Function(PlaybackSettings) _then;

/// Create a copy of PlaybackSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? speed = null,Object? rewindInterval = null,Object? forwardInterval = null,Object? resumeRewind = null,}) {
  return _then(_self.copyWith(
speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,rewindInterval: null == rewindInterval ? _self.rewindInterval : rewindInterval // ignore: cast_nullable_to_non_nullable
as Duration,forwardInterval: null == forwardInterval ? _self.forwardInterval : forwardInterval // ignore: cast_nullable_to_non_nullable
as Duration,resumeRewind: null == resumeRewind ? _self.resumeRewind : resumeRewind // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaybackSettings].
extension PlaybackSettingsPatterns on PlaybackSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackSettings value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double speed,  Duration rewindInterval,  Duration forwardInterval,  Duration resumeRewind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackSettings() when $default != null:
return $default(_that.speed,_that.rewindInterval,_that.forwardInterval,_that.resumeRewind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double speed,  Duration rewindInterval,  Duration forwardInterval,  Duration resumeRewind)  $default,) {final _that = this;
switch (_that) {
case _PlaybackSettings():
return $default(_that.speed,_that.rewindInterval,_that.forwardInterval,_that.resumeRewind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double speed,  Duration rewindInterval,  Duration forwardInterval,  Duration resumeRewind)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackSettings() when $default != null:
return $default(_that.speed,_that.rewindInterval,_that.forwardInterval,_that.resumeRewind);case _:
  return null;

}
}

}

/// @nodoc


class _PlaybackSettings implements PlaybackSettings {
  const _PlaybackSettings({this.speed = 1.0, this.rewindInterval = const Duration(seconds: 15), this.forwardInterval = const Duration(seconds: 30), this.resumeRewind = Duration.zero});
  

/// The speed every book opens at.
@override@JsonKey() final  double speed;
/// What the rewind key on the wheel steps back by.
@override@JsonKey() final  Duration rewindInterval;
/// What the forward key on the wheel steps on by.
@override@JsonKey() final  Duration forwardInterval;
/// How far back a resumed book picks up from where it was left, which is
/// how a listener catches the run-up to the sentence they stopped on.
/// Zero resumes exactly where they were.
@override@JsonKey() final  Duration resumeRewind;

/// Create a copy of PlaybackSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackSettingsCopyWith<_PlaybackSettings> get copyWith => __$PlaybackSettingsCopyWithImpl<_PlaybackSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackSettings&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.rewindInterval, rewindInterval) || other.rewindInterval == rewindInterval)&&(identical(other.forwardInterval, forwardInterval) || other.forwardInterval == forwardInterval)&&(identical(other.resumeRewind, resumeRewind) || other.resumeRewind == resumeRewind));
}


@override
int get hashCode => Object.hash(runtimeType,speed,rewindInterval,forwardInterval,resumeRewind);

@override
String toString() {
  return 'PlaybackSettings(speed: $speed, rewindInterval: $rewindInterval, forwardInterval: $forwardInterval, resumeRewind: $resumeRewind)';
}


}

/// @nodoc
abstract mixin class _$PlaybackSettingsCopyWith<$Res> implements $PlaybackSettingsCopyWith<$Res> {
  factory _$PlaybackSettingsCopyWith(_PlaybackSettings value, $Res Function(_PlaybackSettings) _then) = __$PlaybackSettingsCopyWithImpl;
@override @useResult
$Res call({
 double speed, Duration rewindInterval, Duration forwardInterval, Duration resumeRewind
});




}
/// @nodoc
class __$PlaybackSettingsCopyWithImpl<$Res>
    implements _$PlaybackSettingsCopyWith<$Res> {
  __$PlaybackSettingsCopyWithImpl(this._self, this._then);

  final _PlaybackSettings _self;
  final $Res Function(_PlaybackSettings) _then;

/// Create a copy of PlaybackSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? speed = null,Object? rewindInterval = null,Object? forwardInterval = null,Object? resumeRewind = null,}) {
  return _then(_PlaybackSettings(
speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,rewindInterval: null == rewindInterval ? _self.rewindInterval : rewindInterval // ignore: cast_nullable_to_non_nullable
as Duration,forwardInterval: null == forwardInterval ? _self.forwardInterval : forwardInterval // ignore: cast_nullable_to_non_nullable
as Duration,resumeRewind: null == resumeRewind ? _self.resumeRewind : resumeRewind // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
