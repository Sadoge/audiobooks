import 'dart:async';
import 'dart:typed_data';

import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/audio_metadata_service.dart';
import 'package:audiobooks/core/audio/metadata/cover_art.dart';
import 'package:audiobooks/core/files/device_file_gateway.dart';
import 'package:audiobooks/core/files/picked_audio_file.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/bookmark.dart';
import 'package:audiobooks/features/library/domain/entities/playback_progress.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/library/presentation/cubit/library_cubit.dart';
import 'package:audiobooks/features/library/presentation/cubit/library_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeAudiobookRepository repository;
  late _FakeDeviceFileGateway files;

  setUp(() {
    repository = _FakeAudiobookRepository();
    files = _FakeDeviceFileGateway();
  });
  tearDown(() => repository.dispose());

  LibraryCubit build({CoverArt? coverArt}) =>
      LibraryCubit(repository, files, _FakeAudioMetadataService(coverArt));

  blocTest<LibraryCubit, LibraryState>(
    'emits loading then an empty ready library',
    build: build,
    act: (cubit) async {
      await cubit.start();
      repository.emit(const []);
    },
    expect: () => const [
      LibraryState(status: LibraryStatus.loading),
      LibraryState(status: LibraryStatus.ready),
    ],
  );

  blocTest<LibraryCubit, LibraryState>(
    'surfaces a recoverable failure when the repository stream fails',
    build: build,
    act: (cubit) async {
      await cubit.start();
      repository.emitError(StateError('database unavailable'));
    },
    expect: () => [
      const LibraryState(status: LibraryStatus.loading),
      isA<LibraryState>()
          .having((state) => state.status, 'status', LibraryStatus.failure)
          .having((state) => state.errorMessage, 'message', isNotNull),
    ],
  );

  test('puts a chosen image on a book that arrived without one', () async {
    files.pickedCover = '/pictures/cover.jpg';
    final cubit = build();

    await cubit.changeCover(_book);

    expect(repository.saved.single.coverPath, '/media/book-1/attached');
    expect(cubit.state.actionMessage, 'Cover updated.');
    await cubit.close();
  });

  test('leaves a book alone when the picker is dismissed', () async {
    final cubit = build();

    await cubit.changeCover(_book);

    expect(repository.saved, isEmpty);
    expect(cubit.state.actionMessage, isNull);
    await cubit.close();
  });

  test('removes a book and the files copied for it', () async {
    final cubit = build();

    await cubit.remove(_book);

    expect(repository.removed, ['book-1']);
    expect(files.deletedBooks, ['book-1']);
    expect(cubit.state.actionMessage, contains('The Long Walk'));
    await cubit.close();
  });

  test('lifts artwork out of books imported before covers', () async {
    final cubit = build(coverArt: _art);

    await cubit.start();
    repository.emit([_book]);
    // The library is listed first; artwork follows without holding it up.
    await Future<void>.delayed(Duration.zero);

    expect(repository.saved.single.coverPath, '/media/book-1/cover.png');
    await cubit.close();
  });

  test('reads a book without artwork only once', () async {
    final cubit = build();

    await cubit.start();
    repository
      ..emit([_book])
      ..emit([_book]);
    await Future<void>.delayed(Duration.zero);

    expect(repository.saved, isEmpty);
    await cubit.close();
  });
}

final _book = Audiobook(
  id: 'book-1',
  title: 'The Long Walk',
  author: 'A. Writer',
  dateAdded: DateTime(2024),
  fileType: AudioFileType.m4b,
  sourcePath: '/media/book-1/The Long Walk.m4b',
);

final _art = CoverArt(
  bytes: Uint8List.fromList(const [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
  ]),
  extension: 'png',
);

class _FakeAudioMetadataService implements AudioMetadataService {
  const _FakeAudioMetadataService(this.coverArt);

  final CoverArt? coverArt;

  @override
  Future<AudioFileMetadata> read(String path) async =>
      const AudioFileMetadata();

  @override
  Future<CoverArt?> readCoverArt(String path) async => coverArt;
}

class _FakeDeviceFileGateway implements DeviceFileGateway {
  String? pickedCover;
  final deletedBooks = <String>[];

  @override
  Future<bool> canRead(String durablePathOrUri) async => true;

  @override
  Future<List<PickedAudioFile>> pickAudioFiles({
    bool allowMultiple = true,
  }) async => const [];

  @override
  Future<String?> pickCoverImage() async => pickedCover;

  @override
  Future<String> persist(
    PickedAudioFile file, {
    required String bookId,
  }) async => '/media/$bookId/${file.name}';

  @override
  Future<String?> persistCoverBytes(
    CoverArt cover, {
    required String bookId,
  }) async => '/media/$bookId/cover.${cover.extension}';

  @override
  Future<String?> persistCoverFile(
    String sourcePath, {
    required String bookId,
  }) async => '/media/$bookId/attached';

  @override
  Future<String?> findCoverBeside(PickedAudioFile file) async => null;

  @override
  Future<void> deleteBookFiles(String bookId) async => deletedBooks.add(bookId);
}

class _FakeAudiobookRepository implements AudiobookRepository {
  final _controller = StreamController<List<Audiobook>>();
  final saved = <Audiobook>[];
  final removed = <String>[];

  void emit(List<Audiobook> books) => _controller.add(books);
  void emitError(Object error) => _controller.addError(error);
  Future<void> dispose() => _controller.close();

  @override
  Stream<List<Audiobook>> watchAll() => _controller.stream;

  @override
  Future<Audiobook?> findById(String id) async => null;

  @override
  Future<PlaybackProgress?> findProgress(String bookId) async => null;

  @override
  Future<void> remove(String id) async => removed.add(id);

  @override
  Future<void> removeBookmark(String id) async {}

  @override
  Future<void> save(Audiobook audiobook) async => saved.add(audiobook);

  @override
  Future<void> saveBookmark(Bookmark bookmark) async {}

  @override
  Future<void> updateProgress(
    PlaybackProgress progress, {
    required bool isFinished,
  }) async {}

  @override
  Stream<List<Bookmark>> watchBookmarks(String bookId) => const Stream.empty();
}
