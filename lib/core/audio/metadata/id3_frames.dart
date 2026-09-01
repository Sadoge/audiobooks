import 'dart:convert';
import 'dart:typed_data';

import 'package:audiobooks/core/audio/metadata/byte_source.dart';

/// The head of an ID3v2 tag: which version wrote it, and the byte range its
/// frames occupy.
class Id3Tag {
  const Id3Tag({
    required this.major,
    required this.firstFrame,
    required this.end,
  });

  /// A run of frames inside an already loaded payload, such as the sub frames
  /// of a `CHAP` frame, which carry no tag header of their own.
  const Id3Tag.embedded({required this.major, required this.end})
    : firstFrame = 0;

  /// Returns null when [source] carries no ID3v2 tag, names a version we do
  /// not read, or was written with unsynchronisation.
  ///
  /// A tag written with unsynchronisation has its bytes rewritten end to end,
  /// so its frames cannot be read in place. Refusing it here means such a file
  /// falls back to its filename and a probed duration rather than yielding
  /// corrupt text.
  static Future<Id3Tag?> read(ByteSource source) async {
    final header = await source.read(0, _headerBytes);
    if (header.length < _headerBytes) return null;
    if (header[0] != 0x49 || header[1] != 0x44 || header[2] != 0x33) {
      return null;
    }

    final major = header[3];
    if (major < 2 || major > 4) return null;

    final flags = header[5];
    if (flags & 0x80 != 0) return null;

    final end = _headerBytes + _syncSafe(header, 6);
    var firstFrame = _headerBytes;
    if (flags & 0x40 != 0) {
      final extended = await source.read(firstFrame, 4);
      if (extended.length < 4) return null;
      // Version four counts the extended header itself, version three does not.
      firstFrame += major == 4 ? _syncSafe(extended, 0) : 4 + _u32(extended, 0);
    }

    return Id3Tag(major: major, firstFrame: firstFrame, end: end);
  }

  /// 2, 3, or 4. Version two names its frames in three characters and sizes
  /// them in three bytes, so it is spelled out wherever it differs.
  final int major;

  /// Offset of the first frame header.
  final int firstFrame;

  /// Offset just past the last frame.
  final int end;

  int get frameHeaderBytes => major == 2 ? 6 : 10;
}

/// One readable frame of a tag.
///
/// The body is not loaded until [read] asks for it, so walking a tag that
/// holds a large picture costs nothing until that picture is the frame wanted.
class Id3Frame {
  const Id3Frame({
    required this.id,
    required this.major,
    required this.payloadStart,
    required this.payloadSize,
  });

  /// `PIC` and `TT2` on version two, `APIC` and `CHAP` otherwise.
  final String id;
  final int major;
  final int payloadStart;
  final int payloadSize;

  /// The frame body, or an empty list when it is larger than [maxBytes].
  Future<Uint8List> read(ByteSource source, {required int maxBytes}) async {
    if (payloadSize <= 0 || payloadSize > maxBytes) return Uint8List(0);
    return source.read(payloadStart, payloadSize);
  }
}

/// Walks the frames of [tag] in file order, reading one frame header at a time.
///
/// Compressed, encrypted, and frame unsynchronised payloads are all unreadable
/// without rewriting them first, so they are skipped. The walk stops at the
/// padding after the last frame, at a frame that overruns the tag, and at
/// [_maxFrames]. Breaking out of the stream cancels it, so a caller that wants
/// one frame does not pay for the rest.
Stream<Id3Frame> id3Frames(ByteSource source, Id3Tag tag) async* {
  final headerBytes = tag.frameHeaderBytes;
  var cursor = tag.firstFrame;

  for (var seen = 0; seen < _maxFrames; seen++) {
    if (cursor + headerBytes > tag.end) return;
    final header = await source.read(cursor, headerBytes);
    if (header.length < headerBytes) return;
    // Padding after the last frame reads as zero bytes.
    if (header[0] == 0) return;

    final id = String.fromCharCodes(header, 0, tag.major == 2 ? 3 : 4);
    final size = switch (tag.major) {
      2 => (header[3] << 16) | (header[4] << 8) | header[5],
      4 => _syncSafe(header, 4),
      _ => _u32(header, 4),
    };
    var payloadStart = cursor + headerBytes;
    var payloadSize = size;
    if (size <= 0 || payloadStart + size > tag.end) return;
    cursor = payloadStart + size;

    if (tag.major > 2) {
      final flags = header[9];
      final unreadable = tag.major == 4 ? flags & 0x0E != 0 : flags & 0xC0 != 0;
      if (unreadable) continue;
      // Version four may prefix the payload with its decoded length.
      if (tag.major == 4 && flags & 0x01 != 0) {
        payloadStart += 4;
        payloadSize -= 4;
      }
    }

    yield Id3Frame(
      id: id,
      major: tag.major,
      payloadStart: payloadStart,
      payloadSize: payloadSize,
    );
  }
}

/// Offset just past a null terminator, which is two bytes wide in the UTF-16
/// encodings and one byte wide otherwise. Returns -1 when unterminated.
int id3TerminatorEnd(Uint8List bytes, int start, {int encoding = 0}) {
  if (encoding != 1 && encoding != 2) {
    for (var index = start; index < bytes.length; index++) {
      if (bytes[index] == 0) return index + 1;
    }
    return -1;
  }
  for (var index = start; index + 1 < bytes.length; index += 2) {
    if (bytes[index] == 0 && bytes[index + 1] == 0) return index + 2;
  }
  return -1;
}

/// Decodes a string written under ID3 [encoding]: 0 ISO-8859-1, 1 UTF-16
/// behind a byte order mark, 2 UTF-16BE, 3 UTF-8.
///
/// Anything else is read as ISO-8859-1, the encoding that cannot fail. Nulls
/// are dropped and the result trimmed, so a tagger's padding never reaches the
/// library.
String decodeId3Text(Uint8List bytes, int encoding) {
  if (bytes.isEmpty) return '';
  final text = switch (encoding) {
    1 => _utf16(bytes),
    2 => _utf16(bytes, hasMark: false),
    3 => utf8.decode(bytes, allowMalformed: true),
    _ => latin1.decode(bytes, allowInvalid: true),
  };
  return text.replaceAll('\u0000', '').trim();
}

/// UTF-16 whose byte order is announced by a mark, defaulting to big endian
/// when a tagger left the mark out.
String _utf16(Uint8List bytes, {bool hasMark = true}) {
  var start = 0;
  var isBigEndian = true;
  if (hasMark && bytes.length >= 2) {
    if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
      start = 2;
    } else if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
      isBigEndian = false;
      start = 2;
    }
  }

  final units = <int>[];
  for (var index = start; index + 1 < bytes.length; index += 2) {
    units.add(
      isBigEndian
          ? (bytes[index] << 8) | bytes[index + 1]
          : (bytes[index + 1] << 8) | bytes[index],
    );
  }
  return String.fromCharCodes(units);
}

const _headerBytes = 10;

/// Far above any real tag, so this only bounds the reads a malformed one can
/// cost.
const _maxFrames = 1024;

int _u32(Uint8List bytes, int offset) =>
    (bytes[offset] << 24) |
    (bytes[offset + 1] << 16) |
    (bytes[offset + 2] << 8) |
    bytes[offset + 3];

/// ID3 sizes leave the top bit of every byte clear so a tag can never be
/// mistaken for the start of an audio frame.
int _syncSafe(Uint8List bytes, int offset) =>
    ((bytes[offset] & 0x7F) << 21) |
    ((bytes[offset + 1] & 0x7F) << 14) |
    ((bytes[offset + 2] & 0x7F) << 7) |
    (bytes[offset + 3] & 0x7F);
