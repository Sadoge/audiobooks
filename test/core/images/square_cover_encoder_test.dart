import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:audiobooks/core/audio/metadata/cover_art.dart';
import 'package:audiobooks/core/images/square_cover_encoder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const encoder = SquareCoverEncoder();

  /// Paints a PNG of the given shape, so these tests do not need a checked-in
  /// image to square.
  Future<CoverArt> art(int width, int height) async {
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder).drawRect(
      ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      ui.Paint()..color = const ui.Color(0xFF6E530F),
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    picture.dispose();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return CoverArt(
      bytes: data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      extension: 'png',
    );
  }

  Future<(int, int)> shapeOf(CoverArt cover) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(cover.bytes);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final shape = (descriptor.width, descriptor.height);
    descriptor.dispose();
    buffer.dispose();
    return shape;
  }

  test('crops a wide cover down to its shorter side', () async {
    final squared = await encoder.square(await art(160, 90));

    expect(squared, isNotNull);
    expect(await shapeOf(squared!), (90, 90));
    expect(squared.extension, 'png');
  });

  test('crops a tall cover down to its shorter side', () async {
    final squared = await encoder.square(await art(90, 160));

    expect(await shapeOf(squared!), (90, 90));
  });

  test('leaves a square cover to be stored as it arrived', () async {
    expect(await encoder.square(await art(120, 120)), isNull);
  });

  test('scales a square cover larger than the kept size', () async {
    final squared = await encoder.square(
      await art(SquareCoverEncoder.maxSide * 2, SquareCoverEncoder.maxSide * 2),
    );

    expect(await shapeOf(squared!), (
      SquareCoverEncoder.maxSide,
      SquareCoverEncoder.maxSide,
    ));
  });

  test('leaves bytes it cannot decode alone', () async {
    final squared = await encoder.square(
      CoverArt(
        bytes: Uint8List.fromList(const [0xFF, 0xD8, 0xFF, 0x00, 0x01]),
        extension: 'jpg',
      ),
    );

    expect(squared, isNull);
  });
}
