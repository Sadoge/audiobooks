import 'dart:typed_data';

import 'package:audiobooks/core/audio/metadata/byte_source.dart';
import 'package:audiobooks/core/audio/metadata/cover_art.dart';
import 'package:audiobooks/core/audio/metadata/id3_frames.dart';

/// Reads the cover picture out of an ID3v2 tag, which is where an MP3
/// audiobook keeps its artwork.
///
/// Frames are walked one short read at a time and only the picture frame
/// itself is loaded, so a tag holding a large image costs one read of that
/// image and nothing more.
class Id3CoverArtParser {
  const Id3CoverArtParser();

  /// Returns null when [source] carries no ID3v2 tag or no usable picture.
  Future<CoverArt?> parse(ByteSource source) async {
    final tag = await Id3Tag.read(source);
    if (tag == null) return null;

    final pictureFrame = tag.major == 2 ? 'PIC' : 'APIC';
    CoverArt? fallback;
    await for (final frame in id3Frames(source, tag)) {
      if (frame.id != pictureFrame) continue;

      final picture = _picture(
        await frame.read(source, maxBytes: CoverArt.maxBytes),
        major: tag.major,
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
    var cursor = major == 2 ? 4 : id3TerminatorEnd(payload, 1);
    if (cursor <= 0 || cursor >= payload.length) return null;

    final pictureType = payload[cursor];
    cursor = id3TerminatorEnd(payload, cursor + 1, encoding: encoding);
    if (cursor <= 0 || cursor >= payload.length) return null;

    final art = CoverArt.from(Uint8List.sublistView(payload, cursor));
    return art == null
        ? null
        : _Picture(art: art, isFrontCover: pictureType == 3);
  }
}

class _Picture {
  const _Picture({required this.art, required this.isFrontCover});

  final CoverArt art;
  final bool isFrontCover;
}
