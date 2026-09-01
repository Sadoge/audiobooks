import 'package:audiobooks/core/audio/media_session_status.dart';
import 'package:audiobooks/core/audio/playback_notification_permission.dart';
import 'package:audiobooks/features/settings/presentation/cubit/lock_screen_cubit.dart';
import 'package:audiobooks/features/settings/presentation/cubit/lock_screen_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePermission implements PlaybackNotificationPermission {
  _FakePermission(this._granted);

  final bool? _granted;
  int opened = 0;

  @override
  Future<bool> ensureGranted() async => _granted ?? true;

  @override
  Future<bool?> isGranted() async => _granted;

  @override
  Future<void> openSettings() async => opened++;
}

void main() {
  MediaSessionStatus statusOf(MediaSessionOutcome outcome, {String? error}) =>
      MediaSessionStatus()..record(outcome, error: error);

  test('reports the controls working when the system took the player', () async {
    final cubit = LockScreenCubit(
      statusOf(MediaSessionOutcome.started),
      _FakePermission(true),
    );
    addTearDown(cubit.close);

    await cubit.check();

    expect(cubit.state.status, LockScreenStatus.working);
  });

  test('names a declined notification for what it is', () async {
    final cubit = LockScreenCubit(
      statusOf(MediaSessionOutcome.started),
      _FakePermission(false),
    );
    addTearDown(cubit.close);

    await cubit.check();

    // The book still plays; it just cannot show itself, which is the
    // listener's to change and so worth saying plainly.
    expect(cubit.state.status, LockScreenStatus.notPermitted);
  });

  test('carries the reason through when the session never started', () async {
    final cubit = LockScreenCubit(
      statusOf(MediaSessionOutcome.failed, error: 'wrong FlutterEngine'),
      _FakePermission(true),
    );
    addTearDown(cubit.close);

    await cubit.check();

    expect(cubit.state.status, LockScreenStatus.unavailable);
    expect(cubit.state.errorMessage, 'wrong FlutterEngine');
  });

  test('a platform with no media session says so without blaming anyone', () async {
    final cubit = LockScreenCubit(
      statusOf(MediaSessionOutcome.unsupported),
      _FakePermission(null),
    );
    addTearDown(cubit.close);

    await cubit.check();

    expect(cubit.state.status, LockScreenStatus.unavailable);
    expect(cubit.state.errorMessage, isNull);
  });

  test('a platform that does not gate notifications is a yes', () async {
    final cubit = LockScreenCubit(
      statusOf(MediaSessionOutcome.started),
      _FakePermission(null),
    );
    addTearDown(cubit.close);

    await cubit.check();

    expect(cubit.state.status, LockScreenStatus.working);
  });

  test('sends a blocked listener to the one place that can fix it', () async {
    final permission = _FakePermission(false);
    final cubit = LockScreenCubit(
      statusOf(MediaSessionOutcome.started),
      permission,
    );
    addTearDown(cubit.close);

    await cubit.openSettings();

    expect(permission.opened, 1);
  });
}
