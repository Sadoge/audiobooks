import 'package:audiobooks/core/files/device_file_gateway.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/settings/presentation/cubit/storage_summary_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class StorageSummaryCubit extends Cubit<StorageSummaryState> {
  StorageSummaryCubit(this._audiobooks, this._files)
    : super(const StorageSummaryState());

  final AudiobookRepository _audiobooks;
  final DeviceFileGateway _files;

  /// Measures the library once, when the settings screen asks. Nothing here
  /// changes while it is open, so it is read rather than watched.
  Future<void> measure() async {
    try {
      final books = await _audiobooks.watchAll().first;
      final bytes = await _files.storedMediaBytes();
      if (isClosed) return;
      emit(
        StorageSummaryState(
          status: bytes == null
              ? StorageSummaryStatus.failure
              : StorageSummaryStatus.ready,
          bookCount: books.length,
          usedBytes: bytes ?? 0,
        ),
      );
    } catch (_) {
      if (!isClosed) {
        emit(const StorageSummaryState(status: StorageSummaryStatus.failure));
      }
    }
  }
}
