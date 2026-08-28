// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerViewState {

 PlayerViewStatus get status; Audiobook? get book; AudioPlaybackSnapshot get playback; String? get errorMessage;
/// Create a copy of PlayerViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerViewStateCopyWith<PlayerViewState> get copyWith => _$PlayerViewStateCopyWithImpl<PlayerViewState>(this as PlayerViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerViewState&&(identical(other.status, status) || other.status == status)&&(identical(other.book, book) || other.book == book)&&(identical(other.playback, playback) || other.playback == playback)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,book,playback,errorMessage);

@override
String toString() {
  return 'PlayerViewState(status: $status, book: $book, playback: $playback, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PlayerViewStateCopyWith<$Res>  {
  factory $PlayerViewStateCopyWith(PlayerViewState value, $Res Function(PlayerViewState) _then) = _$PlayerViewStateCopyWithImpl;
@useResult
$Res call({
 PlayerViewStatus status, Audiobook? book, AudioPlaybackSnapshot playback, String? errorMessage
});


$AudiobookCopyWith<$Res>? get book;$AudioPlaybackSnapshotCopyWith<$Res> get playback;

}
/// @nodoc
class _$PlayerViewStateCopyWithImpl<$Res>
    implements $PlayerViewStateCopyWith<$Res> {
  _$PlayerViewStateCopyWithImpl(this._self, this._then);

  final PlayerViewState _self;
  final $Res Function(PlayerViewState) _then;

/// Create a copy of PlayerViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? book = freezed,Object? playback = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlayerViewStatus,book: freezed == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as Audiobook?,playback: null == playback ? _self.playback : playback // ignore: cast_nullable_to_non_nullable
as AudioPlaybackSnapshot,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PlayerViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudiobookCopyWith<$Res>? get book {
    if (_self.book == null) {
    return null;
  }

  return $AudiobookCopyWith<$Res>(_self.book!, (value) {
    return _then(_self.copyWith(book: value));
  });
}/// Create a copy of PlayerViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioPlaybackSnapshotCopyWith<$Res> get playback {
  
  return $AudioPlaybackSnapshotCopyWith<$Res>(_self.playback, (value) {
    return _then(_self.copyWith(playback: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayerViewState].
extension PlayerViewStatePatterns on PlayerViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerViewState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerViewState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlayerViewStatus status,  Audiobook? book,  AudioPlaybackSnapshot playback,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerViewState() when $default != null:
return $default(_that.status,_that.book,_that.playback,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlayerViewStatus status,  Audiobook? book,  AudioPlaybackSnapshot playback,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PlayerViewState():
return $default(_that.status,_that.book,_that.playback,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlayerViewStatus status,  Audiobook? book,  AudioPlaybackSnapshot playback,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PlayerViewState() when $default != null:
return $default(_that.status,_that.book,_that.playback,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerViewState implements PlayerViewState {
  const _PlayerViewState({this.status = PlayerViewStatus.loading, this.book, this.playback = const AudioPlaybackSnapshot(), this.errorMessage});
  

@override@JsonKey() final  PlayerViewStatus status;
@override final  Audiobook? book;
@override@JsonKey() final  AudioPlaybackSnapshot playback;
@override final  String? errorMessage;

/// Create a copy of PlayerViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerViewStateCopyWith<_PlayerViewState> get copyWith => __$PlayerViewStateCopyWithImpl<_PlayerViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerViewState&&(identical(other.status, status) || other.status == status)&&(identical(other.book, book) || other.book == book)&&(identical(other.playback, playback) || other.playback == playback)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,book,playback,errorMessage);

@override
String toString() {
  return 'PlayerViewState(status: $status, book: $book, playback: $playback, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PlayerViewStateCopyWith<$Res> implements $PlayerViewStateCopyWith<$Res> {
  factory _$PlayerViewStateCopyWith(_PlayerViewState value, $Res Function(_PlayerViewState) _then) = __$PlayerViewStateCopyWithImpl;
@override @useResult
$Res call({
 PlayerViewStatus status, Audiobook? book, AudioPlaybackSnapshot playback, String? errorMessage
});


@override $AudiobookCopyWith<$Res>? get book;@override $AudioPlaybackSnapshotCopyWith<$Res> get playback;

}
/// @nodoc
class __$PlayerViewStateCopyWithImpl<$Res>
    implements _$PlayerViewStateCopyWith<$Res> {
  __$PlayerViewStateCopyWithImpl(this._self, this._then);

  final _PlayerViewState _self;
  final $Res Function(_PlayerViewState) _then;

/// Create a copy of PlayerViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? book = freezed,Object? playback = null,Object? errorMessage = freezed,}) {
  return _then(_PlayerViewState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlayerViewStatus,book: freezed == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as Audiobook?,playback: null == playback ? _self.playback : playback // ignore: cast_nullable_to_non_nullable
as AudioPlaybackSnapshot,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PlayerViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudiobookCopyWith<$Res>? get book {
    if (_self.book == null) {
    return null;
  }

  return $AudiobookCopyWith<$Res>(_self.book!, (value) {
    return _then(_self.copyWith(book: value));
  });
}/// Create a copy of PlayerViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioPlaybackSnapshotCopyWith<$Res> get playback {
  
  return $AudioPlaybackSnapshotCopyWith<$Res>(_self.playback, (value) {
    return _then(_self.copyWith(playback: value));
  });
}
}

// dart format on
