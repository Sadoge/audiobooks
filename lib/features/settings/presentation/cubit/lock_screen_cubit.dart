import 'package:audiobooks/core/audio/media_session_status.dart';
import 'package:audiobooks/core/audio/playback_notification_permission.dart';
import 'package:audiobooks/features/settings/presentation/cubit/lock_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

/// Says whether the book will appear on the lock screen, and what to do when
/// it will not.
///
/// Playing a book and showing it are two different things, and when the second
/// one fails the first still works perfectly — which leaves a listener with no
/// way to tell a permission they declined from something genuinely broken.
/// This is that way.
@injectable
class LockScreenCubit extends Cubit<LockScreenState> {
  LockScreenCubit(this._session, this._permission)
    : super(const LockScreenState());

  final MediaSessionStatus _session;
  final PlaybackNotificationPermission _permission;

  Future<void> check() async {
    if (_session.outcome == MediaSessionOutcome.failed) {
      emit(
        LockScreenState(
          status: LockScreenStatus.unavailable,
          errorMessage: _session.error,
        ),
      );
      return;
    }
    if (_session.outcome == MediaSessionOutcome.unsupported) {
      emit(const LockScreenState(status: LockScreenStatus.unavailable));
      return;
    }

    // Null is a platform that does not gate its notifications, which is a yes.
    final allowed = await _permission.isGranted() ?? true;
    if (isClosed) return;
    emit(
      LockScreenState(
        status: allowed
            ? LockScreenStatus.working
            : LockScreenStatus.notPermitted,
      ),
    );
  }

  /// The system's own notification settings, which is the only place a
  /// declined permission can be given back.
  Future<void> openSettings() => _permission.openSettings();
}
