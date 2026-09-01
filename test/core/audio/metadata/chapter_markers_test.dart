import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/chapter_markers.dart';
import 'package:flutter_test/flutter_test.dart';

EmbeddedChapter _marker(String title, int minutes) =>
    EmbeddedChapter(title: title, start: Duration(minutes: minutes));

void main() {
  test('orders markers a tagger wrote out of sequence', () {
    final sanitised = sanitiseChapters([
      _marker('Three', 30),
      _marker('One', 0),
      _marker('Two', 15),
    ], const Duration(hours: 1));

    expect(sanitised.map((chapter) => chapter.title), [
      'One',
      'Two',
      'Three',
    ]);
  });

  test('keeps one marker per start', () {
    final sanitised = sanitiseChapters([
      _marker('One', 0),
      _marker('One again', 0),
      _marker('Two', 15),
    ], const Duration(hours: 1));

    expect(sanitised.map((chapter) => chapter.title), ['One', 'Two']);
  });

  test('drops a marker before the start of the media', () {
    final sanitised = sanitiseChapters([
      const EmbeddedChapter(title: 'Before', start: Duration(minutes: -5)),
      _marker('One', 0),
      _marker('Two', 15),
    ], const Duration(hours: 1));

    expect(sanitised.map((chapter) => chapter.title), ['One', 'Two']);
  });

  test('drops a marker at or past the end of the media', () {
    final sanitised = sanitiseChapters([
      _marker('One', 0),
      _marker('Two', 15),
      _marker('Past the end', 90),
      _marker('Exactly the end', 60),
    ], const Duration(hours: 1));

    expect(sanitised.map((chapter) => chapter.title), ['One', 'Two']);
  });

  test('clamps nothing while the duration is still unknown', () {
    final sanitised = sanitiseChapters([
      _marker('One', 0),
      _marker('Two', 15),
      _marker('Late', 900),
    ], Duration.zero);

    expect(sanitised.map((chapter) => chapter.title), ['One', 'Two', 'Late']);
  });

  test('gives back nothing for a lone marker, which describes the file', () {
    expect(
      sanitiseChapters([_marker('One', 0)], const Duration(hours: 1)),
      isEmpty,
    );
  });

  test('gives back nothing when clamping leaves a single marker', () {
    final sanitised = sanitiseChapters([
      _marker('One', 0),
      _marker('Past the end', 90),
    ], const Duration(hours: 1));

    expect(sanitised, isEmpty);
  });

  /// The service sanitises once where markers are read and again once the file
  /// has been probed for its duration, which only holds if the second pass is
  /// a no-op.
  test('running over its own output changes nothing', () {
    const duration = Duration(hours: 1);
    final markers = [
      _marker('Three', 30),
      _marker('One', 0),
      _marker('One again', 0),
      const EmbeddedChapter(title: 'Before', start: Duration(minutes: -5)),
      _marker('Past the end', 90),
    ];

    final once = sanitiseChapters(markers, duration);
    expect(sanitiseChapters(once, duration), once);
  });
}
