import 'package:injectable/injectable.dart';

/// What became of the attempt to hand the player to the operating system.
enum MediaSessionOutcome {
  /// Not tried yet.
  pending,

  /// The system took it: the lock screen and the notification are ours to
  /// draw, permission allowing.
  started,

  /// A platform with no media session to speak of.
  unsupported,

  /// The system refused it. Whatever else is wrong, the player will not appear
  /// outside the app until this does.
  failed,
}

/// Remembers how startup went, so that a listener who finds no controls on
/// their lock screen can be told why rather than left guessing.
///
/// It is written once, as the app starts, and only read after that.
@lazySingleton
class MediaSessionStatus {
  MediaSessionOutcome outcome = MediaSessionOutcome.pending;

  /// What the system said, when it said no.
  String? error;

  void record(MediaSessionOutcome outcome, {String? error}) {
    this.outcome = outcome;
    this.error = error;
  }
}
