import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:audiobooks/core/audio/metadata/cover_art.dart';

/// Squares cover artwork before it is stored.
///
/// Audiobooks are published as square covers, and every surface here draws
/// them square, so artwork that arrives in another shape is centre-cropped
/// once at import rather than cropped again on every frame. Oversized art is
/// scaled down at the same time, since no surface draws it larger.
class SquareCoverEncoder {
  const SquareCoverEncoder();

  /// The widest square kept. Comfortably above the largest cover the app
  /// draws, and small enough that a book's artwork stays a rounding error
  /// beside its audio.
  static const maxSide = 1024;

  /// Returns [cover] as a square image, or null when it is already square
  /// within [maxSide] and can be stored exactly as it arrived.
  ///
  /// Never throws: artwork that cannot be decoded is stored untouched and
  /// drawn cropped instead.
  Future<CoverArt?> square(CoverArt cover) async {
    ui.ImmutableBuffer? buffer;
    ui.ImageDescriptor? descriptor;
    ui.Codec? codec;
    ui.Image? decoded;
    ui.Image? squared;
    try {
      buffer = await ui.ImmutableBuffer.fromUint8List(cover.bytes);
      descriptor = await ui.ImageDescriptor.encoded(buffer);
      final width = descriptor.width;
      final height = descriptor.height;
      if (width <= 0 || height <= 0) return null;
      if (width == height && width <= maxSide) return null;

      // Decoding straight to the size that will be kept means a very large
      // cover is never held at full resolution.
      final side = math.min(width, height);
      final target = math.min(side, maxSide);
      final scale = target / side;
      codec = await descriptor.instantiateCodec(
        targetWidth: math.max(1, (width * scale).round()),
        targetHeight: math.max(1, (height * scale).round()),
      );
      decoded = (await codec.getNextFrame()).image;

      final recorder = ui.PictureRecorder();
      final size = target.toDouble();
      ui.Canvas(recorder).drawImageRect(
        decoded,
        ui.Rect.fromLTWH(
          (decoded.width - target) / 2,
          (decoded.height - target) / 2,
          size,
          size,
        ),
        ui.Rect.fromLTWH(0, 0, size, size),
        ui.Paint()..filterQuality = ui.FilterQuality.medium,
      );
      final picture = recorder.endRecording();
      squared = await picture.toImage(target, target);
      picture.dispose();

      final data = await squared.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) return null;
      return CoverArt(
        bytes: data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        extension: 'png',
      );
    } catch (_) {
      return null;
    } finally {
      decoded?.dispose();
      squared?.dispose();
      codec?.dispose();
      descriptor?.dispose();
      buffer?.dispose();
    }
  }
}
