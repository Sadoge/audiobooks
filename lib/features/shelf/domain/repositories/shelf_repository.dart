import 'package:audiobooks/core/shelf/shelf_folder.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/shelf/domain/entities/shelf_book.dart';

/// The shared library folder, seen as a shelf of books this device could add.
abstract interface class ShelfRepository {
  /// The folder in use, or null when none has been chosen.
  Future<ShelfFolder?> folder();

  /// Asks the listener for a folder and remembers it.
  Future<ShelfFolder?> chooseFolder();

  /// Stops using the folder. Nothing in it is touched, and books already
  /// downloaded stay in the library.
  Future<void> forgetFolder();

  /// Books in the shared folder that this device does not already have.
  ///
  /// A book the library already holds is left out rather than listed as
  /// something already downloaded: the library is where the listener looks for
  /// books they have.
  Future<List<ShelfBook>> booksNotInLibrary();

  /// Copies a book out of the shared folder and into the library.
  ///
  /// Always writes to storage of its own, so nothing already on the device is
  /// touched. [onProgress] reports bytes copied so far against the total,
  /// because a file the listener's sync service is holding in the cloud can
  /// take minutes to arrive.
  Future<Audiobook> download(
    String key, {
    void Function(int copied, int total)? onProgress,
  });

  /// Copies a book from the library into the shared folder, so the listener's
  /// other devices can see it.
  ///
  /// A book already published under that key is left as it is; publishing
  /// never writes over what another device put there.
  Future<void> publish(Audiobook book);
}
