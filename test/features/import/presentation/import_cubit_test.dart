import 'dart:typed_data';

import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/audio_metadata_service.dart';
import 'package:audiobooks/core/audio/metadata/cover_art.dart';
import 'package:audiobooks/core/files/device_file_gateway.dart';
import 'package:audiobooks/core/files/picked_audio_file.dart';
import 'package:audiobooks/features/import/presentation/cubit/import_cubit.dart';
import 'package:audiobooks/features/import/presentation/cubit/import_state.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/entities/bookmark.dart';
import 'package:audiobooks/features/library/domain/entities/playback_progress.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const selected = PickedAudioFile(
    name: 'My Book.mp3',
    sizeBytes: 2048,
    extension: 'mp3',
    path: '/picker/My Book.mp3',
  );

  blocTest<ImportCubit, ImportState>(
    'selects supported audio files',
    build: () => ImportCubit(
      _FakeDeviceFileGateway(files: const [selected]),
      _RecordingAudiobookRepository(),
      const _FakeAudioMetadataService(),
    ),
    act: (cubit) => cubit.chooseFiles(),
    expect: () => const [
      ImportState(status: ImportStatus.choosing),
      ImportState(status: ImportStatus.selected, files: [selected]),
    ],
  );

  test('imports a selected file as a durable local audiobook', () async {
    final repository = _RecordingAudiobookRepository();
    final cubit = ImportCubit(
      _FakeDeviceFileGateway(files: const [selected]),
      repository,
      const _FakeAudioMetadataService(
        metadata: AudioFileMetadata(duration: Duration(minutes: 90)),
      ),
    );

    await cubit.chooseFiles();
    await cubit.importSeparateBooks();

    expect(cubit.state.status, ImportStatus.completed);
    expect(repository.saved, hasLength(1));
    expect(repository.saved.single.title, 'My Book');
    expect(repository.saved.single.sourcePath, '/library/My Book.mp3');
    expect(repository.saved.single.duration, const Duration(minutes: 90));
    await cubit.close();
  });

  test('turns markers inside one file into chapters of that file', () async {
    final repository = _RecordingAudiobookRepository();
    final cubit = ImportCubit(
      _FakeDeviceFileGateway(files: const [_book]),
      repository,
      const _FakeAudioMetadataService(
        metadata: AudioFileMetadata(
          duration: Duration(hours: 3),
          title: 'The Long Walk',
          author: 'A. Writer',
          chapters: [
            EmbeddedChapter(title: 'Opening', start: Duration.zero),
            EmbeddedChapter(title: 'The Road', start: Duration(hours: 1)),
            EmbeddedChapter(title: 'Home', start: Duration(hours: 2)),
          ],
        ),
      ),
    );

    await cubit.chooseFiles();
    await cubit.importSeparateBooks();

    final saved = repository.saved.single;
    expect(saved.title, 'The Long Walk');
    expect(saved.author, 'A. Writer');
    expect(saved.chapters, hasLength(3));
    expect(saved.chapters.map((chapter) => chapter.title), [
      'Opening',
      'The Road',
      'Home',
    ]);
    // Every chapter is a range inside the one imported file.
    expect(
      saved.chapters.map((chapter) => chapter.filePath).toSet(),
      {'/library/The Long Walk.m4b'},
    );
    expect(saved.chapters[1].startPosition, const Duration(hours: 1));
    expect(saved.chapters[1].duration, const Duration(hours: 1));
    expect(saved.chapters.last.duration, const Duration(hours: 1));
    await cubit.close();
  });

  test('groups several files into one book, one chapter per file', () async {
    final repository = _RecordingAudiobookRepository();
    final cubit = ImportCubit(
      _FakeDeviceFileGateway(
        files: const [
          PickedAudioFile(
            name: 'Deep Water - 01.mp3',
            sizeBytes: 10,
            extension: 'mp3',
            path: '/picker/01.mp3',
          ),
          PickedAudioFile(
            name: 'Deep Water - 02.mp3',
            sizeBytes: 10,
            extension: 'mp3',
            path: '/picker/02.mp3',
          ),
        ],
      ),
      repository,
      const _FakeAudioMetadataService(
        metadata: AudioFileMetadata(duration: Duration(minutes: 30)),
      ),
    );

    await cubit.chooseFiles();
    await cubit.importAsSingleBook();

    expect(repository.saved, hasLength(1));
    final saved = repository.saved.single;
    expect(saved.title, 'Deep Water');
    expect(saved.duration, const Duration(minutes: 60));
    expect(saved.chapters, hasLength(2));
    expect(saved.chapters.map((chapter) => chapter.index), [0, 1]);
    expect(saved.chapters.map((chapter) => chapter.filePath), [
      '/library/Deep Water - 01.mp3',
      '/library/Deep Water - 02.mp3',
    ]);
    // Each chapter starts at the top of its own file.
    expect(
      saved.chapters.every(
        (chapter) => chapter.startPosition == Duration.zero,
      ),
      isTrue,
    );
    await cubit.close();
  });

  test('gives an imported book the artwork stored inside its file', () async {
    final repository = _RecordingAudiobookRepository();
    final cubit = ImportCubit(
      _FakeDeviceFileGateway(files: const [selected]),
      repository,
      _FakeAudioMetadataService(coverArt: _art),
    );

    await cubit.chooseFiles();
    await cubit.importSeparateBooks();

    expect(repository.saved.single.coverPath, endsWith('cover.png'));
    await cubit.close();
  });

  test('prefers an image the listener attached over embedded art', () async {
    final repository = _RecordingAudiobookRepository();
    final cubit = ImportCubit(
      _FakeDeviceFileGateway(
        files: const [selected],
        pickedCover: '/picker/chosen.jpg',
      ),
      repository,
      _FakeAudioMetadataService(coverArt: _art),
    );

    await cubit.chooseFiles();
    await cubit.attachCover();
    expect(cubit.state.coverPath, '/picker/chosen.jpg');

    await cubit.importSeparateBooks();

    expect(
      repository.saved.single.coverPath,
      endsWith('attached-/picker/chosen.jpg'),
    );
    await cubit.close();
  });

  test('falls back to an image sitting beside the audio', () async {
    final repository = _RecordingAudiobookRepository();
    final cubit = ImportCubit(
      _FakeDeviceFileGateway(
        files: const [selected],
        coverBeside: '/picker/cover.jpg',
      ),
      repository,
      const _FakeAudioMetadataService(),
    );

    await cubit.chooseFiles();
    await cubit.importSeparateBooks();

    expect(
      repository.saved.single.coverPath,
      endsWith('attached-/picker/cover.jpg'),
    );
    await cubit.close();
  });

  test('imports a book without artwork rather than failing', () async {
    final repository = _RecordingAudiobookRepository();
    final cubit = ImportCubit(
      _FakeDeviceFileGateway(files: const [selected]),
      repository,
      const _FakeAudioMetadataService(),
    );

    await cubit.chooseFiles();
    await cubit.importSeparateBooks();

    expect(cubit.state.status, ImportStatus.completed);
    expect(repository.saved.single.coverPath, isNull);
    await cubit.close();
  });

  test('reports failure when a file cannot be stored', () async {
    final cubit = ImportCubit(
      _FakeDeviceFileGateway(files: const [selected], failOnPersist: true),
      _RecordingAudiobookRepository(),
      const _FakeAudioMetadataService(),
    );

    await cubit.chooseFiles();
    await cubit.importSeparateBooks();

    expect(cubit.state.status, ImportStatus.failure);
    expect(cubit.state.errorMessage, isNotNull);
    await cubit.close();
  });
}

const _book = PickedAudioFile(
  name: 'The Long Walk.m4b',
  sizeBytes: 4096,
  extension: 'm4b',
  path: '/picker/The Long Walk.m4b',
);

/// A one pixel PNG stands in for whatever a real file carries.
final _art = CoverArt(
  bytes: Uint8List.fromList(const [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
  ]),
  extension: 'png',
);

class _FakeAudioMetadataService implements AudioMetadataService {
  const _FakeAudioMetadataService({
    this.metadata = const AudioFileMetadata(),
    this.coverArt,
  });

  final AudioFileMetadata metadata;
  final CoverArt? coverArt;

  @override
  Future<AudioFileMetadata> read(String path) async => metadata;

  @override
  Future<CoverArt?> readCoverArt(String path) async => coverArt;
}

class _FakeDeviceFileGateway implements DeviceFileGateway {
  _FakeDeviceFileGateway({
    required this.files,
    this.failOnPersist = false,
    this.pickedCover,
    this.coverBeside,
  });

  final List<PickedAudioFile> files;
  final bool failOnPersist;
  final String? pickedCover;
  final String? coverBeside;

  @override
  Future<bool> canRead(String durablePathOrUri) async => true;

  @override
  Future<List<PickedAudioFile>> pickAudioFiles({
    bool allowMultiple = true,
  }) async => files;

  @override
  Future<String?> pickCoverImage() async => pickedCover;

  @override
  Future<String> persist(PickedAudioFile file, {required String bookId}) async {
    if (failOnPersist) throw StateError('unavailable');
    return '/library/${file.name}';
  }

  @override
  Future<String?> persistCoverBytes(
    CoverArt cover, {
    required String bookId,
  }) async => '/library/$bookId/cover.${cover.extension}';

  @override
  Future<String?> persistCoverFile(
    String sourcePath, {
    required String bookId,
  }) async => '/library/$bookId/attached-$sourcePath';

  @override
  Future<String?> findCoverBeside(PickedAudioFile file) async => coverBeside;

  @override
  Future<void> deleteBookFiles(String bookId) async {}
}

class _RecordingAudiobookRepository implements AudiobookRepository {
  final saved = <Audiobook>[];

  @override
  Future<void> save(Audiobook audiobook) async => saved.add(audiobook);

  @override
  Future<Audiobook?> findById(String id) async => null;

  @override
  Future<PlaybackProgress?> findProgress(String bookId) async => null;

  @override
  Future<void> remove(String id) async {}

  @override
  Future<void> removeBookmark(String id) async {}

  @override
  Future<void> saveBookmark(Bookmark bookmark) async {}

  @override
  Future<void> updateProgress(
    PlaybackProgress progress, {
    required bool isFinished,
  }) async {}

  @override
  Stream<List<Audiobook>> watchAll() => const Stream.empty();

  @override
  Stream<List<Bookmark>> watchBookmarks(String bookId) => const Stream.empty();
}
