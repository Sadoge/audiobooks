// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_file_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EmbeddedChapter {

 String get title; Duration get start;
/// Create a copy of EmbeddedChapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmbeddedChapterCopyWith<EmbeddedChapter> get copyWith => _$EmbeddedChapterCopyWithImpl<EmbeddedChapter>(this as EmbeddedChapter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmbeddedChapter&&(identical(other.title, title) || other.title == title)&&(identical(other.start, start) || other.start == start));
}


@override
int get hashCode => Object.hash(runtimeType,title,start);

@override
String toString() {
  return 'EmbeddedChapter(title: $title, start: $start)';
}


}

/// @nodoc
abstract mixin class $EmbeddedChapterCopyWith<$Res>  {
  factory $EmbeddedChapterCopyWith(EmbeddedChapter value, $Res Function(EmbeddedChapter) _then) = _$EmbeddedChapterCopyWithImpl;
@useResult
$Res call({
 String title, Duration start
});




}
/// @nodoc
class _$EmbeddedChapterCopyWithImpl<$Res>
    implements $EmbeddedChapterCopyWith<$Res> {
  _$EmbeddedChapterCopyWithImpl(this._self, this._then);

  final EmbeddedChapter _self;
  final $Res Function(EmbeddedChapter) _then;

/// Create a copy of EmbeddedChapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? start = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [EmbeddedChapter].
extension EmbeddedChapterPatterns on EmbeddedChapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmbeddedChapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmbeddedChapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmbeddedChapter value)  $default,){
final _that = this;
switch (_that) {
case _EmbeddedChapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmbeddedChapter value)?  $default,){
final _that = this;
switch (_that) {
case _EmbeddedChapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  Duration start)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmbeddedChapter() when $default != null:
return $default(_that.title,_that.start);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  Duration start)  $default,) {final _that = this;
switch (_that) {
case _EmbeddedChapter():
return $default(_that.title,_that.start);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  Duration start)?  $default,) {final _that = this;
switch (_that) {
case _EmbeddedChapter() when $default != null:
return $default(_that.title,_that.start);case _:
  return null;

}
}

}

/// @nodoc


class _EmbeddedChapter implements EmbeddedChapter {
  const _EmbeddedChapter({required this.title, required this.start});
  

@override final  String title;
@override final  Duration start;

/// Create a copy of EmbeddedChapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmbeddedChapterCopyWith<_EmbeddedChapter> get copyWith => __$EmbeddedChapterCopyWithImpl<_EmbeddedChapter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmbeddedChapter&&(identical(other.title, title) || other.title == title)&&(identical(other.start, start) || other.start == start));
}


@override
int get hashCode => Object.hash(runtimeType,title,start);

@override
String toString() {
  return 'EmbeddedChapter(title: $title, start: $start)';
}


}

/// @nodoc
abstract mixin class _$EmbeddedChapterCopyWith<$Res> implements $EmbeddedChapterCopyWith<$Res> {
  factory _$EmbeddedChapterCopyWith(_EmbeddedChapter value, $Res Function(_EmbeddedChapter) _then) = __$EmbeddedChapterCopyWithImpl;
@override @useResult
$Res call({
 String title, Duration start
});




}
/// @nodoc
class __$EmbeddedChapterCopyWithImpl<$Res>
    implements _$EmbeddedChapterCopyWith<$Res> {
  __$EmbeddedChapterCopyWithImpl(this._self, this._then);

  final _EmbeddedChapter _self;
  final $Res Function(_EmbeddedChapter) _then;

/// Create a copy of EmbeddedChapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? start = null,}) {
  return _then(_EmbeddedChapter(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc
mixin _$AudioFileMetadata {

 Duration get duration; String? get title; String? get author; String? get narrator; List<EmbeddedChapter> get chapters;
/// Create a copy of AudioFileMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioFileMetadataCopyWith<AudioFileMetadata> get copyWith => _$AudioFileMetadataCopyWithImpl<AudioFileMetadata>(this as AudioFileMetadata, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioFileMetadata&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.narrator, narrator) || other.narrator == narrator)&&const DeepCollectionEquality().equals(other.chapters, chapters));
}


@override
int get hashCode => Object.hash(runtimeType,duration,title,author,narrator,const DeepCollectionEquality().hash(chapters));

@override
String toString() {
  return 'AudioFileMetadata(duration: $duration, title: $title, author: $author, narrator: $narrator, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class $AudioFileMetadataCopyWith<$Res>  {
  factory $AudioFileMetadataCopyWith(AudioFileMetadata value, $Res Function(AudioFileMetadata) _then) = _$AudioFileMetadataCopyWithImpl;
@useResult
$Res call({
 Duration duration, String? title, String? author, String? narrator, List<EmbeddedChapter> chapters
});




}
/// @nodoc
class _$AudioFileMetadataCopyWithImpl<$Res>
    implements $AudioFileMetadataCopyWith<$Res> {
  _$AudioFileMetadataCopyWithImpl(this._self, this._then);

  final AudioFileMetadata _self;
  final $Res Function(AudioFileMetadata) _then;

/// Create a copy of AudioFileMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,Object? title = freezed,Object? author = freezed,Object? narrator = freezed,Object? chapters = null,}) {
  return _then(_self.copyWith(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,narrator: freezed == narrator ? _self.narrator : narrator // ignore: cast_nullable_to_non_nullable
as String?,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<EmbeddedChapter>,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioFileMetadata].
extension AudioFileMetadataPatterns on AudioFileMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioFileMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioFileMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioFileMetadata value)  $default,){
final _that = this;
switch (_that) {
case _AudioFileMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioFileMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _AudioFileMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Duration duration,  String? title,  String? author,  String? narrator,  List<EmbeddedChapter> chapters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioFileMetadata() when $default != null:
return $default(_that.duration,_that.title,_that.author,_that.narrator,_that.chapters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Duration duration,  String? title,  String? author,  String? narrator,  List<EmbeddedChapter> chapters)  $default,) {final _that = this;
switch (_that) {
case _AudioFileMetadata():
return $default(_that.duration,_that.title,_that.author,_that.narrator,_that.chapters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Duration duration,  String? title,  String? author,  String? narrator,  List<EmbeddedChapter> chapters)?  $default,) {final _that = this;
switch (_that) {
case _AudioFileMetadata() when $default != null:
return $default(_that.duration,_that.title,_that.author,_that.narrator,_that.chapters);case _:
  return null;

}
}

}

/// @nodoc


class _AudioFileMetadata implements AudioFileMetadata {
  const _AudioFileMetadata({this.duration = Duration.zero, this.title, this.author, this.narrator, final  List<EmbeddedChapter> chapters = const <EmbeddedChapter>[]}): _chapters = chapters;
  

@override@JsonKey() final  Duration duration;
@override final  String? title;
@override final  String? author;
@override final  String? narrator;
 final  List<EmbeddedChapter> _chapters;
@override@JsonKey() List<EmbeddedChapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of AudioFileMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioFileMetadataCopyWith<_AudioFileMetadata> get copyWith => __$AudioFileMetadataCopyWithImpl<_AudioFileMetadata>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioFileMetadata&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.narrator, narrator) || other.narrator == narrator)&&const DeepCollectionEquality().equals(other._chapters, _chapters));
}


@override
int get hashCode => Object.hash(runtimeType,duration,title,author,narrator,const DeepCollectionEquality().hash(_chapters));

@override
String toString() {
  return 'AudioFileMetadata(duration: $duration, title: $title, author: $author, narrator: $narrator, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class _$AudioFileMetadataCopyWith<$Res> implements $AudioFileMetadataCopyWith<$Res> {
  factory _$AudioFileMetadataCopyWith(_AudioFileMetadata value, $Res Function(_AudioFileMetadata) _then) = __$AudioFileMetadataCopyWithImpl;
@override @useResult
$Res call({
 Duration duration, String? title, String? author, String? narrator, List<EmbeddedChapter> chapters
});




}
/// @nodoc
class __$AudioFileMetadataCopyWithImpl<$Res>
    implements _$AudioFileMetadataCopyWith<$Res> {
  __$AudioFileMetadataCopyWithImpl(this._self, this._then);

  final _AudioFileMetadata _self;
  final $Res Function(_AudioFileMetadata) _then;

/// Create a copy of AudioFileMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? duration = null,Object? title = freezed,Object? author = freezed,Object? narrator = freezed,Object? chapters = null,}) {
  return _then(_AudioFileMetadata(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,narrator: freezed == narrator ? _self.narrator : narrator // ignore: cast_nullable_to_non_nullable
as String?,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<EmbeddedChapter>,
  ));
}


}

// dart format on
