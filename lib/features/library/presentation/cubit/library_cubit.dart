import 'dart:async';

import 'package:audiobooks/core/audio/metadata/audio_metadata_service.dart';
import 'package:audiobooks/core/errors/app_failure.dart';
import 'package:audiobooks/core/files/device_file_gateway.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/library/presentation/cubit/library_state.dart';
import 'package:audiobooks/features/shelf/domain/repositories/shelf_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit(this._repository, this._files, this._metadata, this._shelf)
    : super(const LibraryState());

  final AudiobookRepository _repository;
  final DeviceFileGateway _files;
  final AudioMetadataService _metadata;
  final ShelfRepository _shelf;
  StreamSubscription<List<Audiobook>>? _subscription;

  /// Books already looked at for artwork, so a book whose file carries none is
  /// read once rather than on every update.
  final _scannedForCovers = <String>{};

  Future<void> start() async {
    if (_subscription != null) return;
    emit(state.copyWith(status: LibraryStatus.loading, errorMessage: null));
    _subscription = _repository.watchAll().listen(
      (books) {
        emit(
          state.copyWith(
            status: LibraryStatus.ready,
            books: books,
            errorMessage: null,
            actionMessage: null,
          ),
        );
        unawaited(_addMissingCovers(books));
      },
      onError: (Object error, StackTrace stackTrace) => emit(
        state.copyWith(
          status: LibraryStatus.failure,
          errorMessage: 'Your local library could not be opened.',
        ),
      ),
    );
  }

  Future<void> retry() async {
    await _subscription?.cancel();
    _subscription = null;
    await start();
  }

  /// Puts an image from the device on a book, which is how a book that
  /// arrived without artwork gets a cover after the fact.
  Future<void> changeCover(Audiobook book) async {
    try {
      final picked = await _files.pickCoverImage();
      if (picked == null || isClosed) return;

      final stored = await _files.persistCoverFile(picked, bookId: book.id);
      if (stored == null) {
        emit(state.copyWith(actionMessage: 'That image could not be used.'));
        return;
      }

      await _repository.save(book.copyWith(coverPath: stored));
      if (!isClosed) emit(state.copyWith(actionMessage: 'Cover updated.'));
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(actionMessage: 'The cover could not be changed.'));
      }
    }
  }

  /// Copies a book into the shared folder, so the listener's other devices
  /// can see it and bring it across.
  ///
  /// A book another device published under the same key is left exactly as it
  /// is; publishing never writes over what is already in the folder.
  Future<void> publish(Audiobook book) async {
    emit(
      state.copyWith(
        actionMessage: 'Adding ${book.title} to the shared library.',
      ),
    );
    try {
      await _shelf.publish(book);
      if (!isClosed) {
        emit(
          state.copyWith(
            actionMessage: 'Added ${book.title} to the shared library.',
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (!isClosed) emit(state.copyWith(actionMessage: failure.message));
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            actionMessage:
                'That book could not be added to the shared library.',
          ),
        );
      }
    }
  }

  /// Takes a book out of the library and deletes the copies made for it, which
  /// is the only way that storage is reclaimed.
  Future<void> remove(Audiobook book) async {
    try {
      await _repository.remove(book.id);
      await _files.deleteBookFiles(book.id);
      if (!isClosed) {
        emit(state.copyWith(actionMessage: 'Removed ${book.title}.'));
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(actionMessage: 'That audiobook could not be removed.'),
        );
      }
    }
  }

  /// Books imported before artwork was read still have their audio on disk,
  /// so their covers are lifted the first time the library lists them.
  Future<void> _addMissingCovers(List<Audiobook> books) async {
    for (final book in books) {
      if (book.coverPath != null) continue;
      if (!_scannedForCovers.add(book.id)) continue;

      final path = book.sourcePath ?? book.chapters.firstOrNull?.filePath;
      if (path == null) continue;
      try {
        final art = await _metadata.readCoverArt(path);
        if (art == null || isClosed) continue;
        final stored = await _files.persistCoverBytes(art, bookId: book.id);
        if (stored == null || isClosed) continue;
        await _repository.save(book.copyWith(coverPath: stored));
      } catch (_) {
        // The book keeps its placeholder. A library that already opened is
        // never interrupted for artwork.
      }
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
