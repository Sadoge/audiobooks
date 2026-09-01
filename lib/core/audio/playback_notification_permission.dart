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
