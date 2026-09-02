import 'package:audiobooks/core/shelf/shelf_folder_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('audiobooks/shelf_folder');
  const subject = ShelfFolderChannel();
  final calls = <MethodCall>[];

  void answerWith(Object? Function(MethodCall call) reply) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return reply(call);
        });
  }

  setUp(calls.clear);

  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );

  test('reads back the folder and the token that reopens it', () async {
    answerWith(
      (_) => {
        'path': '/Users/reader/Library/Shelf',
        'bookmark': Uint8List.fromList(const [1, 2, 3]),
      },
    );

    final grant = await subject.choose();

    expect(grant, isNotNull);
    expect(grant!.path, '/Users/reader/Library/Shelf');
    expect(grant.bookmark, Uint8List.fromList(const [1, 2, 3]));
    expect(calls.single.method, 'choose');
  });

  test('a dismissed picker is nothing chosen', () async {
    answerWith((_) => null);

    expect(await subject.choose(), isNull);
  });

  test('hands the stored token over to reopen a folder', () async {
    answerWith(
      (_) => {
        'path': '/Users/reader/Library/Shelf',
        'bookmark': Uint8List.fromList(const [9]),
      },
    );

    final grant = await subject.resolve(Uint8List.fromList(const [1, 2, 3]));

    expect(calls.single.method, 'resolve');
    expect(
      (calls.single.arguments as Map)['bookmark'],
      Uint8List.fromList(const [1, 2, 3]),
    );
    // The system reissues a token when the folder has moved, and that is the
    // one worth keeping.
    expect(grant!.bookmark, Uint8List.fromList(const [9]));
  });

  test('a folder the system will not reopen is nothing', () async {
    answerWith((_) => null);

    expect(await subject.resolve(Uint8List.fromList(const [1])), isNull);
  });

  group('a reply that makes no sense is nothing chosen', () {
    for (final reply in <Map<String, Object?>>[
      {'path': '/somewhere'},
      {
        'bookmark': <int>[1],
      },
      {
        'path': '',
        'bookmark': <int>[1],
      },
      {'path': '/somewhere', 'bookmark': <int>[]},
    ]) {
      test('$reply', () async {
        answerWith(
          (_) => {
            ...reply,
            if (reply['bookmark'] case final List<Object?> bytes)
              'bookmark': Uint8List.fromList(bytes.cast<int>()),
          },
        );

        expect(await subject.choose(), isNull);
      });
    }
  });

  test('letting go of a folder says so natively', () async {
    answerWith((_) => null);

    await subject.release();

    expect(calls.single.method, 'release');
  });
}
