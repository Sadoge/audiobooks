import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

/// Where the app keeps the audio it owns.
///
/// Every book gets a folder of its own named after its id, which is what makes
/// removing a book a matter of deleting one directory, and what guarantees
/// that bringing a new book in can never write over the files of one already
/// here.
@lazySingleton
class MediaStorage {
  const MediaStorage();

  /// The folder holding every book's media.
  Future<Directory> root() async {
    final documents = await getApplicationDocumentsDirectory();
    return Directory('${documents.path}${Platform.pathSeparator}media');
  }

  /// The folder for one book, created if it is not there yet.
  Future<Directory> bookDirectory(String bookId) async =>
      Directory(await bookPath(bookId)).create(recursive: true);

  /// Where a book's folder is, whether or not it exists.
  Future<String> bookPath(String bookId) async =>
      '${(await root()).path}${Platform.pathSeparator}$bookId';
}
