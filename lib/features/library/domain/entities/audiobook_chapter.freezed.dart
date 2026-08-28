// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audiobook_chapter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudiobookChapter {

 String get id; String get bookId; String get title; int get index; String get filePath; Duration get duration; Duration get startPosition;
/// Create a copy of AudiobookChapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudiobookChapterCopyWith<AudiobookChapter> get copyWith => _$AudiobookChapterCopyWithImpl<AudiobookChapter>(this as AudiobookChapter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudiobookChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.title, title) || other.title == title)&&(identical(other.index, index) || other.index == index)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.startPosition, startPosition) || other.startPosition == startPosition));
}


@override
int get hashCode => Object.hash(runtimeType,id,bookId,title,index,filePath,duration,startPosition);

@override
String toString() {
  return 'AudiobookChapter(id: $id, bookId: $bookId, title: $title, index: $index, filePath: $filePath, duration: $duration, startPosition: $startPosition)';
}


}

/// @nodoc
abstract mixin class $AudiobookChapterCopyWith<$Res>  {
  factory $AudiobookChapterCopyWith(AudiobookChapter value, $Res Function(AudiobookChapter) _then) = _$AudiobookChapterCopyWithImpl;
@useResult
$Res call({
 String id, String bookId, String title, int index, String filePath, Duration duration, Duration startPosition
});




}
/// @nodoc
class _$AudiobookChapterCopyWithImpl<$Res>
    implements $AudiobookChapterCopyWith<$Res> {
  _$AudiobookChapterCopyWithImpl(this._self, this._then);

  final AudiobookChapter _self;
  final $Res Function(AudiobookChapter) _then;

/// Create a copy of AudiobookChapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? title = null,Object? index = null,Object? filePath = null,Object? duration = null,Object? startPosition = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,startPosition: null == startPosition ? _self.startPosition : startPosition // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}

}


/// Adds pattern-matching-related methods to [AudiobookChapter].
extension AudiobookChapterPatterns on AudiobookChapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudiobookChapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudiobookChapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudiobookChapter value)  $default,){
final _that = this;
switch (_that) {
case _AudiobookChapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudiobookChapter value)?  $default,){
final _that = this;
switch (_that) {
case _AudiobookChapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookId,  String title,  int index,  String filePath,  Duration duration,  Duration startPosition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudiobookChapter() when $default != null:
return $default(_that.id,_that.bookId,_that.title,_that.index,_that.filePath,_that.duration,_that.startPosition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookId,  String title,  int index,  String filePath,  Duration duration,  Duration startPosition)  $default,) {final _that = this;
switch (_that) {
case _AudiobookChapter():
return $default(_that.id,_that.bookId,_that.title,_that.index,_that.filePath,_that.duration,_that.startPosition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookId,  String title,  int index,  String filePath,  Duration duration,  Duration startPosition)?  $default,) {final _that = this;
switch (_that) {
case _AudiobookChapter() when $default != null:
return $default(_that.id,_that.bookId,_that.title,_that.index,_that.filePath,_that.duration,_that.startPosition);case _:
  return null;

}
}

}

/// @nodoc


class _AudiobookChapter implements AudiobookChapter {
  const _AudiobookChapter({required this.id, required this.bookId, required this.title, required this.index, required this.filePath, this.duration = Duration.zero, this.startPosition = Duration.zero});


@override final  String id;
@override final  String bookId;
@override final  String title;
@override final  int index;
@override final  String filePath;
@override@JsonKey() final  Duration duration;
@override@JsonKey() final  Duration startPosition;

/// Create a copy of AudiobookChapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudiobookChapterCopyWith<_AudiobookChapter> get copyWith => __$AudiobookChapterCopyWithImpl<_AudiobookChapter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudiobookChapter&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.title, title) || other.title == title)&&(identical(other.index, index) || other.index == index)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.startPosition, startPosition) || other.startPosition == startPosition));
}


@override
int get hashCode => Object.hash(runtimeType,id,bookId,title,index,filePath,duration,startPosition);

@override
String toString() {
  return 'AudiobookChapter(id: $id, bookId: $bookId, title: $title, index: $index, filePath: $filePath, duration: $duration, startPosition: $startPosition)';
}


}

/// @nodoc
abstract mixin class _$AudiobookChapterCopyWith<$Res> implements $AudiobookChapterCopyWith<$Res> {
  factory _$AudiobookChapterCopyWith(_AudiobookChapter value, $Res Function(_AudiobookChapter) _then) = __$AudiobookChapterCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookId, String title, int index, String filePath, Duration duration, Duration startPosition
});




}
/// @nodoc
class __$AudiobookChapterCopyWithImpl<$Res>
    implements _$AudiobookChapterCopyWith<$Res> {
  __$AudiobookChapterCopyWithImpl(this._self, this._then);

  final _AudiobookChapter _self;
  final $Res Function(_AudiobookChapter) _then;

/// Create a copy of AudiobookChapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? title = null,Object? index = null,Object? filePath = null,Object? duration = null,Object? startPosition = null,}) {
  return _then(_AudiobookChapter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,startPosition: null == startPosition ? _self.startPosition : startPosition // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

// dart format on
