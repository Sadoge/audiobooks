import 'dart:typed_data';

import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/byte_source.dart';
import 'package:audiobooks/core/audio/metadata/chapter_markers.dart';
import 'package:audiobooks/core/audio/metadata/id3_frames.dart';

/// Reads tags and chapter markers out of the ID3v2 tag at the head of an MP3.
///
/// Two chapter layouts appear in the wild and both are supported:
///
/// * `CHAP` frames, one per chapter, each carrying its own title. This is what
///   command line taggers write.
/// * OverDrive MediaMarkers, a list of names and times in XML inside a `TXXX`
///   frame, which is how a library loan arrives.
///
/// `CTOC`, the table of contents that may accompany `CHAP`, is deliberately
/// not read. Its ordering is discarded anyway because markers are sorted by
/// start time, and using it to decide which chapters count would silently drop
/// them whenever a tagger wrote the table badly. Every `CHAP` frame found is a
/// chapter.
///
/// Duration is deliberately absent: `TLEN` is optional and routinely wrong, so
/// the caller asks the audio engine instead.
class Id3MetadataParser {
  const Id3MetadataParser();

  /// Returns null when [source] carries no readable ID3v2 tag.
  Future<AudioFileMetadata?> parse(ByteSource source) async {
    final tag = await Id3Tag.read(source);
    if (tag == null) return null;

    final short = tag.major == 2;
    String? album;
    String? trackTitle;
    String? artist;
    String? albumArtist;
    String? composer;
    String? taggedNarrator;
    String? markerXml;
    final chapters = <EmbeddedChapter>[];

    await for (final frame in id3Frames(source, tag)) {
      switch (frame.id) {
        case 'TALB' when !short:
        case 'TAL' when short:
          album ??= await _text(source, frame);
        case 'TIT2' when !short:
        case 'TT2' when short:
          trackTitle ??= await _text(source, frame);
        case 'TPE1' when !short:
        case 'TP1' when short:
          artist ??= await _text(source, frame);
        case 'TPE2' when !short:
        case 'TP2' when short:
          albumArtist ??= await _text(source, frame);
        case 'TCOM' when !short:
        case 'TCM' when short:
          composer ??= await _text(source, frame);
        case 'TXXX' when !short:
        case 'TXX' when short:
          final pair = await _userText(source, frame);
          if (pair == null) break;
          final description = pair.description.toLowerCase();
          if (description == 'overdrive mediamarkers') {
            markerXml ??= pair.value;
          } else if (description == 'narrator' ||
              description == 'narrated_by' ||
              description == 'narrated by') {
            taggedNarrator ??= pair.value;
          }
        case 'CHAP':
          if (chapters.length >= _maxChapters) break;
          final chapter = await _chapter(source, frame, chapters.length);
          if (chapter != null) chapters.add(chapter);
      }
    }

    // A tagger that wrote real chapter frames is more trustworthy than one
    // that only left markers behind, so the frames answer first.
    final markers = chapters.isNotEmpty
        ? chapters
        : _overDriveMarkers(markerXml);

    return AudioFileMetadata(
      title: album,
      trackTitle: trackTitle,
      author: artist ?? albumArtist,
      // Audiobook taggers reuse the composer field for the narrator.
      narrator: composer ?? taggedNarrator,
      chapters: sanitiseChapters(markers, Duration.zero),
    );
  }

  /// A text frame is an encoding byte and then the string itself.
  Future<String?> _text(ByteSource source, Id3Frame frame) async {
    final payload = await frame.read(source, maxBytes: _maxTextBytes);
    if (payload.length < 2) return null;
    final value = decodeId3Text(
      Uint8List.sublistView(payload, 1),
      payload[0],
    );
    return value.isEmpty ? null : value;
  }

  /// A user defined text frame names itself: an encoding byte, a terminated
  /// description, and then the value under the same encoding.
  Future<_UserText?> _userText(ByteSource source, Id3Frame frame) async {
    final payload = await frame.read(source, maxBytes: _maxMarkersBytes);
    if (payload.length < 2) return null;

    final encoding = payload[0];
    final valueStart = id3TerminatorEnd(payload, 1, encoding: encoding);
    if (valueStart <= 0 || valueStart >= payload.length) return null;

    return _UserText(
      description: decodeId3Text(
        Uint8List.sublistView(payload, 1, valueStart),
        encoding,
      ),
      value: decodeId3Text(Uint8List.sublistView(payload, valueStart), encoding),
    );
  }

  /// A chapter frame is a terminated element id, a start and end in
  /// milliseconds, a start and end byte offset, and then frames of its own.
  ///
  /// Only the start is kept. The end is the next marker's start everywhere
  /// above this, and the byte offsets serve seeking by byte, which nothing
  /// here does.
  Future<EmbeddedChapter?> _chapter(
    ByteSource source,
    Id3Frame frame,
    int index,
  ) async {
    final payload = await frame.read(source, maxBytes: _maxChapterBytes);
    final idEnd = id3TerminatorEnd(payload, 0);
    if (idEnd < 0 || idEnd + 16 > payload.length) return null;

    final start = Duration(
      milliseconds:
          (payload[idEnd] << 24) |
          (payload[idEnd + 1] << 16) |
          (payload[idEnd + 2] << 8) |
          payload[idEnd + 3],
    );

    final title = await _chapterTitle(
      Uint8List.sublistView(payload, idEnd + 16),
      major: frame.major,
    );
    return EmbeddedChapter(
      title: title ?? 'Chapter ${index + 1}',
      start: start,
    );
  }

  /// The title a chapter frame carries in a title frame of its own. The sub
  /// frames are ordinary frames of the same version, so the same walk reads
  /// them; it looks only for a title, so it can never recurse further.
  Future<String?> _chapterTitle(
    Uint8List subFrames, {
    required int major,
  }) async {
    if (subFrames.isEmpty) return null;
    final wanted = major == 2 ? 'TT2' : 'TIT2';
    final source = MemoryByteSource(subFrames);
    final tag = Id3Tag.embedded(major: major, end: subFrames.length);

    await for (final frame in id3Frames(source, tag)) {
      if (frame.id != wanted) continue;
      final title = await _text(source, frame);
      if (title != null) return title;
    }
    return null;
  }

  /// OverDrive writes its markers as a flat list of names and times. The shape
  /// is fixed and one level deep, so it is scanned rather than parsed as XML.
  List<EmbeddedChapter> _overDriveMarkers(String? xml) {
    if (xml == null || xml.isEmpty) return const [];

    final markers = <EmbeddedChapter>[];
    for (final match in _marker.allMatches(xml)) {
      if (markers.length >= _maxChapters) break;
      final body = match.group(1) ?? '';
      final name = _name.firstMatch(body)?.group(1);
      final time = _overDriveTime(_time.firstMatch(body)?.group(1));
      if (time == null) continue;

      final title = _unescape(name ?? '').trim();
      markers.add(
        EmbeddedChapter(
          title: title.isEmpty ? 'Chapter ${markers.length + 1}' : title,
          start: time,
        ),
      );
    }
    return markers;
  }

  /// `H:MM:SS.mmm`, `MM:SS.mmm`, and `SS.mmm` all appear in the wild.
  Duration? _overDriveTime(String? value) {
    final fields = value?.trim().split(':');
    if (fields == null || fields.isEmpty || fields.length > 3) return null;

    final last = double.tryParse(fields.last);
    if (last == null || last.isNegative || !last.isFinite) return null;

    var seconds = last;

    for (var index = fields.length - 2; index >= 0; index--) {
      final unit = int.tryParse(fields[index].trim());
      if (unit == null || unit < 0) return null;
      seconds += unit * (index == fields.length - 2 ? 60 : 3600);
    }
    return Duration(milliseconds: (seconds * 1000).round());
  }
}

/// The five named entities plus numeric escapes, which is everything a marker
/// name can carry.
String _unescape(String value) => value
    .replaceAllMapped(
      RegExp(r'&#(\d+);'),
      (match) =>
          String.fromCharCode(int.tryParse(match.group(1) ?? '') ?? 0x20),
    )
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>')
    .replaceAll('&quot;', '"')
    .replaceAll('&apos;', "'")
    .replaceAll('&amp;', '&');

final _marker = RegExp(
  r'<Marker\b[^>]*>(.*?)</Marker>',
  dotAll: true,
  caseSensitive: false,
);
final _name = RegExp(
  r'<Name\b[^>]*>(.*?)</Name>',
  dotAll: true,
  caseSensitive: false,
);
final _time = RegExp(
  r'<Time\b[^>]*>(.*?)</Time>',
  dotAll: true,
  caseSensitive: false,
);

/// A title or an author is a line of text; anything longer is not one.
const _maxTextBytes = 1024;

/// A chapter frame holds an id and a title, nothing large.
const _maxChapterBytes = 64 << 10;

const _maxMarkersBytes = 256 << 10;
const _maxChapters = 2048;

class _UserText {
  const _UserText({required this.description, required this.value});

  final String description;
  final String value;
}
