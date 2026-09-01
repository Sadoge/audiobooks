import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Permission to put the player where the system can show it.
///
/// From Android 13 the media notification needs the listener's say-so, and the
/// lock screen controls are that same notification: without it the book plays
/// on perfectly well but appears nowhere outside the app. Everywhere else the
/// answer is yes by virtue of having installed the app.
abstract interface class PlaybackNotificationPermission {
  /// Asks, if the platform needs asking. Answers whether the player may show
  /// itself, and never throws: a listener who says no still gets their book.
  Future<bool> ensureGranted();

  /// Whether the player may show itself, without asking for anything. Null
  /// where the platform has no such notion to report on.
  Future<bool?> isGranted();

  /// Opens the system's own notification settings for this app, which is the
  /// only way back once a listener has said no.
  Future<void> openSettings();
}

@LazySingleton(as: PlaybackNotificationPermission)
class DevicePlaybackNotificationPermission
    implements PlaybackNotificationPermission {
  /// Answered by the activity, which is the only thing that can raise the
  /// system's own permission sheet.
  static const MethodChannel _channel = MethodChannel(
    'audiobooks/playback_notification',
  );

  bool? _answer;

  @override
  Future<bool?> isGranted() async {
    try {
      return await _channel.invokeMethod<bool>('isGranted');
    } on MissingPluginException {
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> openSettings() async {
    try {
      await _channel.invokeMethod<void>('openSettings');
    } catch (_) {
      // Nothing to open, or nothing that would take it. The listener can still
      // reach the same place through the system's own settings.
    }
  }

  @override
  Future<bool> ensureGranted() async {
    // Android shows its sheet once and remembers the answer, so asking again
    // in the same sitting would be a silent no rather than a second chance.
    final settled = _answer;
    if (settled != null) return settled;

    try {
      return _answer = await _channel.invokeMethod<bool>('ensureGranted') ??
          true;
    } on MissingPluginException {
      // A platform with nothing to ask: iOS and macOS grant the media session
      // without a prompt.
      return _answer = true;
    } catch (_) {
      // An activity that cannot be asked is not a reason to hold up a book.
      // The next book asks again rather than assuming the worst forever.
      return false;
    }
  }
}
