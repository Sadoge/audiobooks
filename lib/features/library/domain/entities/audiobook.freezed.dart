// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audiobook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Audiobook {

 String get id; String get title; String get author; DateTime get dateAdded; AudioFileType get fileType; String? get narrator; String? get coverPath; String? get sourcePath;/// The key this book carries in the shared library folder, when it came
/// from there or was published to it. It is what lets the shelf tell that
/// this device already has the book and leave it off the list.
 String? get shelfKey; Duration get duration; Duration get currentPosition; DateTime? get lastPlayedAt; bool get isFinished; List<AudiobookChapter> get chapters;
/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudiobookCopyWith<Audiobook> get copyWith => _$AudiobookCopyWithImpl<Audiobook>(this as Audiobook, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Audiobook&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.narrator, narrator) || other.narrator == narrator)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.sourcePath, sourcePath) || other.sourcePath == sourcePath)&&(identical(other.shelfKey, shelfKey) || other.shelfKey == shelfKey)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.lastPlayedAt, lastPlayedAt) || other.lastPlayedAt == lastPlayedAt)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&const DeepCollectionEquality().equals(other.chapters, chapters));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,author,dateAdded,fileType,narrator,coverPath,sourcePath,shelfKey,duration,currentPosition,lastPlayedAt,isFinished,const DeepCollectionEquality().hash(chapters));

@override
String toString() {
  return 'Audiobook(id: $id, title: $title, author: $author, dateAdded: $dateAdded, fileType: $fileType, narrator: $narrator, coverPath: $coverPath, sourcePath: $sourcePath, shelfKey: $shelfKey, duration: $duration, currentPosition: $currentPosition, lastPlayedAt: $lastPlayedAt, isFinished: $isFinished, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class $AudiobookCopyWith<$Res>  {
  factory $AudiobookCopyWith(Audiobook value, $Res Function(Audiobook) _then) = _$AudiobookCopyWithImpl;
@useResult
$Res call({
 String id, String title, String author, DateTime dateAdded, AudioFileType fileType, String? narrator, String? coverPath, String? sourcePath, String? shelfKey, Duration duration, Duration currentPosition, DateTime? lastPlayedAt, bool isFinished, List<AudiobookChapter> chapters
});




}
/// @nodoc
class _$AudiobookCopyWithImpl<$Res>
    implements $AudiobookCopyWith<$Res> {
  _$AudiobookCopyWithImpl(this._self, this._then);

  final Audiobook _self;
  final $Res Function(Audiobook) _then;

/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? author = null,Object? dateAdded = null,Object? fileType = null,Object? narrator = freezed,Object? coverPath = freezed,Object? sourcePath = freezed,Object? shelfKey = freezed,Object? duration = null,Object? currentPosition = null,Object? lastPlayedAt = freezed,Object? isFinished = null,Object? chapters = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,dateAdded: null == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as DateTime,fileType: null == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as AudioFileType,narrator: freezed == narrator ? _self.narrator : narrator // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,sourcePath: freezed == sourcePath ? _self.sourcePath : sourcePath // ignore: cast_nullable_to_non_nullable
as String?,shelfKey: freezed == shelfKey ? _self.shelfKey : shelfKey // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as Duration,lastPlayedAt: freezed == lastPlayedAt ? _self.lastPlayedAt : lastPlayedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<AudiobookChapter>,
  ));
}

}


/// Adds pattern-matching-related methods to [Audiobook].
extension AudiobookPatterns on Audiobook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Audiobook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Audiobook value)  $default,){
final _that = this;
switch (_that) {
case _Audiobook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Audiobook value)?  $default,){
final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String author,  DateTime dateAdded,  AudioFileType fileType,  String? narrator,  String? coverPath,  String? sourcePath,  String? shelfKey,  Duration duration,  Duration currentPosition,  DateTime? lastPlayedAt,  bool isFinished,  List<AudiobookChapter> chapters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.dateAdded,_that.fileType,_that.narrator,_that.coverPath,_that.sourcePath,_that.shelfKey,_that.duration,_that.currentPosition,_that.lastPlayedAt,_that.isFinished,_that.chapters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String author,  DateTime dateAdded,  AudioFileType fileType,  String? narrator,  String? coverPath,  String? sourcePath,  String? shelfKey,  Duration duration,  Duration currentPosition,  DateTime? lastPlayedAt,  bool isFinished,  List<AudiobookChapter> chapters)  $default,) {final _that = this;
switch (_that) {
case _Audiobook():
return $default(_that.id,_that.title,_that.author,_that.dateAdded,_that.fileType,_that.narrator,_that.coverPath,_that.sourcePath,_that.shelfKey,_that.duration,_that.currentPosition,_that.lastPlayedAt,_that.isFinished,_that.chapters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String author,  DateTime dateAdded,  AudioFileType fileType,  String? narrator,  String? coverPath,  String? sourcePath,  String? shelfKey,  Duration duration,  Duration currentPosition,  DateTime? lastPlayedAt,  bool isFinished,  List<AudiobookChapter> chapters)?  $default,) {final _that = this;
switch (_that) {
case _Audiobook() when $default != null:
return $default(_that.id,_that.title,_that.author,_that.dateAdded,_that.fileType,_that.narrator,_that.coverPath,_that.sourcePath,_that.shelfKey,_that.duration,_that.currentPosition,_that.lastPlayedAt,_that.isFinished,_that.chapters);case _:
  return null;

}
}

}

/// @nodoc


class _Audiobook implements Audiobook {
  const _Audiobook({required this.id, required this.title, required this.author, required this.dateAdded, required this.fileType, this.narrator, this.coverPath, this.sourcePath, this.shelfKey, this.duration = Duration.zero, this.currentPosition = Duration.zero, this.lastPlayedAt, this.isFinished = false, final  List<AudiobookChapter> chapters = const <AudiobookChapter>[]}): _chapters = chapters;
  

@override final  String id;
@override final  String title;
@override final  String author;
@override final  DateTime dateAdded;
@override final  AudioFileType fileType;
@override final  String? narrator;
@override final  String? coverPath;
@override final  String? sourcePath;
/// The key this book carries in the shared library folder, when it came
/// from there or was published to it. It is what lets the shelf tell that
/// this device already has the book and leave it off the list.
@override final  String? shelfKey;
@override@JsonKey() final  Duration duration;
@override@JsonKey() final  Duration currentPosition;
@override final  DateTime? lastPlayedAt;
@override@JsonKey() final  bool isFinished;
 final  List<AudiobookChapter> _chapters;
@override@JsonKey() List<AudiobookChapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudiobookCopyWith<_Audiobook> get copyWith => __$AudiobookCopyWithImpl<_Audiobook>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Audiobook&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.narrator, narrator) || other.narrator == narrator)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.sourcePath, sourcePath) || other.sourcePath == sourcePath)&&(identical(other.shelfKey, shelfKey) || other.shelfKey == shelfKey)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.lastPlayedAt, lastPlayedAt) || other.lastPlayedAt == lastPlayedAt)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&const DeepCollectionEquality().equals(other._chapters, _chapters));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,author,dateAdded,fileType,narrator,coverPath,sourcePath,shelfKey,duration,currentPosition,lastPlayedAt,isFinished,const DeepCollectionEquality().hash(_chapters));

@override
String toString() {
  return 'Audiobook(id: $id, title: $title, author: $author, dateAdded: $dateAdded, fileType: $fileType, narrator: $narrator, coverPath: $coverPath, sourcePath: $sourcePath, shelfKey: $shelfKey, duration: $duration, currentPosition: $currentPosition, lastPlayedAt: $lastPlayedAt, isFinished: $isFinished, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class _$AudiobookCopyWith<$Res> implements $AudiobookCopyWith<$Res> {
  factory _$AudiobookCopyWith(_Audiobook value, $Res Function(_Audiobook) _then) = __$AudiobookCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String author, DateTime dateAdded, AudioFileType fileType, String? narrator, String? coverPath, String? sourcePath, String? shelfKey, Duration duration, Duration currentPosition, DateTime? lastPlayedAt, bool isFinished, List<AudiobookChapter> chapters
});




}
/// @nodoc
class __$AudiobookCopyWithImpl<$Res>
    implements _$AudiobookCopyWith<$Res> {
  __$AudiobookCopyWithImpl(this._self, this._then);

  final _Audiobook _self;
  final $Res Function(_Audiobook) _then;

/// Create a copy of Audiobook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? author = null,Object? dateAdded = null,Object? fileType = null,Object? narrator = freezed,Object? coverPath = freezed,Object? sourcePath = freezed,Object? shelfKey = freezed,Object? duration = null,Object? currentPosition = null,Object? lastPlayedAt = freezed,Object? isFinished = null,Object? chapters = null,}) {
  return _then(_Audiobook(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,dateAdded: null == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as DateTime,fileType: null == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as AudioFileType,narrator: freezed == narrator ? _self.narrator : narrator // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,sourcePath: freezed == sourcePath ? _self.sourcePath : sourcePath // ignore: cast_nullable_to_non_nullable
as String?,shelfKey: freezed == shelfKey ? _self.shelfKey : shelfKey // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as Duration,lastPlayedAt: freezed == lastPlayedAt ? _self.lastPlayedAt : lastPlayedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<AudiobookChapter>,
  ));
}


}

// dart format on
