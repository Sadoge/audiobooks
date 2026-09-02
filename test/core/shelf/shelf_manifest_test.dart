import 'dart:convert';

import 'package:audiobooks/core/shelf/shelf_manifest.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:flutter_test/flutter_test.dart';

ShelfManifest _manifest() => ShelfManifest(
  key: 'a-quiet-book-1',
  title: 'A Quiet Book',
  author: 'A. Reader',
  narrator: 'A. Voice',
  fileType: AudioFileType.mp3,
  duration: const Duration(hours: 3),
  cover: 'cover.jpg',
  publishedAt: DateTime.utc(2026, 9, 1),
  files: const [
    ShelfManifestFile(name: '01.mp3', sizeBytes: 1000),
    ShelfManifestFile(name: '02.mp3', sizeBytes: 2000),
  ],
  chapters: const [
    ShelfManifestChapter(
      title: 'First',
      file: '01.mp3',
      start: Duration.zero,
      duration: Duration(hours: 1),
    ),
    ShelfManifestChapter(
      title: 'Second',
      file: '02.mp3',
      start: Duration.zero,
      duration: Duration(hours: 2),
    ),
  ],
);

Object? _roundTrip(ShelfManifest manifest) =>
    jsonDecode(jsonEncode(manifest.toJson()));

void main() {
  test('survives a trip through json', () {
    final restored = ShelfManifest.fromJson(_roundTrip(_manifest()));

    expect(restored, isNotNull);
    expect(restored!.key, 'a-quiet-book-1');
    expect(restored.title, 'A Quiet Book');
    expect(restored.narrator, 'A. Voice');
    expect(restored.fileType, AudioFileType.mp3);
    expect(restored.duration, const Duration(hours: 3));
    expect(restored.cover, 'cover.jpg');
    expect(restored.totalBytes, 3000);
    expect(restored.chapters.map((chapter) => chapter.title), [
      'First',
      'Second',
    ]);
  });

  test('refuses a manifest written by a later version of the app', () {
    final json = _roundTrip(_manifest()) as Map<String, Object?>
      ..['formatVersion'] = ShelfManifest.formatVersion + 1;

    expect(ShelfManifest.fromJson(json), isNull);
  });

  test('refuses a chapter that plays out of a file the manifest omits', () {
    final json = _roundTrip(_manifest()) as Map<String, Object?>
      ..['chapters'] = [
        {
          'title': 'Ghost',
          'file': 'missing.mp3',
          'startMs': 0,
          'durationMs': 1,
        },
      ];

    expect(ShelfManifest.fromJson(json), isNull);
  });

  group('a manifest arrives from another device and is not trusted', () {
    for (final name in const [
      '../../escape.mp3',
      'nested/01.mp3',
      r'windows\01.mp3',
      '..',
      '.hidden.mp3',
    ]) {
      test('refuses a file called "$name"', () {
        final json = _roundTrip(_manifest()) as Map<String, Object?>
          ..['files'] = [
            {'name': name, 'sizeBytes': 10},
          ]
          ..['chapters'] = <Object?>[];

        expect(ShelfManifest.fromJson(json), isNull);
      });
    }
  });

  test('refuses a manifest with nothing to play', () {
    final json = _roundTrip(_manifest()) as Map<String, Object?>
      ..['files'] = <Object?>[]
      ..['chapters'] = <Object?>[];

    expect(ShelfManifest.fromJson(json), isNull);
  });

  test('refuses anything that is not a manifest at all', () {
    expect(ShelfManifest.fromJson(null), isNull);
    expect(ShelfManifest.fromJson('a string'), isNull);
    expect(ShelfManifest.fromJson(<String, Object?>{}), isNull);
  });
}
