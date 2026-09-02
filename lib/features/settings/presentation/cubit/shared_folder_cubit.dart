import 'package:audiobooks/core/shelf/shelf_folder.dart';
import 'package:audiobooks/features/shelf/domain/repositories/shelf_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Which folder the shared library is kept in, as Settings reports it.
@injectable
class SharedFolderCubit extends Cubit<ShelfFolder?> {
  SharedFolderCubit(this._repository) : super(null);

  final ShelfRepository _repository;

  Future<void> load() async {
    final folder = await _repository.folder();
    if (!isClosed) emit(folder);
  }

  Future<void> choose() async {
    await _repository.chooseFolder();
    await load();
  }

  Future<void> forget() async {
    await _repository.forgetFolder();
    if (!isClosed) emit(null);
  }
}
