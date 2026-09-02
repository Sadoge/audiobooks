import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';

/// Drops markers that fall outside the media and orders what remains, so a
/// malformed tag can never produce an unseekable chapter.
///
/// Running this over its own output changes nothing, so it can be applied
/// where the markers are read and again once the true duration is known. That
/// second pass is what an MP3 needs: its tag carries chapters but no duration
/// worth trusting, so the file has to be probed before anything can be clamped
/// against it.
///
/// Pass [Duration.zero] when the duration is not known yet. Markers are then
/// ordered and deduplicated but nothing is clamped.
List<EmbeddedChapter> sanitiseChapters(
  List<EmbeddedChapter> chapters,
  Duration duration,
) {
  final kept =
      chapters
          .where((chapter) => !chapter.start.isNegative)
          .where(
            (chapter) => duration <= Duration.zero || chapter.start < duration,
          )
          .toList()
        ..sort((a, b) => a.start.compareTo(b.start));

  final unique = <EmbeddedChapter>[];
  for (final chapter in kept) {
    if (unique.isNotEmpty && unique.last.start == chapter.start) continue;
    unique.add(chapter);
  }
  // A lone marker describes the whole file and is not worth a chapter list.
  return unique.length < 2 ? const [] : unique;
}
