import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';

@freezed
abstract class Bookmark with _$Bookmark {
  const factory Bookmark({
    required String id,
    required String bookId,
    required String chapterId,
    required Duration position,
    required String title,
    required DateTime createdAt,
  }) = _Bookmark;
}
