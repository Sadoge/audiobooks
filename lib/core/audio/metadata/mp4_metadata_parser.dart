import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/byte_source.dart';
import 'package:audiobooks/core/audio/metadata/chapter_markers.dart';
import 'package:audiobooks/core/audio/metadata/cover_art.dart';

/// Reads duration, tags, and chapter markers straight out of an MP4 container
/// (`.m4a`, `.m4b`, and `.aac` files that are really MP4).
///
/// Two chapter layouts appear in the wild and both are supported:
///
/// * Nero style `moov/udta/chpl`, written by most command line taggers.
/// * QuickTime style: a companion text track referenced through `tref/chap`,
///   written by Apple tools. Its titles sit in `mdat` beside the audio.
///
/// Parsing walks the box tree and reads only the ranges it needs, so a six
/// hundred megabyte audiobook costs a handful of short reads.
class Mp4MetadataParser {
  const Mp4MetadataParser();

  /// Returns `null` when [source] is not an MP4 container.
  Future<AudioFileMetadata?> parse(ByteSource source) async {
    final moovChildren = await _moovChildren(source);
    if (moovChildren == null) return null;

    final duration = await _readDuration(source, moovChildren);
    final tags = await _readTags(source, moovChildren);

    var chapters = await _readNeroChapters(source, moovChildren);
    if (chapters.isEmpty) {
      chapters = await _readQuickTimeChapters(source, moovChildren);
    }

    return AudioFileMetadata(
      duration: duration,
      title: tags[_Tag.title],
      author: tags[_Tag.author],
      narrator: tags[_Tag.narrator],
      chapters: sanitiseChapters(chapters, duration),
    );
  }

  /// Returns the artwork an MP4 carries in its `covr` tag, or `null` when the
  /// container holds none that can be drawn.
  Future<CoverArt?> parseCoverArt(ByteSource source) async {
    final moovChildren = await _moovChildren(source);
    if (moovChildren == null) return null;

    final covr = (await _tagEntries(
      source,
      moovChildren,
    )).where((entry) => entry.type == 'covr').firstOrNull;
    if (covr == null) return null;

    // A tag may hold several images; the first readable one is the cover.
    for (final data in (await _boxes(source, covr.payloadStart, covr.end))
        .where((box) => box.type == 'data')) {
      // A full box header plus the four byte locale field precede the image.
      final start = data.payloadStart + 8;
      final size = data.end - start;
      if (size <= 0 || size > CoverArt.maxBytes) continue;
      final art = CoverArt.from(await source.read(start, size));
      if (art != null) return art;
    }
    return null;
  }

  /// The children of `moov`, or `null` when [source] is not an MP4 container.
  Future<List<_Box>?> _moovChildren(ByteSource source) async {
    final length = await source.length();
    final topLevel = await _boxes(source, 0, length);
    if (!topLevel.any((box) => box.type == 'ftyp' || box.type == 'moov')) {
      return null;
    }

    final moov = topLevel.where((box) => box.type == 'moov').firstOrNull;
    if (moov == null) return null;
    return _boxes(source, moov.payloadStart, moov.end);
  }

  Future<Duration> _readDuration(ByteSource source, List<_Box> moov) async {
    final mvhd = moov.where((box) => box.type == 'mvhd').firstOrNull;
    if (mvhd == null) return Duration.zero;
    final bytes = await source.read(mvhd.payloadStart, 32);
    if (bytes.length < 20) return Duration.zero;

    final reader = _Reader(bytes);
    final version = reader.u8();
    reader.skip(3);
    final int timescale;
    final int units;
    if (version == 1) {
      if (bytes.length < 32) return Duration.zero;
      reader.skip(16);
      timescale = reader.u32();
      units = reader.u64();
    } else {
      reader.skip(8);
      timescale = reader.u32();
      units = reader.u32();
    }
    return _scaled(units, timescale);
  }

  /// The entries of `moov/udta/meta/ilst`, where iTunes style tags live.
  Future<List<_Box>> _tagEntries(ByteSource source, List<_Box> moov) async {
    final udta = moov.where((box) => box.type == 'udta').firstOrNull;
    if (udta == null) return const [];
    final udtaChildren = await _boxes(source, udta.payloadStart, udta.end);
    final meta = udtaChildren.where((box) => box.type == 'meta').firstOrNull;
    if (meta == null) return const [];

    // `meta` is a full box: its children start after version and flags.
    final metaChildren = await _boxes(source, meta.payloadStart + 4, meta.end);
    final ilst = metaChildren.where((box) => box.type == 'ilst').firstOrNull;
    if (ilst == null) return const [];

    return _boxes(source, ilst.payloadStart, ilst.end);
  }

  Future<Map<_Tag, String>> _readTags(
    ByteSource source,
    List<_Box> moov,
  ) async {
    final entries = await _tagEntries(source, moov);
    final tags = <_Tag, String>{};
    for (final entry in entries) {
      final tag = _tagFor(entry.type);
      if (tag == null || tags.containsKey(tag)) continue;
      final value = await _readTagValue(source, entry);
      if (value != null && value.isNotEmpty) tags[tag] = value;
    }
    return tags;
  }

  Future<String?> _readTagValue(ByteSource source, _Box entry) async {
    final children = await _boxes(source, entry.payloadStart, entry.end);
    final data = children.where((box) => box.type == 'data').firstOrNull;
    if (data == null) return null;
    // A full box header plus the four byte locale field precede the value.
    final start = data.payloadStart + 8;
    final size = data.end - start;
    if (size <= 0 || size > 1024) return null;
    return _decodeText(await source.read(start, size));
  }

  /// Audiobook taggers reuse the composer field for the narrator.
  _Tag? _tagFor(String type) => switch (type) {
    '©nam' => _Tag.title,
    '©ART' => _Tag.author,
    'aART' => _Tag.author,
    '©wrt' => _Tag.narrator,
    _ => null,
  };

  Future<List<EmbeddedChapter>> _readNeroChapters(
    ByteSource source,
    List<_Box> moov,
  ) async {
    final udta = moov.where((box) => box.type == 'udta').firstOrNull;
    if (udta == null) return const [];
    final children = await _boxes(source, udta.payloadStart, udta.end);
    final chpl = children.where((box) => box.type == 'chpl').firstOrNull;
    if (chpl == null) return const [];

    final size = chpl.end - chpl.payloadStart;
    if (size <= 0 || size > _maxTableBytes) return const [];
    final reader = _Reader(await source.read(chpl.payloadStart, size));
    if (reader.remaining < 5) return const [];

    final version = reader.u8();
    reader.skip(3);
    // Version one carries an extra reserved word before the chapter count.
    if (version != 0) {
      if (reader.remaining < 5) return const [];
      reader.skip(4);
    }
    final count = reader.u8();

    final chapters = <EmbeddedChapter>[];
    for (var index = 0; index < count; index++) {
      if (reader.remaining < 9) break;
      // Nero timestamps count hundred nanosecond ticks.
      final start = Duration(microseconds: reader.u64() ~/ 10);
      final titleLength = reader.u8();
      if (reader.remaining < titleLength) break;
      final title = _decodeText(reader.bytes(titleLength));
      chapters.add(
        EmbeddedChapter(
          title: title.isEmpty ? 'Chapter ${index + 1}' : title,
          start: start,
        ),
      );
    }
    return chapters;
  }

  Future<List<EmbeddedChapter>> _readQuickTimeChapters(
    ByteSource source,
    List<_Box> moov,
  ) async {
    final tracks = <_Track>[];
    final referenced = <int>{};
    for (final trak in moov.where((box) => box.type == 'trak')) {
      final track = await _readTrack(source, trak);
      if (track == null) continue;
      tracks.add(track);
      referenced.addAll(track.chapterTrackIds);
    }

    final chapterTrack =
        tracks.where((track) => referenced.contains(track.id)).firstOrNull ??
        tracks.where((track) => track.handler == 'text').firstOrNull;
    if (chapterTrack == null || chapterTrack.handler != 'text') return const [];

    return _readTextSamples(source, chapterTrack);
  }

  Future<_Track?> _readTrack(ByteSource source, _Box trak) async {
    final children = await _boxes(source, trak.payloadStart, trak.end);

    var id = 0;
    final tkhd = children.where((box) => box.type == 'tkhd').firstOrNull;
    if (tkhd != null) {
      final bytes = await source.read(tkhd.payloadStart, 24);
      if (bytes.length >= 24) {
        final reader = _Reader(bytes);
        final version = reader.u8();
        reader.skip(3);
        reader.skip(version == 1 ? 16 : 8);
        id = reader.u32();
      }
    }

    final chapterTrackIds = <int>[];
    final tref = children.where((box) => box.type == 'tref').firstOrNull;
    if (tref != null) {
      final refs = await _boxes(source, tref.payloadStart, tref.end);
      final chap = refs.where((box) => box.type == 'chap').firstOrNull;
      if (chap != null) {
        final size = chap.end - chap.payloadStart;
        if (size > 0 && size <= 1024) {
          final reader = _Reader(await source.read(chap.payloadStart, size));
          while (reader.remaining >= 4) {
            chapterTrackIds.add(reader.u32());
          }
        }
      }
    }

    final mdia = children.where((box) => box.type == 'mdia').firstOrNull;
    if (mdia == null) return null;
    final mdiaChildren = await _boxes(source, mdia.payloadStart, mdia.end);

    var timescale = 0;
    final mdhd = mdiaChildren.where((box) => box.type == 'mdhd').firstOrNull;
    if (mdhd != null) {
      final bytes = await source.read(mdhd.payloadStart, 24);
      if (bytes.length >= 24) {
        final reader = _Reader(bytes);
        final version = reader.u8();
        reader.skip(3);
        reader.skip(version == 1 ? 16 : 8);
        timescale = reader.u32();
      }
    }

    var handler = '';
    final hdlr = mdiaChildren.where((box) => box.type == 'hdlr').firstOrNull;
    if (hdlr != null) {
      final bytes = await source.read(hdlr.payloadStart, 12);
      if (bytes.length >= 12) handler = _ascii(bytes, 8);
    }

    final minf = mdiaChildren.where((box) => box.type == 'minf').firstOrNull;
    if (minf == null) return null;
    final minfChildren = await _boxes(source, minf.payloadStart, minf.end);
    final stbl = minfChildren.where((box) => box.type == 'stbl').firstOrNull;
    if (stbl == null) return null;

    return _Track(
      id: id,
      handler: handler,
      timescale: timescale,
      chapterTrackIds: chapterTrackIds,
      sampleTable: await _boxes(source, stbl.payloadStart, stbl.end),
    );
  }

  Future<List<EmbeddedChapter>> _readTextSamples(
    ByteSource source,
    _Track track,
  ) async {
    if (track.timescale <= 0) return const [];
    final times = await _sampleTimes(source, track);
    final sizes = await _sampleSizes(source, track);
    final offsets = await _sampleOffsets(source, track, sizes);
    if (times.isEmpty || offsets.isEmpty) return const [];

    final count = math.min(times.length, offsets.length);
    final chapters = <EmbeddedChapter>[];
    for (var index = 0; index < count; index++) {
      final size = sizes[index];
      if (size < 2 || size > _maxSampleBytes) continue;
      final sample = await source.read(offsets[index], size);
      if (sample.length < 2) continue;
      // A QuickTime text sample is a big endian length then its text bytes.
      final textLength = math.min(
        (sample[0] << 8) | sample[1],
        sample.length - 2,
      );
      final title = _decodeText(
        Uint8List.sublistView(sample, 2, 2 + textLength),
      );
      chapters.add(
        EmbeddedChapter(
          title: title.isEmpty ? 'Chapter ${index + 1}' : title,
          start: _scaled(times[index], track.timescale),
        ),
      );
    }
    return chapters;
  }

  Future<List<int>> _sampleTimes(ByteSource source, _Track track) async {
    final reader = await _fullBoxReader(source, track.box('stts'));
    if (reader == null || reader.remaining < 4) return const [];

    final entryCount = reader.u32();
    final times = <int>[];
    var elapsed = 0;
    for (var entry = 0; entry < entryCount; entry++) {
      if (reader.remaining < 8) break;
      final sampleCount = reader.u32();
      final delta = reader.u32();
      for (var index = 0; index < sampleCount; index++) {
        times.add(elapsed);
        elapsed += delta;
        if (times.length >= _maxSamples) return times;
      }
    }
    return times;
  }

  Future<List<int>> _sampleSizes(ByteSource source, _Track track) async {
    final reader = await _fullBoxReader(source, track.box('stsz'));
    if (reader == null || reader.remaining < 8) return const [];

    final uniformSize = reader.u32();
    final sampleCount = math.min(reader.u32(), _maxSamples);
    if (uniformSize != 0) return List<int>.filled(sampleCount, uniformSize);

    final sizes = <int>[];
    for (var index = 0; index < sampleCount && reader.remaining >= 4; index++) {
      sizes.add(reader.u32());
    }
    return sizes;
  }

  /// Walks the chunk table to turn per chunk offsets into per sample offsets.
  Future<List<int>> _sampleOffsets(
    ByteSource source,
    _Track track,
    List<int> sizes,
  ) async {
    if (sizes.isEmpty) return const [];
    final chunkOffsets = await _chunkOffsets(source, track);
    if (chunkOffsets.isEmpty) return const [];

    final reader = await _fullBoxReader(source, track.box('stsc'));
    if (reader == null || reader.remaining < 4) return const [];

    final entryCount = reader.u32();
    final runs = <({int firstChunk, int samplesPerChunk})>[];
    for (var entry = 0; entry < entryCount; entry++) {
      if (reader.remaining < 12) break;
      final firstChunk = reader.u32();
      final samplesPerChunk = reader.u32();
      reader.skip(4);
      runs.add((firstChunk: firstChunk, samplesPerChunk: samplesPerChunk));
    }
    if (runs.isEmpty) return const [];

    final offsets = <int>[];
    var sampleIndex = 0;
    for (var chunk = 1; chunk <= chunkOffsets.length; chunk++) {
      final run = runs.lastWhere(
        (candidate) => candidate.firstChunk <= chunk,
        orElse: () => runs.first,
      );
      var offset = chunkOffsets[chunk - 1];
      for (var index = 0; index < run.samplesPerChunk; index++) {
        if (sampleIndex >= sizes.length) return offsets;
        offsets.add(offset);
        offset += sizes[sampleIndex];
        sampleIndex++;
      }
    }
    return offsets;
  }

  Future<List<int>> _chunkOffsets(ByteSource source, _Track track) async {
    final box = track.box('stco') ?? track.box('co64');
    final reader = await _fullBoxReader(source, box);
    if (reader == null || reader.remaining < 4) return const [];

    final wide = box!.type == 'co64';
    final entryCount = math.min(reader.u32(), _maxSamples);
    final offsets = <int>[];
    for (var index = 0; index < entryCount; index++) {
      if (reader.remaining < (wide ? 8 : 4)) break;
      offsets.add(wide ? reader.u64() : reader.u32());
    }
    return offsets;
  }

  Future<_Reader?> _fullBoxReader(ByteSource source, _Box? box) async {
    if (box == null) return null;
    final size = box.end - box.payloadStart;
    if (size <= 4 || size > _maxTableBytes) return null;
    final reader = _Reader(await source.read(box.payloadStart, size));
    reader.skip(4); // version and flags
    return reader;
  }

  Future<List<_Box>> _boxes(ByteSource source, int start, int end) async {
    final boxes = <_Box>[];
    var cursor = start;
    while (cursor + 8 <= end && boxes.length < _maxBoxesPerLevel) {
      final header = await source.read(cursor, 16);
      if (header.length < 8) break;

      final reader = _Reader(header);
      var size = reader.u32();
      final type = _ascii(header, 4);
      var payloadStart = cursor + 8;

      if (size == 1) {
        if (header.length < 16) break;
        reader.skip(4);
        size = reader.u64();
        payloadStart = cursor + 16;
      } else if (size == 0) {
        size = end - cursor;
      }

      final boxEnd = cursor + size;
      if (size < 8 || boxEnd > end || payloadStart > boxEnd) break;
      boxes.add(_Box(type: type, payloadStart: payloadStart, end: boxEnd));
      cursor = boxEnd;
    }
    return boxes;
  }
}

enum _Tag { title, author, narrator }

const _maxBoxesPerLevel = 4096;
const _maxSamples = 20000;
const _maxSampleBytes = 4096;
const _maxTableBytes = 4 << 20;

Duration _scaled(int units, int timescale) => timescale <= 0
    ? Duration.zero
    : Duration(microseconds: (units * 1000000 / timescale).round());

String _ascii(Uint8List bytes, int offset) =>
    String.fromCharCodes(bytes, offset, offset + 4);

String _decodeText(Uint8List bytes) {
  if (bytes.isEmpty) return '';
  // Apple tools may write UTF-16 text samples behind a byte order mark.
  if (bytes.length >= 2 && bytes[0] == 0xFE && bytes[1] == 0xFF) {
    final units = <int>[];
    for (var index = 2; index + 1 < bytes.length; index += 2) {
      units.add((bytes[index] << 8) | bytes[index + 1]);
    }
    return String.fromCharCodes(units).replaceAll('\u0000', '').trim();
  }
  return utf8
      .decode(bytes, allowMalformed: true)
      .replaceAll('\u0000', '')
      .trim();
}

class _Box {
  const _Box({
    required this.type,
    required this.payloadStart,
    required this.end,
  });

  final String type;
  final int payloadStart;
  final int end;
}

class _Track {
  const _Track({
    required this.id,
    required this.handler,
    required this.timescale,
    required this.chapterTrackIds,
    required this.sampleTable,
  });

  final int id;
  final String handler;
  final int timescale;
  final List<int> chapterTrackIds;
  final List<_Box> sampleTable;

  _Box? box(String type) =>
      sampleTable.where((box) => box.type == type).firstOrNull;
}

class _Reader {
  _Reader(this._bytes);

  final Uint8List _bytes;
  int _cursor = 0;

  int get remaining => _bytes.length - _cursor;

  void skip(int count) => _cursor += count;

  int u8() => _bytes[_cursor++];

  int u32() {
    final value =
        (_bytes[_cursor] << 24) |
        (_bytes[_cursor + 1] << 16) |
        (_bytes[_cursor + 2] << 8) |
        _bytes[_cursor + 3];
    _cursor += 4;
    return value;
  }

  int u64() {
    final high = u32();
    final low = u32();
    return (high << 32) | low;
  }

  Uint8List bytes(int count) {
    final value = Uint8List.sublistView(_bytes, _cursor, _cursor + count);
    _cursor += count;
    return value;
  }
}
