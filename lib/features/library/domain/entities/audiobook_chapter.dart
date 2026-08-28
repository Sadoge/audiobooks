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

    /// Where the chapter starts inside [filePath].
    ///
    /// Zero when the book stores one file per chapter. For a single file book
    /// with embedded markers this is the marker itself, which is also where
    /// the chapter starts on the book timeline.
    @Default(Duration.zero) Duration startPosition,
  }) = _AudiobookChapter;
}
