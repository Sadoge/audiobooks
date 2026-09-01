import 'package:audiobooks/core/audio/playback_notification_permission.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('audiobooks/playback_notification');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  var calls = 0;

  /// Stands in for the activity, answering as a device would.
  void answerWith(Object? Function() answer) {
    messenger.setMockMethodCallHandler(channel, (call) async {
      expect(call.method, 'ensureGranted');
      calls++;
      return answer();
    });
  }

  setUp(() => calls = 0);

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('asks the device once and keeps the answer', () async {
    answerWith(() => true);
    final permission = DevicePlaybackNotificationPermission();

    expect(await permission.ensureGranted(), isTrue);
    expect(await permission.ensureGranted(), isTrue);

    // Android shows its sheet once, so asking again would only ever be a
    // silent no.
    expect(calls, 1);
  });

  test('keeps a refusal too, rather than pestering', () async {
    answerWith(() => false);
    final permission = DevicePlaybackNotificationPermission();

    expect(await permission.ensureGranted(), isFalse);
    expect(await permission.ensureGranted(), isFalse);
    expect(calls, 1);
  });

  test('a platform with nothing to ask is a yes', () async {
    // iOS and macOS carry no handler for this channel: the media session is
    // theirs without a prompt.
    final permission = DevicePlaybackNotificationPermission();

    expect(await permission.ensureGranted(), isTrue);
  });

  test('an activity that fails to answer is asked again next time', () async {
    answerWith(() => throw PlatformException(code: 'no-activity'));
    final permission = DevicePlaybackNotificationPermission();

    expect(await permission.ensureGranted(), isFalse);

    answerWith(() => true);
    expect(await permission.ensureGranted(), isTrue);
  });
}
