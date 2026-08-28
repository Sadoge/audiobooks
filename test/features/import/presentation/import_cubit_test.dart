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
    );

    await cubit.chooseFiles();
    await cubit.importSeparateBooks();

    expect(cubit.state.status, ImportStatus.completed);
    expect(repository.saved, hasLength(1));
    expect(repository.saved.single.title, 'My Book');
    expect(repository.saved.single.sourcePath, '/library/My Book.mp3');
    await cubit.close();
  });
}

class _FakeDeviceFileGateway implements DeviceFileGateway {
  const _FakeDeviceFileGateway({required this.files});

  final List<PickedAudioFile> files;

  @override
  Future<bool> canRead(String durablePathOrUri) async => true;

  @override
  Future<List<PickedAudioFile>> pickAudioFiles({
    bool allowMultiple = true,
  }) async => files;

  @override
  Future<String> persist(
    PickedAudioFile file, {
    required String bookId,
  }) async => '/library/${file.name}';
}

class _RecordingAudiobookRepository implements AudiobookRepository {
  final saved = <Audiobook>[];

  @override
  Future<void> save(Audiobook audiobook) async => saved.add(audiobook);

  @override
  Future<Audiobook?> findById(String id) async => null;

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
