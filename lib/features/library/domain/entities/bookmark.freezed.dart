// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Bookmark {

 String get id; String get bookId; String get chapterId; Duration get position; String get title; DateTime get createdAt;
/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkCopyWith<Bookmark> get copyWith => _$BookmarkCopyWithImpl<Bookmark>(this as Bookmark, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Bookmark&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.position, position) || other.position == position)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,bookId,chapterId,position,title,createdAt);

@override
String toString() {
  return 'Bookmark(id: $id, bookId: $bookId, chapterId: $chapterId, position: $position, title: $title, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BookmarkCopyWith<$Res>  {
  factory $BookmarkCopyWith(Bookmark value, $Res Function(Bookmark) _then) = _$BookmarkCopyWithImpl;
@useResult
$Res call({
 String id, String bookId, String chapterId, Duration position, String title, DateTime createdAt
});




}
/// @nodoc
class _$BookmarkCopyWithImpl<$Res>
    implements $BookmarkCopyWith<$Res> {
  _$BookmarkCopyWithImpl(this._self, this._then);

  final Bookmark _self;
  final $Res Function(Bookmark) _then;

/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? chapterId = null,Object? position = null,Object? title = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Bookmark].
extension BookmarkPatterns on Bookmark {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Bookmark value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Bookmark value)  $default,){
final _that = this;
switch (_that) {
case _Bookmark():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Bookmark value)?  $default,){
final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String bookId,  String chapterId,  Duration position,  String title,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
return $default(_that.id,_that.bookId,_that.chapterId,_that.position,_that.title,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String bookId,  String chapterId,  Duration position,  String title,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Bookmark():
return $default(_that.id,_that.bookId,_that.chapterId,_that.position,_that.title,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String bookId,  String chapterId,  Duration position,  String title,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Bookmark() when $default != null:
return $default(_that.id,_that.bookId,_that.chapterId,_that.position,_that.title,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Bookmark implements Bookmark {
  const _Bookmark({required this.id, required this.bookId, required this.chapterId, required this.position, required this.title, required this.createdAt});
  

@override final  String id;
@override final  String bookId;
@override final  String chapterId;
@override final  Duration position;
@override final  String title;
@override final  DateTime createdAt;

/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarkCopyWith<_Bookmark> get copyWith => __$BookmarkCopyWithImpl<_Bookmark>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Bookmark&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.position, position) || other.position == position)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,bookId,chapterId,position,title,createdAt);

@override
String toString() {
  return 'Bookmark(id: $id, bookId: $bookId, chapterId: $chapterId, position: $position, title: $title, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BookmarkCopyWith<$Res> implements $BookmarkCopyWith<$Res> {
  factory _$BookmarkCopyWith(_Bookmark value, $Res Function(_Bookmark) _then) = __$BookmarkCopyWithImpl;
@override @useResult
$Res call({
 String id, String bookId, String chapterId, Duration position, String title, DateTime createdAt
});




}
/// @nodoc
class __$BookmarkCopyWithImpl<$Res>
    implements _$BookmarkCopyWith<$Res> {
  __$BookmarkCopyWithImpl(this._self, this._then);

  final _Bookmark _self;
  final $Res Function(_Bookmark) _then;

/// Create a copy of Bookmark
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? chapterId = null,Object? position = null,Object? title = null,Object? createdAt = null,}) {
  return _then(_Bookmark(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
