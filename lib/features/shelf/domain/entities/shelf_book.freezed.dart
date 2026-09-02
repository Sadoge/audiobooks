// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shelf_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShelfBook {

 String get key; String get title; String get author; AudioFileType get fileType; int get totalBytes; String? get narrator;/// Where the cover sits in the shared folder, when the book has one.
 String? get coverPath; Duration get duration; int get chapterCount;
/// Create a copy of ShelfBook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShelfBookCopyWith<ShelfBook> get copyWith => _$ShelfBookCopyWithImpl<ShelfBook>(this as ShelfBook, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShelfBook&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.narrator, narrator) || other.narrator == narrator)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.chapterCount, chapterCount) || other.chapterCount == chapterCount));
}


@override
int get hashCode => Object.hash(runtimeType,key,title,author,fileType,totalBytes,narrator,coverPath,duration,chapterCount);

@override
String toString() {
  return 'ShelfBook(key: $key, title: $title, author: $author, fileType: $fileType, totalBytes: $totalBytes, narrator: $narrator, coverPath: $coverPath, duration: $duration, chapterCount: $chapterCount)';
}


}

/// @nodoc
abstract mixin class $ShelfBookCopyWith<$Res>  {
  factory $ShelfBookCopyWith(ShelfBook value, $Res Function(ShelfBook) _then) = _$ShelfBookCopyWithImpl;
@useResult
$Res call({
 String key, String title, String author, AudioFileType fileType, int totalBytes, String? narrator, String? coverPath, Duration duration, int chapterCount
});




}
/// @nodoc
class _$ShelfBookCopyWithImpl<$Res>
    implements $ShelfBookCopyWith<$Res> {
  _$ShelfBookCopyWithImpl(this._self, this._then);

  final ShelfBook _self;
  final $Res Function(ShelfBook) _then;

/// Create a copy of ShelfBook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? title = null,Object? author = null,Object? fileType = null,Object? totalBytes = null,Object? narrator = freezed,Object? coverPath = freezed,Object? duration = null,Object? chapterCount = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,fileType: null == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as AudioFileType,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,narrator: freezed == narrator ? _self.narrator : narrator // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,chapterCount: null == chapterCount ? _self.chapterCount : chapterCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ShelfBook].
extension ShelfBookPatterns on ShelfBook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShelfBook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShelfBook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShelfBook value)  $default,){
final _that = this;
switch (_that) {
case _ShelfBook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShelfBook value)?  $default,){
final _that = this;
switch (_that) {
case _ShelfBook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String title,  String author,  AudioFileType fileType,  int totalBytes,  String? narrator,  String? coverPath,  Duration duration,  int chapterCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShelfBook() when $default != null:
return $default(_that.key,_that.title,_that.author,_that.fileType,_that.totalBytes,_that.narrator,_that.coverPath,_that.duration,_that.chapterCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String title,  String author,  AudioFileType fileType,  int totalBytes,  String? narrator,  String? coverPath,  Duration duration,  int chapterCount)  $default,) {final _that = this;
switch (_that) {
case _ShelfBook():
return $default(_that.key,_that.title,_that.author,_that.fileType,_that.totalBytes,_that.narrator,_that.coverPath,_that.duration,_that.chapterCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String title,  String author,  AudioFileType fileType,  int totalBytes,  String? narrator,  String? coverPath,  Duration duration,  int chapterCount)?  $default,) {final _that = this;
switch (_that) {
case _ShelfBook() when $default != null:
return $default(_that.key,_that.title,_that.author,_that.fileType,_that.totalBytes,_that.narrator,_that.coverPath,_that.duration,_that.chapterCount);case _:
  return null;

}
}

}

/// @nodoc


class _ShelfBook implements ShelfBook {
  const _ShelfBook({required this.key, required this.title, required this.author, required this.fileType, required this.totalBytes, this.narrator, this.coverPath, this.duration = Duration.zero, this.chapterCount = 0});
  

@override final  String key;
@override final  String title;
@override final  String author;
@override final  AudioFileType fileType;
@override final  int totalBytes;
@override final  String? narrator;
/// Where the cover sits in the shared folder, when the book has one.
@override final  String? coverPath;
@override@JsonKey() final  Duration duration;
@override@JsonKey() final  int chapterCount;

/// Create a copy of ShelfBook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShelfBookCopyWith<_ShelfBook> get copyWith => __$ShelfBookCopyWithImpl<_ShelfBook>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShelfBook&&(identical(other.key, key) || other.key == key)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.narrator, narrator) || other.narrator == narrator)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.chapterCount, chapterCount) || other.chapterCount == chapterCount));
}


@override
int get hashCode => Object.hash(runtimeType,key,title,author,fileType,totalBytes,narrator,coverPath,duration,chapterCount);

@override
String toString() {
  return 'ShelfBook(key: $key, title: $title, author: $author, fileType: $fileType, totalBytes: $totalBytes, narrator: $narrator, coverPath: $coverPath, duration: $duration, chapterCount: $chapterCount)';
}


}

/// @nodoc
abstract mixin class _$ShelfBookCopyWith<$Res> implements $ShelfBookCopyWith<$Res> {
  factory _$ShelfBookCopyWith(_ShelfBook value, $Res Function(_ShelfBook) _then) = __$ShelfBookCopyWithImpl;
@override @useResult
$Res call({
 String key, String title, String author, AudioFileType fileType, int totalBytes, String? narrator, String? coverPath, Duration duration, int chapterCount
});




}
/// @nodoc
class __$ShelfBookCopyWithImpl<$Res>
    implements _$ShelfBookCopyWith<$Res> {
  __$ShelfBookCopyWithImpl(this._self, this._then);

  final _ShelfBook _self;
  final $Res Function(_ShelfBook) _then;

/// Create a copy of ShelfBook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? title = null,Object? author = null,Object? fileType = null,Object? totalBytes = null,Object? narrator = freezed,Object? coverPath = freezed,Object? duration = null,Object? chapterCount = null,}) {
  return _then(_ShelfBook(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,fileType: null == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as AudioFileType,totalBytes: null == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int,narrator: freezed == narrator ? _self.narrator : narrator // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,chapterCount: null == chapterCount ? _self.chapterCount : chapterCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
