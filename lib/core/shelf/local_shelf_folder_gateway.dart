import 'dart:io';

import 'package:android_file_picker/android_file_picker.dart';
import 'package:audiobooks/core/shelf/shelf_folder.dart';
import 'package:audiobooks/core/shelf/shelf_folder_gateway.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: ShelfFolderGateway)
class LocalShelfFolderGateway implements ShelfFolderGateway {
  static const _locationKey = 'shelf.folder.location';
  static const _accessKey = 'shelf.folder.access';

  /// Document trees the platform stores on the device itself, whose URIs name
  /// a path that ordinary file APIs can open. A tree from any other provider —
  /// a cloud app's own — names nothing on disk and is kept as a tree.
  static const _localTreeAuthority = 'com.android.externalstorage.documents';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  Future<ShelfFolder?> current() async {
    final location = await _preferences.getString(_locationKey);
    if (location == null || location.isEmpty) return null;

    final stored = await _preferences.getString(_accessKey);
    final access = ShelfFolderAccess.values
        .where((value) => value.name == stored)
        .firstOrNull;
    final folder = ShelfFolder(
      location: location,
      access: access ?? ShelfFolderAccess.directory,
    );

    // A directory that has since gone — an unmounted volume, a folder the
    // listener moved, an iOS container rebuilt by a restore — is the same
    // situation as never having chosen one.
    if (folder.access == ShelfFolderAccess.directory &&
        !await Directory(folder.location).exists()) {
      return null;
    }
    return folder;
  }

  @override
  Future<ShelfFolder?> choose() async {
    final chosen = await FilePicker.getDirectoryPath(
      dialogTitle: 'Choose your shared library folder',
      // Android hands back a document tree rather than a directory, and the
      // grant on it has to outlive the process for the folder to still be
      // there on the next launch. Asking for write as well is what lets a
      // book be published into the folder later.
      androidOptions: const FilePickerAndroidOptions(
        safOptions: AndroidSAFOptions(
          grant: AndroidSAFGrant.lifetime,
          accessMode: AndroidSAFAccessMode.readWrite,
        ),
      ),
    );
    if (chosen == null || chosen.isEmpty) return null;

    final folder = _interpret(chosen);
    await _preferences.setString(_locationKey, folder.location);
    await _preferences.setString(_accessKey, folder.access.name);
    return folder;
  }

  @override
  Future<void> forget() async {
    await _preferences.remove(_locationKey);
    await _preferences.remove(_accessKey);
  }

  /// Reads what the picker gave back. Everywhere but Android that is already a
  /// directory; on Android it is a document tree URI, which is worth turning
  /// into a path when it names one.
  ShelfFolder _interpret(String chosen) {
    if (!chosen.startsWith('content://')) {
      return ShelfFolder(location: chosen, access: ShelfFolderAccess.directory);
    }

    final path = resolveDocumentTreePath(chosen);
    return path == null
        ? ShelfFolder(location: chosen, access: ShelfFolderAccess.documentTree)
        : ShelfFolder(location: path, access: ShelfFolderAccess.directory);
  }

  /// Turns an Android document tree URI into the directory it stands for, when
  /// it stands for one.
  ///
  /// A tree on the device's own storage encodes the path it points at, so
  /// `…/tree/primary%3ABooks%2FAudio` is `/storage/emulated/0/Books/Audio` —
  /// which is what a folder kept in step by a sync client that writes to disk
  /// looks like. A tree belonging to a cloud provider's own document store
  /// encodes an opaque id instead, and gives back null.
  ///
  /// Visible for testing.
  static String? resolveDocumentTreePath(String treeUri) {
    final uri = Uri.tryParse(treeUri);
    if (uri == null || uri.authority != _localTreeAuthority) return null;

    // The path is `/tree/<documentId>`, and the id is `<volume>:<relative>`.
    final segments = uri.pathSegments;
    final treeAt = segments.indexOf('tree');
    if (treeAt < 0 || treeAt + 1 >= segments.length) return null;

    final documentId = segments[treeAt + 1];
    final colon = documentId.indexOf(':');
    if (colon < 0) return null;

    final volume = documentId.substring(0, colon);
    final relative = documentId.substring(colon + 1);
    final root = volume == 'primary'
        ? '/storage/emulated/0'
        : '/storage/$volume';
    return relative.isEmpty ? root : '$root/$relative';
  }
}
