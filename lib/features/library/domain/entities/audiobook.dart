import 'package:audiobooks/features/library/domain/entities/audiobook_chapter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audiobook.freezed.dart';

enum AudioFileType { mp3, m4a, m4b, aac }

@freezed
abstract class Audiobook with _$Audiobook {
  const factory Audiobook({
    required String id,
    required String title,
    required String author,
    required DateTime dateAdded,
    required AudioFileType fileType,
    String? narrator,
    String? coverPath,
    String? sourcePath,
    @Default(Duration.zero) Duration duration,
    @Default(Duration.zero) Duration currentPosition,
    DateTime? lastPlayedAt,
    @Default(false) bool isFinished,
    @Default(<AudiobookChapter>[]) List<AudiobookChapter> chapters,
  }) = _Audiobook;
}
