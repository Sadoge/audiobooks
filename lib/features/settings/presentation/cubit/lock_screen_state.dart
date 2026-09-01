import 'package:freezed_annotation/freezed_annotation.dart';

part 'lock_screen_state.freezed.dart';

/// Whether the player can show itself outside the app, and if not, why not.
enum LockScreenStatus {
  checking,

  /// The system has the player: lock screen and notification alike.
  working,

  /// The session is running but the listener has not allowed the notification
  /// the controls are drawn in, which is theirs to change.
  notPermitted,

  /// The session never started. Nothing the listener does will bring the
  /// controls back, so this one says what went wrong instead.
  unavailable,
}

@freezed
abstract class LockScreenState with _$LockScreenState {
  const factory LockScreenState({
    @Default(LockScreenStatus.checking) LockScreenStatus status,

    /// What the system said, when the session could not be started.
    String? errorMessage,
  }) = _LockScreenState;
}
