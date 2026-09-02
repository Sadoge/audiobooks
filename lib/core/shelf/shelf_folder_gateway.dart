import 'package:audiobooks/core/shelf/shelf_folder.dart';

/// Choosing the shared library folder, and remembering it across launches.
///
/// Kept apart from reading the folder's contents so that the platform work —
/// a native picker, and a grant that has to outlive the process — stays in one
/// place. Everything above this deals in an ordinary directory.
abstract interface class ShelfFolderGateway {
  /// The folder chosen previously, or null when none has been, or when the
  /// grant that made it reachable is gone.
  ///
  /// A folder the system will no longer open is reported as null rather than
  /// as an error: the listener has nothing to fix except choosing it again,
  /// which is what the empty state asks them to do.
  Future<ShelfFolder?> current();

  /// Asks the listener for a folder and remembers it. Null when the picker is
  /// dismissed.
  Future<ShelfFolder?> choose();

  /// Forgets the folder. The folder itself and everything in it is left alone.
  Future<void> forget();
}
