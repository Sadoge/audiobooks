import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shelf_book.freezed.dart';

/// A book sitting in the shared folder that this device does not have.
///
/// Everything here is read from the book's manifest rather than from its
/// audio, so listing a shelf never pulls a file down from wherever the
/// listener's sync service is keeping it.
@freezed
abstract class ShelfBook with _$ShelfBook {
  const factory ShelfBook({
    required String key,
    required String title,
    required String author,
    required AudioFileType fileType,
    required int totalBytes,
    String? narrator,

    /// Where the cover sits in the shared folder, when the book has one.
    String? coverPath,
    @Default(Duration.zero) Duration duration,
    @Default(0) int chapterCount,
  }) = _ShelfBook;
}
