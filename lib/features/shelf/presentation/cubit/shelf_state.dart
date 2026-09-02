import 'package:audiobooks/core/shelf/shelf_folder.dart';
import 'package:audiobooks/features/shelf/domain/entities/shelf_book.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shelf_state.freezed.dart';

enum ShelfStatus {
  initial,
  loading,

  /// No folder has been nominated yet.
  noFolder,

  /// A folder was chosen, but this build cannot open it.
  unreadableFolder,
  ready,
  failure,
}

@freezed
abstract class ShelfState with _$ShelfState {
  const factory ShelfState({
    @Default(ShelfStatus.initial) ShelfStatus status,

    /// Books in the shared folder that this device does not have. A book
    /// already in the library is not here — it is in the library.
    @Default(<ShelfBook>[]) List<ShelfBook> books,
    ShelfFolder? folder,
    String? errorMessage,

    /// The outcome of a download, shown once and then dropped.
    String? actionMessage,

    /// How far along each download in flight is, from zero to one, keyed by
    /// the book it belongs to.
    @Default(<String, double>{}) Map<String, double> downloading,
  }) = _ShelfState;
}
