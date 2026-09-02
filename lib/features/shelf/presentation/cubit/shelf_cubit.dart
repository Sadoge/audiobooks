import 'package:audiobooks/core/errors/app_failure.dart';
import 'package:audiobooks/features/shelf/domain/entities/shelf_book.dart';
import 'package:audiobooks/features/shelf/domain/repositories/shelf_repository.dart';
import 'package:audiobooks/features/shelf/presentation/cubit/shelf_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShelfCubit extends Cubit<ShelfState> {
  ShelfCubit(this._repository) : super(const ShelfState());

  final ShelfRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: ShelfStatus.loading, errorMessage: null));
    try {
      final folder = await _repository.folder();
      if (isClosed) return;

      if (folder == null) {
        emit(
          state.copyWith(
            status: ShelfStatus.noFolder,
            folder: null,
            books: const [],
          ),
        );
        return;
      }
      if (!folder.isReadable) {
        emit(
          state.copyWith(
            status: ShelfStatus.unreadableFolder,
            folder: folder,
            books: const [],
          ),
        );
        return;
      }

      final books = await _repository.booksNotInLibrary();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ShelfStatus.ready,
          folder: folder,
          books: books,
          errorMessage: null,
        ),
      );
    } catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ShelfStatus.failure,
          errorMessage: error is AppFailure
              ? error.message
              : 'The shared folder could not be read.',
        ),
      );
    }
  }

  Future<void> chooseFolder() async {
    try {
      final chosen = await _repository.chooseFolder();
      if (isClosed || chosen == null) return;
      await load();
    } catch (_) {
      if (!isClosed) {
        emit(state.copyWith(actionMessage: 'That folder could not be opened.'));
      }
    }
  }

  Future<void> forgetFolder() async {
    await _repository.forgetFolder();
    if (isClosed) return;
    emit(const ShelfState(status: ShelfStatus.noFolder));
  }

  /// Copies a book onto this device. Nothing already here is touched: the
  /// book arrives in storage of its own, and the shelf drops it once the
  /// library has it.
  Future<void> download(ShelfBook book) async {
    if (state.downloading.containsKey(book.key)) return;
    _setProgress(book.key, 0);

    try {
      await _repository.download(
        book.key,
        onProgress: (copied, total) {
          if (isClosed || total <= 0) return;
          _setProgress(book.key, (copied / total).clamp(0, 1).toDouble());
        },
      );
      if (isClosed) return;
      _clearProgress(book.key, message: 'Added ${book.title}.');
      await load();
    } catch (error) {
      if (isClosed) return;
      _clearProgress(
        book.key,
        message: error is AppFailure
            ? error.message
            : 'That book could not be downloaded.',
      );
      // The library may have gained the book another way, which is a reason to
      // look again rather than to leave a row that should no longer be there.
      await load();
    }
  }

  void _setProgress(String key, double fraction) => emit(
    state.copyWith(
      downloading: {...state.downloading, key: fraction},
      actionMessage: null,
    ),
  );

  void _clearProgress(String key, {required String message}) => emit(
    state.copyWith(
      downloading: {...state.downloading}..remove(key),
      actionMessage: message,
    ),
  );
}
