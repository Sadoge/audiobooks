import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// A folder the system has granted this app, and the token that gets it back.
class ShelfFolderGrant {
  const ShelfFolderGrant({required this.path, required this.bookmark});

  final String path;

  /// The bookmark to store. Apple hands back a fresh one when the old one has
  /// gone stale — the folder moved, or was renamed — so what comes back here
  /// is always what should be kept.
  final Uint8List bookmark;
}

/// Choosing the shared library folder on iOS and macOS, and holding onto it.
///
/// Apple hands a chosen folder over inside a security scope: the app may read
/// it only while it holds that scope, and loses the right to it at the end of
/// the process unless a bookmark is kept. A folder picker that returns only a
/// path — as the plugin used everywhere else does — gives back somewhere that
/// cannot be listed and is gone by the next launch, which is why these two
/// platforms have a channel of their own.
@lazySingleton
class ShelfFolderChannel {
  const ShelfFolderChannel();

  static const _channel = MethodChannel('audiobooks/shelf_folder');

  /// Asks the listener for a folder and claims it. Null when dismissed.
  Future<ShelfFolderGrant?> choose() async =>
      _grantFrom(await _channel.invokeMapMethod<String, Object?>('choose'));

  /// Claims a folder chosen on an earlier run. Null when the grant no longer
  /// opens anything — the folder was deleted, or the provider holding it is
  /// no longer installed.
  Future<ShelfFolderGrant?> resolve(Uint8List bookmark) async => _grantFrom(
    await _channel.invokeMapMethod<String, Object?>('resolve', {
      'bookmark': bookmark,
    }),
  );

  /// Lets go of the folder currently held.
  Future<void> release() => _channel.invokeMethod<void>('release');

  ShelfFolderGrant? _grantFrom(Map<String, Object?>? reply) {
    if (reply == null) return null;
    final path = reply['path'];
    final bookmark = reply['bookmark'];
    if (path is! String || path.isEmpty) return null;
    if (bookmark is! Uint8List || bookmark.isEmpty) return null;
    return ShelfFolderGrant(path: path, bookmark: bookmark);
  }
}
