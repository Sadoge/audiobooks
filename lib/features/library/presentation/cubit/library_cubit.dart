import 'dart:async';

import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/library/presentation/cubit/library_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit(this._repository) : super(const LibraryState());

  final AudiobookRepository _repository;
  StreamSubscription<List<Audiobook>>? _subscription;

  Future<void> start() async {
    if (_subscription != null) return;
    emit(state.copyWith(status: LibraryStatus.loading, errorMessage: null));
    _subscription = _repository.watchAll().listen(
      (books) => emit(
        state.copyWith(
          status: LibraryStatus.ready,
          books: books,
          errorMessage: null,
        ),
      ),
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

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
