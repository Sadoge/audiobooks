import 'dart:convert';
import 'dart:typed_data';

import 'package:audiobooks/core/audio/metadata/byte_source.dart';
import 'package:audiobooks/core/audio/metadata/mp4_metadata_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds the smallest MP4 boxes that still exercise real parsing paths, so
/// these tests do not need a checked-in audiobook.
List<int> _box(String type, List<int> payload) => [
  ..._u32(payload.length + 8),
  // Box types are single bytes, and iTunes tags use a byte outside ASCII.
  ...latin1.encode(type),
  ...payload,
];

List<int> _u32(int value) => [
  (value >> 24) & 0xFF,
  (value >> 16) & 0xFF,
  (value >> 8) & 0xFF,
  value & 0xFF,
];

List<int> _u64(int value) => [..._u32(value >> 32), ..._u32(value & 0xFFFFFFFF)];

List<int> _zeros(int count) => List<int>.filled(count, 0);

List<int> _ftyp() => _box('ftyp', [...latin1.encode('M4A '), ..._zeros(4)]);

/// A movie header at timescale 1000 lasting [seconds].
List<int> _mvhd(int seconds) => _box('mvhd', [
  ..._zeros(4), // version 0 and flags
  ..._zeros(8), // creation and modification
  ..._u32(1000), // timescale
  ..._u32(seconds * 1000),
  ..._zeros(4),
]);

List<int> _chpl(List<(Duration, String)> chapters) {
  final payload = <int>[
    1, // version
    ..._zeros(3), // flags
    ..._zeros(4), // reserved, present only from version one
    chapters.length,
  ];
  for (final (start, title) in chapters) {
    final bytes = utf8.encode(title);
    payload
      // Nero counts hundred nanosecond ticks.
      ..addAll(_u64(start.inMicroseconds * 10))
      ..add(bytes.length)
      ..addAll(bytes);
  }
  return _box('chpl', payload);
}

List<int> _ilstEntry(String type, String value) => _box(type, [
  ..._box('data', [..._u32(1), ..._zeros(4), ...utf8.encode(value)]),
]);

/// A cover entry: type thirteen marks JPEG bytes and fourteen marks PNG.
List<int> _covr(List<int> image, {int type = 14}) => _box('covr', [
  ..._box('data', [..._u32(type), ..._zeros(4), ...image]),
]);

List<int> _tagged(List<int> entries) => _box('udta', [
  ..._box('meta', [
    ..._zeros(4), // meta is a full box
    ..._box('ilst', entries),
  ]),
]);

void main() {
  const parser = Mp4MetadataParser();

  Future<ByteSource> source(List<int> bytes) async =>
      MemoryByteSource(Uint8List.fromList(bytes));

  test('reads duration, tags, and Nero chapter markers', () async {
    final bytes = [
      ..._ftyp(),
      ..._box('moov', [
        ..._mvhd(10800),
        ..._box('udta', [
          ..._chpl(const [
            (Duration.zero, 'Opening'),
            (Duration(hours: 1), 'The Road'),
            (Duration(hours: 2), 'Home'),
          ]),
          ..._box('meta', [
            ..._zeros(4), // meta is a full box
            ..._box('ilst', [
              ..._ilstEntry('©nam', 'The Long Walk'),
              ..._ilstEntry('©ART', 'A. Writer'),
              ..._ilstEntry('©wrt', 'A. Narrator'),
            ]),
          ]),
        ]),
      ]),
    ];

    final metadata = await parser.parse(await source(bytes));

    expect(metadata, isNotNull);
    expect(metadata!.duration, const Duration(hours: 3));
    expect(metadata.title, 'The Long Walk');
    expect(metadata.author, 'A. Writer');
    expect(metadata.narrator, 'A. Narrator');
    expect(metadata.chapters.map((chapter) => chapter.title), [
      'Opening',
      'The Road',
      'Home',
    ]);
    expect(metadata.chapters[1].start, const Duration(hours: 1));
    expect(metadata.chapters[2].start, const Duration(hours: 2));
  });

  test('reads cover art out of the tag list', () async {
    const png = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x07];
    final bytes = [
      ..._ftyp(),
      ..._box('moov', [..._mvhd(60), ..._tagged(_covr(png))]),
    ];

    final art = await parser.parseCoverArt(await source(bytes));

    expect(art, isNotNull);
    expect(art!.extension, 'png');
    expect(art.bytes, png);
  });

  test('ignores a cover tag that does not hold an image', () async {
    final bytes = [
      ..._ftyp(),
      ..._box('moov', [
        ..._mvhd(60),
        ..._tagged(_covr(const [0x00, 0x01, 0x02, 0x03])),
      ]),
    ];

    expect(await parser.parseCoverArt(await source(bytes)), isNull);
  });

  test('reads no cover from a file that carries none', () async {
    final bytes = [
      ..._ftyp(),
      ..._box('moov', [..._mvhd(60)]),
    ];

    expect(await parser.parseCoverArt(await source(bytes)), isNull);
  });

  test('reads chapters from a QuickTime text track', () async {
    // Text samples live in mdat, so it is laid out first and the sample table
    // points back into it at absolute offsets.
    const titles = ['Opening', 'The Road', 'Home'];
    final samples = <int>[];
    final sizes = <int>[];
    for (final title in titles) {
      final text = utf8.encode(title);
      final sample = [(text.length >> 8) & 0xFF, text.length & 0xFF, ...text];
      samples.addAll(sample);
      sizes.add(sample.length);
    }

    final ftyp = _ftyp();
    final mdat = _box('mdat', samples);
    final mdatPayloadStart = ftyp.length + 8;

    List<int> textTrackStbl() => _box('stbl', [
      ..._box('stts', [
        ..._zeros(4),
        ..._u32(3),
        // One sample every ten minutes at timescale 1000.
        ..._u32(1), ..._u32(600000),
        ..._u32(1), ..._u32(600000),
        ..._u32(1), ..._u32(600000),
      ]),
      ..._box('stsz', [
        ..._zeros(4),
        ..._u32(0), // sizes vary, so they are listed one by one
        ..._u32(sizes.length),
        for (final size in sizes) ..._u32(size),
      ]),
      ..._box('stsc', [
        ..._zeros(4),
        ..._u32(1),
        ..._u32(1), ..._u32(3), ..._u32(1),
      ]),
      ..._box('stco', [..._zeros(4), ..._u32(1), ..._u32(mdatPayloadStart)]),
    ]);

    List<int> trak({
      required int id,
      required String handler,
      List<int> extra = const [],
      List<int>? stbl,
    }) => _box('trak', [
      ..._box('tkhd', [
        ..._zeros(4),
        ..._zeros(8),
        ..._u32(id),
        ..._zeros(8),
      ]),
      ...extra,
      ..._box('mdia', [
        ..._box('mdhd', [
          ..._zeros(4),
          ..._zeros(8),
          ..._u32(1000),
          ..._zeros(8),
        ]),
        ..._box('hdlr', [
          ..._zeros(8),
          ...latin1.encode(handler),
          ..._zeros(12),
        ]),
        ..._box('minf', stbl ?? _box('stbl', const [])),
      ]),
    ]);

    final bytes = [
      ...ftyp,
      ...mdat,
      ..._box('moov', [
        ..._mvhd(1800),
        ...trak(
          id: 1,
          handler: 'soun',
          // The audio track is what names the chapter track.
          extra: _box('tref', _box('chap', _u32(2))),
        ),
        ...trak(id: 2, handler: 'text', stbl: textTrackStbl()),
      ]),
    ];

    final metadata = await parser.parse(await source(bytes));

    expect(metadata, isNotNull);
    expect(metadata!.chapters.map((chapter) => chapter.title), titles);
    expect(metadata.chapters[0].start, Duration.zero);
    expect(metadata.chapters[1].start, const Duration(minutes: 10));
    expect(metadata.chapters[2].start, const Duration(minutes: 20));
  });

  test('ignores a lone marker, which describes the whole file', () async {
    final bytes = [
      ..._ftyp(),
      ..._box('moov', [
        ..._mvhd(3600),
        ..._box('udta', [
          ..._chpl(const [(Duration.zero, 'The whole thing')]),
        ]),
      ]),
    ];

    final metadata = await parser.parse(await source(bytes));

    expect(metadata!.duration, const Duration(hours: 1));
    expect(metadata.chapters, isEmpty);
  });

  test('drops markers that fall outside the media', () async {
    final bytes = [
      ..._ftyp(),
      ..._box('moov', [
        ..._mvhd(3600),
        ..._box('udta', [
          ..._chpl(const [
            (Duration.zero, 'Real'),
            (Duration(minutes: 30), 'Also real'),
            (Duration(hours: 9), 'Past the end'),
          ]),
        ]),
      ]),
    ];

    final metadata = await parser.parse(await source(bytes));

    expect(metadata!.chapters.map((chapter) => chapter.title), [
      'Real',
      'Also real',
    ]);
  });

  test('returns nothing for a file that is not MP4', () async {
    final bytes = [...latin1.encode('ID3'), ..._zeros(64)];

    expect(await parser.parse(await source(bytes)), isNull);
  });

  test('survives a truncated container without throwing', () async {
    final complete = [
      ..._ftyp(),
      ..._box('moov', [
        ..._mvhd(3600),
        ..._box('udta', [
          ..._chpl(const [
            (Duration.zero, 'Opening'),
            (Duration(minutes: 20), 'The Road'),
          ]),
        ]),
      ]),
    ];

    // A box that claims more bytes than the file holds must not be followed.
    await expectLater(
      parser.parse(await source(complete.sublist(0, complete.length - 12))),
      completes,
    );
  });
}
