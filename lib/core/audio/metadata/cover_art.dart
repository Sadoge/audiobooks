import 'dart:typed_data';

/// Cover artwork lifted out of a media file, with the extension its bytes ask
/// for rather than the one a tag claims.
///
/// Artwork is held in memory only until it is written beside the book it
/// belongs to, so nothing here is kept once an import finishes.
class CoverArt {
  const CoverArt({required this.bytes, required this.extension});

  /// Returns null when [bytes] are not an image Flutter can draw, so a
  /// mislabelled or truncated tag never reaches the library as a broken cover.
  static CoverArt? from(Uint8List bytes) {
    if (bytes.isEmpty || bytes.length > maxBytes) return null;
    final extension = _extensionFor(bytes);
    return extension == null
        ? null
        : CoverArt(bytes: bytes, extension: extension);
  }

  /// Covers are a page of artwork, not a scan: anything larger is a tag we
  /// would rather skip than load.
  static const maxBytes = 12 << 20;

  /// Image formats accepted from a tag, a folder, or the picker.
  static const supportedExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
    'bmp',
  ];

  final Uint8List bytes;
  final String extension;
}

String? _extensionFor(Uint8List bytes) {
  bool startsWith(List<int> magic, [int offset = 0]) {
    if (bytes.length < offset + magic.length) return false;
    for (var index = 0; index < magic.length; index++) {
      if (bytes[offset + index] != magic[index]) return false;
    }
    return true;
  }

  if (startsWith(const [0xFF, 0xD8, 0xFF])) return 'jpg';
  if (startsWith(const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])) {
    return 'png';
  }
  if (startsWith(const [0x47, 0x49, 0x46, 0x38])) return 'gif';
  if (startsWith(const [0x52, 0x49, 0x46, 0x46]) &&
      startsWith(const [0x57, 0x45, 0x42, 0x50], 8)) {
    return 'webp';
  }
  if (startsWith(const [0x42, 0x4D])) return 'bmp';
  return null;
}
