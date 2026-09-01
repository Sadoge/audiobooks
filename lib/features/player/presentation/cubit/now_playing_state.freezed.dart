// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'now_playing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NowPlayingState {

 Audiobook? get book; AudioPlaybackSnapshot get playback;
/// Create a copy of NowPlayingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NowPlayingStateCopyWith<NowPlayingState> get copyWith => _$NowPlayingStateCopyWithImpl<NowPlayingState>(this as NowPlayingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NowPlayingState&&(identical(other.book, book) || other.book == book)&&(identical(other.playback, playback) || other.playback == playback));
}


@override
int get hashCode => Object.hash(runtimeType,book,playback);

@override
String toString() {
  return 'NowPlayingState(book: $book, playback: $playback)';
}


}

/// @nodoc
abstract mixin class $NowPlayingStateCopyWith<$Res>  {
  factory $NowPlayingStateCopyWith(NowPlayingState value, $Res Function(NowPlayingState) _then) = _$NowPlayingStateCopyWithImpl;
@useResult
$Res call({
 Audiobook? book, AudioPlaybackSnapshot playback
});


$AudiobookCopyWith<$Res>? get book;$AudioPlaybackSnapshotCopyWith<$Res> get playback;

}
/// @nodoc
class _$NowPlayingStateCopyWithImpl<$Res>
    implements $NowPlayingStateCopyWith<$Res> {
  _$NowPlayingStateCopyWithImpl(this._self, this._then);

  final NowPlayingState _self;
  final $Res Function(NowPlayingState) _then;

/// Create a copy of NowPlayingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? book = freezed,Object? playback = null,}) {
  return _then(_self.copyWith(
book: freezed == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as Audiobook?,playback: null == playback ? _self.playback : playback // ignore: cast_nullable_to_non_nullable
as AudioPlaybackSnapshot,
  ));
}
/// Create a copy of NowPlayingState
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
}/// Create a copy of NowPlayingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioPlaybackSnapshotCopyWith<$Res> get playback {
  
  return $AudioPlaybackSnapshotCopyWith<$Res>(_self.playback, (value) {
    return _then(_self.copyWith(playback: value));
  });
}
}


/// Adds pattern-matching-related methods to [NowPlayingState].
extension NowPlayingStatePatterns on NowPlayingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NowPlayingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NowPlayingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NowPlayingState value)  $default,){
final _that = this;
switch (_that) {
case _NowPlayingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NowPlayingState value)?  $default,){
final _that = this;
switch (_that) {
case _NowPlayingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Audiobook? book,  AudioPlaybackSnapshot playback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NowPlayingState() when $default != null:
return $default(_that.book,_that.playback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Audiobook? book,  AudioPlaybackSnapshot playback)  $default,) {final _that = this;
switch (_that) {
case _NowPlayingState():
return $default(_that.book,_that.playback);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Audiobook? book,  AudioPlaybackSnapshot playback)?  $default,) {final _that = this;
switch (_that) {
case _NowPlayingState() when $default != null:
return $default(_that.book,_that.playback);case _:
  return null;

}
}

}

/// @nodoc


class _NowPlayingState extends NowPlayingState {
  const _NowPlayingState({this.book, this.playback = const AudioPlaybackSnapshot()}): super._();
  

@override final  Audiobook? book;
@override@JsonKey() final  AudioPlaybackSnapshot playback;

/// Create a copy of NowPlayingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NowPlayingStateCopyWith<_NowPlayingState> get copyWith => __$NowPlayingStateCopyWithImpl<_NowPlayingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NowPlayingState&&(identical(other.book, book) || other.book == book)&&(identical(other.playback, playback) || other.playback == playback));
}


@override
int get hashCode => Object.hash(runtimeType,book,playback);

@override
String toString() {
  return 'NowPlayingState(book: $book, playback: $playback)';
}


}

/// @nodoc
abstract mixin class _$NowPlayingStateCopyWith<$Res> implements $NowPlayingStateCopyWith<$Res> {
  factory _$NowPlayingStateCopyWith(_NowPlayingState value, $Res Function(_NowPlayingState) _then) = __$NowPlayingStateCopyWithImpl;
@override @useResult
$Res call({
 Audiobook? book, AudioPlaybackSnapshot playback
});


@override $AudiobookCopyWith<$Res>? get book;@override $AudioPlaybackSnapshotCopyWith<$Res> get playback;

}
/// @nodoc
class __$NowPlayingStateCopyWithImpl<$Res>
    implements _$NowPlayingStateCopyWith<$Res> {
  __$NowPlayingStateCopyWithImpl(this._self, this._then);

  final _NowPlayingState _self;
  final $Res Function(_NowPlayingState) _then;

/// Create a copy of NowPlayingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? book = freezed,Object? playback = null,}) {
  return _then(_NowPlayingState(
book: freezed == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as Audiobook?,playback: null == playback ? _self.playback : playback // ignore: cast_nullable_to_non_nullable
as AudioPlaybackSnapshot,
  ));
}

/// Create a copy of NowPlayingState
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
}/// Create a copy of NowPlayingState
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
