import 'package:freezed_annotation/freezed_annotation.dart';

part 'audiobook_chapter.freezed.dart';

@freezed
abstract class AudiobookChapter with _$AudiobookChapter {
  const factory AudiobookChapter({
    required String id,
    required String bookId,
    required String title,
    required int index,
    required String filePath,
    @Default(Duration.zero) Duration duration,
    @Default(Duration.zero) Duration startPosition,
  }) = _AudiobookChapter;
}
