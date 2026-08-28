import 'dart:async';

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

  setUp(() => repository = _FakeAudiobookRepository());
  tearDown(() => repository.dispose());

  blocTest<LibraryCubit, LibraryState>(
    'emits loading then an empty ready library',
    build: () => LibraryCubit(repository),
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
    build: () => LibraryCubit(repository),
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
}

class _FakeAudiobookRepository implements AudiobookRepository {
  final _controller = StreamController<List<Audiobook>>();

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
  Future<void> remove(String id) async {}

  @override
  Future<void> removeBookmark(String id) async {}

  @override
  Future<void> save(Audiobook audiobook) async {}

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
