import 'package:audiobooks/core/audio/metadata/audio_file_metadata.dart';
import 'package:audiobooks/core/audio/metadata/audio_metadata_service.dart';
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

class _FakeAudioMetadataService implements AudioMetadataService {
  const _FakeAudioMetadataService({
    this.metadata = const AudioFileMetadata(),
  });

  final AudioFileMetadata metadata;

  @override
  Future<AudioFileMetadata> read(String path) async => metadata;
}

class _FakeDeviceFileGateway implements DeviceFileGateway {
  const _FakeDeviceFileGateway({
    required this.files,
    this.failOnPersist = false,
  });

  final List<PickedAudioFile> files;
  final bool failOnPersist;

  @override
  Future<bool> canRead(String durablePathOrUri) async => true;

  @override
  Future<List<PickedAudioFile>> pickAudioFiles({
    bool allowMultiple = true,
  }) async => files;

  @override
  Future<String> persist(PickedAudioFile file, {required String bookId}) async {
    if (failOnPersist) throw StateError('unavailable');
    return '/library/${file.name}';
  }
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
