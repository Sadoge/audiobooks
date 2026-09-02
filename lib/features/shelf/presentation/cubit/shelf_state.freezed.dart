// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shelf_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShelfState {

 ShelfStatus get status;/// Books in the shared folder that this device does not have. A book
/// already in the library is not here — it is in the library.
 List<ShelfBook> get books; ShelfFolder? get folder; String? get errorMessage;/// The outcome of a download, shown once and then dropped.
 String? get actionMessage;/// How far along each download in flight is, from zero to one, keyed by
/// the book it belongs to.
 Map<String, double> get downloading;
/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShelfStateCopyWith<ShelfState> get copyWith => _$ShelfStateCopyWithImpl<ShelfState>(this as ShelfState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShelfState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.books, books)&&(identical(other.folder, folder) || other.folder == folder)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.actionMessage, actionMessage) || other.actionMessage == actionMessage)&&const DeepCollectionEquality().equals(other.downloading, downloading));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(books),folder,errorMessage,actionMessage,const DeepCollectionEquality().hash(downloading));

@override
String toString() {
  return 'ShelfState(status: $status, books: $books, folder: $folder, errorMessage: $errorMessage, actionMessage: $actionMessage, downloading: $downloading)';
}


}

/// @nodoc
abstract mixin class $ShelfStateCopyWith<$Res>  {
  factory $ShelfStateCopyWith(ShelfState value, $Res Function(ShelfState) _then) = _$ShelfStateCopyWithImpl;
@useResult
$Res call({
 ShelfStatus status, List<ShelfBook> books, ShelfFolder? folder, String? errorMessage, String? actionMessage, Map<String, double> downloading
});


$ShelfFolderCopyWith<$Res>? get folder;

}
/// @nodoc
class _$ShelfStateCopyWithImpl<$Res>
    implements $ShelfStateCopyWith<$Res> {
  _$ShelfStateCopyWithImpl(this._self, this._then);

  final ShelfState _self;
  final $Res Function(ShelfState) _then;

/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? books = null,Object? folder = freezed,Object? errorMessage = freezed,Object? actionMessage = freezed,Object? downloading = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShelfStatus,books: null == books ? _self.books : books // ignore: cast_nullable_to_non_nullable
as List<ShelfBook>,folder: freezed == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as ShelfFolder?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,actionMessage: freezed == actionMessage ? _self.actionMessage : actionMessage // ignore: cast_nullable_to_non_nullable
as String?,downloading: null == downloading ? _self.downloading : downloading // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}
/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfFolderCopyWith<$Res>? get folder {
    if (_self.folder == null) {
    return null;
  }

  return $ShelfFolderCopyWith<$Res>(_self.folder!, (value) {
    return _then(_self.copyWith(folder: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShelfState].
extension ShelfStatePatterns on ShelfState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShelfState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShelfState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShelfState value)  $default,){
final _that = this;
switch (_that) {
case _ShelfState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShelfState value)?  $default,){
final _that = this;
switch (_that) {
case _ShelfState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ShelfStatus status,  List<ShelfBook> books,  ShelfFolder? folder,  String? errorMessage,  String? actionMessage,  Map<String, double> downloading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShelfState() when $default != null:
return $default(_that.status,_that.books,_that.folder,_that.errorMessage,_that.actionMessage,_that.downloading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ShelfStatus status,  List<ShelfBook> books,  ShelfFolder? folder,  String? errorMessage,  String? actionMessage,  Map<String, double> downloading)  $default,) {final _that = this;
switch (_that) {
case _ShelfState():
return $default(_that.status,_that.books,_that.folder,_that.errorMessage,_that.actionMessage,_that.downloading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ShelfStatus status,  List<ShelfBook> books,  ShelfFolder? folder,  String? errorMessage,  String? actionMessage,  Map<String, double> downloading)?  $default,) {final _that = this;
switch (_that) {
case _ShelfState() when $default != null:
return $default(_that.status,_that.books,_that.folder,_that.errorMessage,_that.actionMessage,_that.downloading);case _:
  return null;

}
}

}

/// @nodoc


class _ShelfState implements ShelfState {
  const _ShelfState({this.status = ShelfStatus.initial, final  List<ShelfBook> books = const <ShelfBook>[], this.folder, this.errorMessage, this.actionMessage, final  Map<String, double> downloading = const <String, double>{}}): _books = books,_downloading = downloading;
  

@override@JsonKey() final  ShelfStatus status;
/// Books in the shared folder that this device does not have. A book
/// already in the library is not here — it is in the library.
 final  List<ShelfBook> _books;
/// Books in the shared folder that this device does not have. A book
/// already in the library is not here — it is in the library.
@override@JsonKey() List<ShelfBook> get books {
  if (_books is EqualUnmodifiableListView) return _books;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_books);
}

@override final  ShelfFolder? folder;
@override final  String? errorMessage;
/// The outcome of a download, shown once and then dropped.
@override final  String? actionMessage;
/// How far along each download in flight is, from zero to one, keyed by
/// the book it belongs to.
 final  Map<String, double> _downloading;
/// How far along each download in flight is, from zero to one, keyed by
/// the book it belongs to.
@override@JsonKey() Map<String, double> get downloading {
  if (_downloading is EqualUnmodifiableMapView) return _downloading;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_downloading);
}


/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShelfStateCopyWith<_ShelfState> get copyWith => __$ShelfStateCopyWithImpl<_ShelfState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShelfState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._books, _books)&&(identical(other.folder, folder) || other.folder == folder)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.actionMessage, actionMessage) || other.actionMessage == actionMessage)&&const DeepCollectionEquality().equals(other._downloading, _downloading));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_books),folder,errorMessage,actionMessage,const DeepCollectionEquality().hash(_downloading));

@override
String toString() {
  return 'ShelfState(status: $status, books: $books, folder: $folder, errorMessage: $errorMessage, actionMessage: $actionMessage, downloading: $downloading)';
}


}

/// @nodoc
abstract mixin class _$ShelfStateCopyWith<$Res> implements $ShelfStateCopyWith<$Res> {
  factory _$ShelfStateCopyWith(_ShelfState value, $Res Function(_ShelfState) _then) = __$ShelfStateCopyWithImpl;
@override @useResult
$Res call({
 ShelfStatus status, List<ShelfBook> books, ShelfFolder? folder, String? errorMessage, String? actionMessage, Map<String, double> downloading
});


@override $ShelfFolderCopyWith<$Res>? get folder;

}
/// @nodoc
class __$ShelfStateCopyWithImpl<$Res>
    implements _$ShelfStateCopyWith<$Res> {
  __$ShelfStateCopyWithImpl(this._self, this._then);

  final _ShelfState _self;
  final $Res Function(_ShelfState) _then;

/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? books = null,Object? folder = freezed,Object? errorMessage = freezed,Object? actionMessage = freezed,Object? downloading = null,}) {
  return _then(_ShelfState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ShelfStatus,books: null == books ? _self._books : books // ignore: cast_nullable_to_non_nullable
as List<ShelfBook>,folder: freezed == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as ShelfFolder?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,actionMessage: freezed == actionMessage ? _self.actionMessage : actionMessage // ignore: cast_nullable_to_non_nullable
as String?,downloading: null == downloading ? _self._downloading : downloading // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShelfFolderCopyWith<$Res>? get folder {
    if (_self.folder == null) {
    return null;
  }

  return $ShelfFolderCopyWith<$Res>(_self.folder!, (value) {
    return _then(_self.copyWith(folder: value));
  });
}
}

// dart format on
