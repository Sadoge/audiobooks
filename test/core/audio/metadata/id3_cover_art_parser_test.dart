import 'dart:convert';
import 'dart:typed_data';

import 'package:audiobooks/core/audio/metadata/byte_source.dart';
import 'package:audiobooks/core/audio/metadata/id3_cover_art_parser.dart';
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

List<int> _frame(String id, List<int> payload, {int major = 3}) => [
  ...latin1.encode(id),
  ...(major == 4 ? _syncSafe(payload.length) : _u32(payload.length)),
  0,
  0,
  ...payload,
];

List<int> _apic(
  List<int> image, {
  int pictureType = 3,
  String description = 'Cover',
}) => [
  0, // ISO-8859-1 text
  ...latin1.encode('image/jpeg'),
  0,
  pictureType,
  ...latin1.encode(description),
  0,
  ...image,
];

const _jpeg = [0xFF, 0xD8, 0xFF, 0xE0, 0x01, 0x02];
const _png = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x03];

void main() {
  const parser = Id3CoverArtParser();

  Future<ByteSource> source(List<int> bytes) async =>
      MemoryByteSource(Uint8List.fromList(bytes));

  test('reads the picture out of a version three tag', () async {
    final art = await parser.parse(
      await source(
        _tag([
          _frame('TIT2', [0, ...latin1.encode('The Long Walk')]),
          _frame('APIC', _apic(_jpeg)),
        ]),
      ),
    );

    expect(art, isNotNull);
    expect(art!.extension, 'jpg');
    expect(art.bytes, _jpeg);
  });

  test('reads a version four tag, whose frame sizes are syncsafe', () async {
    final art = await parser.parse(
      await source(
        _tag([_frame('APIC', _apic(_png), major: 4)], major: 4),
      ),
    );

    expect(art?.extension, 'png');
  });

  test('prefers the front cover over any other picture', () async {
    final art = await parser.parse(
      await source(
        _tag([
          _frame('APIC', _apic(_png, pictureType: 8)),
          _frame('APIC', _apic(_jpeg)),
        ]),
      ),
    );

    expect(art?.bytes, _jpeg);
  });

  test('falls back to a picture that is not marked as the cover', () async {
    final art = await parser.parse(
      await source(_tag([_frame('APIC', _apic(_png, pictureType: 8))])),
    );

    expect(art?.extension, 'png');
  });

  test('skips past an extended header', () async {
    final tag = _tag([_frame('APIC', _apic(_jpeg))], flags: 0x40);
    // A version three extended header states its own size, which excludes the
    // four bytes holding that size.
    final extended = [..._u32(6), ...List<int>.filled(6, 0)];
    final body = tag.sublist(10);
    final bytes = [
      ...tag.sublist(0, 6),
      ..._syncSafe(body.length + extended.length),
      ...extended,
      ...body,
    ];

    expect((await parser.parse(await source(bytes)))?.extension, 'jpg');
  });

  test('ignores bytes that only claim to be an image', () async {
    final art = await parser.parse(
      await source(
        _tag([
          _frame('APIC', _apic(const [0x00, 0x01, 0x02, 0x03])),
        ]),
      ),
    );

    expect(art, isNull);
  });

  test('reads nothing from a file without a tag', () async {
    expect(
      await parser.parse(await source(const [0xFF, 0xFB, 0x90, 0x00])),
      isNull,
    );
  });

  test('leaves an unsynchronised tag alone rather than guessing', () async {
    final art = await parser.parse(
      await source(_tag([_frame('APIC', _apic(_jpeg))], flags: 0x80)),
    );

    expect(art, isNull);
  });
}
