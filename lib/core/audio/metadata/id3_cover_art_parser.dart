import 'dart:typed_data';

import 'package:audiobooks/core/audio/metadata/byte_source.dart';
import 'package:audiobooks/core/audio/metadata/cover_art.dart';

/// Reads the cover picture out of an ID3v2 tag, which is where an MP3
/// audiobook keeps its artwork.
///
/// Frame headers are walked one short read at a time and only the picture
/// frame itself is loaded, so a tag holding a large image costs one read of
/// that image and nothing more.
class Id3CoverArtParser {
  const Id3CoverArtParser();

  /// Returns null when [source] carries no ID3v2 tag or no usable picture.
  Future<CoverArt?> parse(ByteSource source) async {
    final header = await source.read(0, _headerBytes);
    if (header.length < _headerBytes) return null;
    if (header[0] != 0x49 || header[1] != 0x44 || header[2] != 0x33) {
      return null;
    }

    final major = header[3];
    if (major < 2 || major > 4) return null;

    final flags = header[5];
    // A tag written with unsynchronisation has its bytes rewritten end to end,
    // so its frames cannot be read in place. Such a file falls back to the
    // other ways of finding a cover rather than yielding corrupt bytes.
    if (flags & 0x80 != 0) return null;

    final tagEnd = _headerBytes + _syncSafe(header, 6);
    var cursor = _headerBytes;
    if (flags & 0x40 != 0) {
      final extended = await source.read(cursor, 4);
      if (extended.length < 4) return null;
      // Version four counts the extended header itself, version three does not.
      cursor += major == 4 ? _syncSafe(extended, 0) : 4 + _u32(extended, 0);
    }

    CoverArt? fallback;
    final frameHeaderBytes = major == 2 ? 6 : 10;
    while (cursor + frameHeaderBytes <= tagEnd) {
      final frame = await source.read(cursor, frameHeaderBytes);
      if (frame.length < frameHeaderBytes) break;
      // Padding after the last frame reads as zero bytes.
      if (frame[0] == 0) break;

      final id = String.fromCharCodes(frame, 0, major == 2 ? 3 : 4);
      final size = switch (major) {
        2 => (frame[3] << 16) | (frame[4] << 8) | frame[5],
        4 => _syncSafe(frame, 4),
        _ => _u32(frame, 4),
      };
      var payloadStart = cursor + frameHeaderBytes;
      var payloadSize = size;
      if (size <= 0 || payloadStart + size > tagEnd) break;
      cursor = payloadStart + size;

      if (major > 2) {
        final frameFlags = frame[9];
        // Compressed, encrypted, and per-frame unsynchronised payloads are all
        // unreadable without rewriting them first.
        final unreadable = major == 4
            ? frameFlags & 0x0E != 0
            : frameFlags & 0xC0 != 0;
        if (unreadable) continue;
        // Version four may prefix the payload with its decoded length.
        if (major == 4 && frameFlags & 0x01 != 0) {
          payloadStart += 4;
          payloadSize -= 4;
        }
      }

      if (id != (major == 2 ? 'PIC' : 'APIC')) continue;
      if (payloadSize <= 0 || payloadSize > CoverArt.maxBytes) continue;

      final picture = _picture(
        await source.read(payloadStart, payloadSize),
        major: major,
      );
      if (picture == null) continue;
      // Type three is the front cover; anything else only stands in for it.
      if (picture.isFrontCover) return picture.art;
      fallback ??= picture.art;
    }
    return fallback;
  }

  /// Reads one picture frame: an encoding byte, the image format, a picture
  /// type, a description, and then the image itself.
  _Picture? _picture(Uint8List payload, {required int major}) {
    if (payload.length < 4) return null;
    final encoding = payload[0];
    // Version two names the format in three bytes; later versions use a
    // null-terminated MIME type. Neither is trusted over the image's own bytes.
    var cursor = major == 2 ? 4 : _afterLatin1(payload, 1);
    if (cursor <= 0 || cursor >= payload.length) return null;

    final pictureType = payload[cursor];
    cursor = _afterDescription(payload, cursor + 1, encoding);
    if (cursor <= 0 || cursor >= payload.length) return null;

    final art = CoverArt.from(Uint8List.sublistView(payload, cursor));
    return art == null
        ? null
        : _Picture(art: art, isFrontCover: pictureType == 3);
  }
}

const _headerBytes = 10;

/// Offset just past a null-terminated single byte string.
int _afterLatin1(Uint8List bytes, int start) {
  for (var index = start; index < bytes.length; index++) {
    if (bytes[index] == 0) return index + 1;
  }
  return -1;
}

/// Offset just past the description, whose terminator is two bytes wide in the
/// UTF-16 encodings and one byte wide otherwise.
int _afterDescription(Uint8List bytes, int start, int encoding) {
  if (encoding != 1 && encoding != 2) return _afterLatin1(bytes, start);
  for (var index = start; index + 1 < bytes.length; index += 2) {
    if (bytes[index] == 0 && bytes[index + 1] == 0) return index + 2;
  }
  return -1;
}

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

class _Picture {
  const _Picture({required this.art, required this.isFrontCover});

  final CoverArt art;
  final bool isFrontCover;
}
