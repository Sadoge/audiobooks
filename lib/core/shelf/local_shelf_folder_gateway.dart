import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:android_file_picker/android_file_picker.dart';
import 'package:audiobooks/core/shelf/shelf_folder.dart';
import 'package:audiobooks/core/shelf/shelf_folder_channel.dart';
import 'package:audiobooks/core/shelf/shelf_folder_gateway.dart';
import 'package:file_picker/file_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: ShelfFolderGateway)
class LocalShelfFolderGateway implements ShelfFolderGateway {
  LocalShelfFolderGateway(this._apple);

  /// Apple's own picker, which is the only one that can hand over a folder
  /// this app is allowed to read. Unused on every other platform.
  final ShelfFolderChannel _apple;

  static const _locationKey = 'shelf.folder.location';
  static const _accessKey = 'shelf.folder.access';

  /// The token that gets an Apple folder back after the process has ended.
  static const _bookmarkKey = 'shelf.folder.bookmark';

  /// Whether this platform hands folders over inside a security scope, which
  /// has to be claimed before the folder can be read and claimed again on
  /// every launch.
  static bool get _isApple => Platform.isIOS || Platform.isMacOS;

  /// Document trees the platform stores on the device itself, whose URIs name
  /// a path that ordinary file APIs can open. A tree from any other provider —
  /// a cloud app's own — names nothing on disk and is kept as a tree.
  static const _localTreeAuthority = 'com.android.externalstorage.documents';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  Future<ShelfFolder?> current() async {
    if (_isApple) return _restoreApple();

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
    if (_isApple) return _chooseApple();

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
    if (_isApple) await _apple.release();
    await _preferences.remove(_locationKey);
    await _preferences.remove(_accessKey);
    await _preferences.remove(_bookmarkKey);
  }

  /// Asks Apple's picker for a folder, and keeps the bookmark that gets it
  /// back. The scope is claimed by the native side before this returns, so the
  /// folder is readable the moment the listener has chosen it.
  Future<ShelfFolder?> _chooseApple() async {
    final grant = await _apple.choose();
    if (grant == null) return null;
    await _rememberApple(grant);
    return ShelfFolder(
      location: grant.path,
      access: ShelfFolderAccess.directory,
    );
  }

  /// Claims the folder chosen on an earlier run.
  ///
  /// A grant the system will no longer honour is the same situation as never
  /// having chosen a folder: there is nothing for the listener to repair
  /// except choosing it again, which is what the empty state asks for. The
  /// stale grant is dropped rather than left to fail on every launch.
  Future<ShelfFolder?> _restoreApple() async {
    final stored = await _preferences.getString(_bookmarkKey);
    if (stored == null || stored.isEmpty) return null;

    final Uint8List bookmark;
    try {
      bookmark = base64Decode(stored);
    } catch (_) {
      await forget();
      return null;
    }

    final grant = await _apple.resolve(bookmark);
    if (grant == null) {
      await forget();
      return null;
    }

    // Apple reissues a bookmark when the folder has moved, so what came back
    // is kept in place of what was stored.
    await _rememberApple(grant);
    return ShelfFolder(
      location: grant.path,
      access: ShelfFolderAccess.directory,
    );
  }

  Future<void> _rememberApple(ShelfFolderGrant grant) async {
    await _preferences.setString(_locationKey, grant.path);
    await _preferences.setString(_accessKey, ShelfFolderAccess.directory.name);
    await _preferences.setString(_bookmarkKey, base64Encode(grant.bookmark));
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
