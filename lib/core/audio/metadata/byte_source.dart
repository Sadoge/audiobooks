import 'dart:io';
import 'dart:typed_data';

/// Random-access window onto a media file.
///
/// Chapter metadata lives in small boxes scattered across a container that can
/// be several hundred megabytes, so parsing reads short ranges on demand and
/// never materialises the whole file.
abstract interface class ByteSource {
  Future<int> length();

  /// Reads up to [count] bytes from [offset]. A short read at end-of-file is
  /// returned as-is rather than raising.
  Future<Uint8List> read(int offset, int count);

  Future<void> close();
}

class FileByteSource implements ByteSource {
  FileByteSource(this._file);

  factory FileByteSource.open(String path) =>
      FileByteSource(File(path).openSync());

  final RandomAccessFile _file;
  int? _length;

  @override
  Future<int> length() async => _length ??= await _file.length();

  @override
  Future<Uint8List> read(int offset, int count) async {
    if (count <= 0) return Uint8List(0);
    await _file.setPosition(offset);
    return _file.read(count);
  }

  @override
  Future<void> close() => _file.close();
}

class MemoryByteSource implements ByteSource {
  MemoryByteSource(this._bytes);

  final Uint8List _bytes;

  @override
  Future<int> length() async => _bytes.length;

  @override
  Future<Uint8List> read(int offset, int count) async {
    if (offset >= _bytes.length || count <= 0) return Uint8List(0);
    final end = (offset + count).clamp(0, _bytes.length);
    return Uint8List.sublistView(_bytes, offset, end);
  }

  @override
  Future<void> close() async {}
}
