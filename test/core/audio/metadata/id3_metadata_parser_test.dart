import 'dart:convert';
import 'dart:typed_data';

import 'package:audiobooks/core/audio/metadata/byte_source.dart';
import 'package:audiobooks/core/audio/metadata/id3_metadata_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds the smallest ID3v2 tags that still exercise real parsing paths, so
/// these tests do not need a checked-in MP3.
List<int> _u32(int value) => [
  (value >> 24) & 0xFF,
  (value >> 16) & 0xFF,
  (value >> 8) & 0xFF,
  value & 0xFF,
];

/// ID3 sizes leave the top bit of every byte clear.
List<int> _syncSafe(int value) => [
  (value >> 21) & 0x7F,
  (value >> 14) & 0x7F,
  (value >> 7) & 0x7F,
  value & 0x7F,
];

List<int> _tag(
  List<List<int>> frames, {
  int major = 3,
  int flags = 0,
  int padding = 4,
}) {
  final body = [
    for (final frame in frames) ...frame,
    ...List<int>.filled(padding, 0),
  ];
  return [
    ...latin1.encode('ID3'),
    major,
    0,
    flags,
    ..._syncSafe(body.length),
    ...body,
  ];
}

/// Version two names a frame in three characters and sizes it in three bytes,
/// with no flag byte at all.
List<int> _frame(
  String id,
  List<int> payload, {
  int major = 3,
  int frameFlags = 0,
}) => major == 2
    ? [
        ...latin1.encode(id),
        (payload.length >> 16) & 0xFF,
        (payload.length >> 8) & 0xFF,
        payload.length & 0xFF,
        ...payload,
      ]
    : [
        ...latin1.encode(id),
        ...(major == 4 ? _syncSafe(payload.length) : _u32(payload.length)),
        0,
        frameFlags,
        ...payload,
      ];

List<int> _utf16be(String value) => [
  for (final unit in value.codeUnits) ...[(unit >> 8) & 0xFF, unit & 0xFF],
];

List<int> _utf16le(String value) => [
  for (final unit in value.codeUnits) ...[unit & 0xFF, (unit >> 8) & 0xFF],
];

/// A text frame is an encoding byte and then the string.
List<int> _text(String id, String value, {int major = 3, int encoding = 0}) =>
    _frame(id, [
      encoding,
      ...switch (encoding) {
        1 => [0xFE, 0xFF, ..._utf16be(value)],
        2 => _utf16be(value),
        3 => utf8.encode(value),
        _ => latin1.encode(value),
      },
    ], major: major);

List<int> _txxx(String description, String value, {int major = 3}) => _frame(
  major == 2 ? 'TXX' : 'TXXX',
  [0, ...latin1.encode(description), 0, ...latin1.encode(value)],
  major: major,
);

/// Element id, start and end in milliseconds, start and end byte offset, then
/// whatever frames the chapter carries.
List<int> _chap(
  String elementId,
  int startMs,
  int endMs, {
  String? title,
  int major = 3,
  int titleEncoding = 0,
  int startOffset = 0xFFFFFFFF,
  int endOffset = 0xFFFFFFFF,
}) => _frame(
  'CHAP',
  [
    ...latin1.encode(elementId),
    0,
    ..._u32(startMs),
    ..._u32(endMs),
    ..._u32(startOffset),
    ..._u32(endOffset),
    if (title != null)
      ..._text(
        major == 2 ? 'TT2' : 'TIT2',
        title,
        major: major,
        encoding: titleEncoding,
      ),
  ],
  major: major,
);

List<int> _ctoc(String elementId, List<String> children, {int major = 3}) =>
    _frame(
      'CTOC',
      [
        ...latin1.encode(elementId),
        0,
        0x03, // top level and ordered
        children.length,
        for (final child in children) ...[...latin1.encode(child), 0],
      ],
      major: major,
    );

String _markers(List<(String, String)> entries) =>
    '<Markers>${entries.map((entry) => '<Marker><Name>${entry.$1}</Name>'
        '<Time>${entry.$2}</Time></Marker>').join()}</Markers>';

void main() {
  const parser = Id3MetadataParser();

  Future<ByteSource> source(List<int> bytes) async =>
      MemoryByteSource(Uint8List.fromList(bytes));

  group('tags', () {
    test('names the book after the album and the file after the title', () async {
      // A tagger that calls the file "Chapter 01" must not name the book that.
      final metadata = await parser.parse(
        await source(
          _tag([
            _text('TALB', 'The Long Walk'),
            _text('TIT2', 'Chapter 01'),
            _text('TPE1', 'Stephen King'),
            _text('TCOM', 'Frank Muller'),
          ]),
        ),
      );

      expect(metadata!.title, 'The Long Walk');
      expect(metadata.trackTitle, 'Chapter 01');
      expect(metadata.author, 'Stephen King');
      expect(metadata.narrator, 'Frank Muller');
      // The tag says nothing trustworthy about length; the engine answers that.
      expect(metadata.duration, Duration.zero);
    });

    test('reads a version two tag, whose ids are three characters', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _text('TAL', 'The Long Walk', major: 2),
            _text('TT2', 'Chapter 01', major: 2),
            _text('TP1', 'Stephen King', major: 2),
            _text('TCM', 'Frank Muller', major: 2),
          ], major: 2),
        ),
      );

      expect(metadata!.title, 'The Long Walk');
      expect(metadata.trackTitle, 'Chapter 01');
      expect(metadata.author, 'Stephen King');
      expect(metadata.narrator, 'Frank Muller');
    });

    test('reads a version four tag, whose frame sizes are syncsafe', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _text('TALB', 'The Long Walk', major: 4),
            _chap('ch0', 0, 1000, title: 'One', major: 4),
            _chap('ch1', 1000, 2000, title: 'Two', major: 4),
          ], major: 4),
        ),
      );

      expect(metadata!.title, 'The Long Walk');
      expect(metadata.chapters.map((c) => c.title), ['One', 'Two']);
    });

    test('skips the decoded length a version four frame may carry', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _frame(
              'TALB',
              [..._u32(14), 0, ...latin1.encode('The Long Walk')],
              major: 4,
              frameFlags: 0x01,
            ),
          ], major: 4),
        ),
      );

      expect(metadata!.title, 'The Long Walk');
    });

    test('falls back to the album artist when there is no artist', () async {
      final metadata = await parser.parse(
        await source(_tag([_text('TPE2', 'Stephen King')])),
      );

      expect(metadata!.author, 'Stephen King');
    });

    test('takes the narrator from a tagger that names it outright', () async {
      final metadata = await parser.parse(
        await source(_tag([_txxx('narrated_by', 'Frank Muller')])),
      );

      expect(metadata!.narrator, 'Frank Muller');
    });

    test('reads a title behind either byte order mark', () async {
      final big = await parser.parse(
        await source(
          _tag([
            _frame('TALB', [1, 0xFE, 0xFF, ..._utf16be('Café Behemoth')]),
          ]),
        ),
      );
      final little = await parser.parse(
        await source(
          _tag([
            _frame('TALB', [1, 0xFF, 0xFE, ..._utf16le('Café Behemoth')]),
          ]),
        ),
      );

      expect(big!.title, 'Café Behemoth');
      expect(little!.title, 'Café Behemoth');
    });

    test('reads UTF-16 written big endian without a mark', () async {
      final metadata = await parser.parse(
        await source(_tag([_text('TALB', 'Café Behemoth', encoding: 2)])),
      );

      expect(metadata!.title, 'Café Behemoth');
    });

    test('reads UTF-8 and drops the padding after it', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _frame('TALB', [3, ...utf8.encode('Café Behemoth'), 0, 0]),
          ]),
        ),
      );

      expect(metadata!.title, 'Café Behemoth');
    });
  });

  group('chapter frames', () {
    test('reads a chapter and its title from each frame', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _chap('ch0', 0, 60000, title: 'The Long Walk Begins'),
            _chap('ch1', 60000, 120000, title: 'The Major'),
            _chap('ch2', 120000, 180000, title: 'Garraty'),
          ]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.title), [
        'The Long Walk Begins',
        'The Major',
        'Garraty',
      ]);
      expect(metadata.chapters.map((c) => c.start), [
        Duration.zero,
        const Duration(minutes: 1),
        const Duration(minutes: 2),
      ]);
    });

    test('numbers a chapter that carries no title of its own', () async {
      final metadata = await parser.parse(
        await source(
          _tag([_chap('ch0', 0, 60000), _chap('ch1', 60000, 120000)]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.title), ['Chapter 1', 'Chapter 2']);
    });

    test('reads a chapter title written in UTF-16', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _chap('ch0', 0, 1000, title: 'Café', titleEncoding: 1),
            _chap('ch1', 1000, 2000, title: 'Behemoth', titleEncoding: 1),
          ]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.title), ['Café', 'Behemoth']);
    });

    test('ignores the byte offsets, which are for seeking by byte', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _chap('ch0', 0, 1000, title: 'One', startOffset: 0, endOffset: 512),
            _chap('ch1', 1000, 2000, title: 'Two'),
          ]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.start), [
        Duration.zero,
        const Duration(seconds: 1),
      ]);
    });

    test('orders chapters a tagger wrote out of sequence', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _chap('ch2', 120000, 180000, title: 'Third'),
            _chap('ch0', 0, 60000, title: 'First'),
            _chap('ch1', 60000, 120000, title: 'Second'),
          ]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.title), [
        'First',
        'Second',
        'Third',
      ]);
    });

    test('keeps every chapter frame when a table of contents is present', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            // The table names only one of the two chapters actually present.
            _ctoc('toc', ['ch0']),
            _chap('ch0', 0, 60000, title: 'One'),
            _chap('ch1', 60000, 120000, title: 'Two'),
          ]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.title), ['One', 'Two']);
    });

    test('ignores a lone chapter, which describes the whole file', () async {
      final metadata = await parser.parse(
        await source(_tag([_chap('ch0', 0, 60000, title: 'Only')])),
      );

      expect(metadata!.chapters, isEmpty);
    });
  });

  group('OverDrive markers', () {
    test('reads names and times in every shape they are written', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _txxx(
              'OverDrive MediaMarkers',
              _markers([
                ('Opening Credits', '0.000'),
                ('Chapter One', '12:34.500'),
                ('Chapter Two', '1:02:03.250'),
              ]),
            ),
          ]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.title), [
        'Opening Credits',
        'Chapter One',
        'Chapter Two',
      ]);
      expect(metadata.chapters.map((c) => c.start), [
        Duration.zero,
        const Duration(minutes: 12, seconds: 34, milliseconds: 500),
        const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 250),
      ]);
    });

    test('unescapes a name that carries an entity', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _txxx(
              'OverDrive MediaMarkers',
              _markers([
                ('Crime &amp; Punishment', '0.000'),
                ('Part &#50;', '60.000'),
              ]),
            ),
          ]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.title), [
        'Crime & Punishment',
        'Part 2',
      ]);
    });

    test('skips a marker whose time cannot be read, and keeps the rest', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _txxx(
              'OverDrive MediaMarkers',
              _markers([
                ('One', '0.000'),
                ('Broken', 'not a time'),
                ('Two', '60.000'),
                ('Also broken', '1:2:3:4.000'),
                ('Three', '120.000'),
              ]),
            ),
          ]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.title), ['One', 'Two', 'Three']);
    });

    test('prefers chapter frames over markers when a file has both', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _txxx(
              'OverDrive MediaMarkers',
              _markers([('Marker One', '0.000'), ('Marker Two', '60.000')]),
            ),
            _chap('ch0', 0, 60000, title: 'Frame One'),
            _chap('ch1', 60000, 120000, title: 'Frame Two'),
          ]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.title), [
        'Frame One',
        'Frame Two',
      ]);
    });

    test('survives markers that are not the XML it expects', () async {
      final metadata = await parser.parse(
        await source(
          _tag([_txxx('OverDrive MediaMarkers', '<Markers><Marker>')]),
        ),
      );

      expect(metadata!.chapters, isEmpty);
    });
  });

  group('refusals', () {
    test('leaves an unsynchronised tag alone rather than guessing', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _text('TALB', 'The Long Walk'),
            _chap('ch0', 0, 60000, title: 'One'),
            _chap('ch1', 60000, 120000, title: 'Two'),
          ], flags: 0x80),
        ),
      );

      expect(metadata, isNull);
    });

    test('reads nothing from a file without a tag', () async {
      expect(await parser.parse(await source(List.filled(64, 0x41))), isNull);
    });

    test('skips a chapter frame too short to hold its times', () async {
      final metadata = await parser.parse(
        await source(
          _tag([
            _frame('CHAP', [...latin1.encode('ch0'), 0, 0, 0]),
            _chap('ch1', 0, 60000, title: 'One'),
            _chap('ch2', 60000, 120000, title: 'Two'),
          ]),
        ),
      );

      expect(metadata!.chapters.map((c) => c.title), ['One', 'Two']);
    });

    test('stops at a frame that claims to run past the tag', () async {
      final tag = _tag([_text('TALB', 'The Long Walk')]);
      // Leave the tag's own size alone and overstate the frame's.
      final frameSize = tag.indexOf(0x54) + 4; // first byte of 'TALB'
      tag[frameSize] = 0x7F;

      final metadata = await parser.parse(await source(tag));
      // The walk stops rather than reading whatever follows the tag.
      expect(metadata, isNotNull);
      expect(metadata!.title, isNull);
      expect(metadata.chapters, isEmpty);
    });

    test('reads tags from a file that carries no chapters at all', () async {
      final metadata = await parser.parse(
        await source(
          _tag([_text('TALB', 'The Long Walk'), _text('TIT2', 'Chapter 01')]),
        ),
      );

      expect(metadata!.title, 'The Long Walk');
      expect(metadata.chapters, isEmpty);
    });
  });
}
