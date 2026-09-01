import 'package:audiobooks/app/theme/app_theme.dart';
import 'package:audiobooks/core/files/device_file_gateway.dart';
import 'package:audiobooks/features/library/domain/entities/audiobook.dart';
import 'package:audiobooks/features/library/domain/repositories/audiobook_repository.dart';
import 'package:audiobooks/features/settings/domain/entities/app_theme_preference.dart';
import 'package:audiobooks/features/settings/domain/entities/playback_settings.dart';
import 'package:audiobooks/features/settings/domain/repositories/appearance_repository.dart';
import 'package:audiobooks/features/settings/domain/repositories/playback_settings_repository.dart';
import 'package:audiobooks/features/settings/presentation/cubit/playback_settings_cubit.dart';
import 'package:audiobooks/features/settings/presentation/cubit/storage_summary_cubit.dart';
import 'package:audiobooks/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:audiobooks/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAudiobookRepository extends Mock implements AudiobookRepository {}

class _MockDeviceFileGateway extends Mock implements DeviceFileGateway {}

void main() {
  late _FakePlaybackSettingsRepository playback;
  late _MockAudiobookRepository audiobooks;
  late _MockDeviceFileGateway files;

  final book = Audiobook(
    id: 'book-1',
    title: 'The Quiet Listening Room',
    author: 'Local Audiobooks',
    dateAdded: DateTime(2026),
    fileType: AudioFileType.m4b,
  );

  setUp(() {
    playback = _FakePlaybackSettingsRepository();
    audiobooks = _MockAudiobookRepository();
    files = _MockDeviceFileGateway();
    when(() => audiobooks.watchAll()).thenAnswer((_) => Stream.value([book]));
    when(() => files.storedMediaBytes()).thenAnswer((_) async => 4194304);
  });

  Future<void> pumpSettings(
    WidgetTester tester, {
    Size size = const Size(430, 1600),
    double textScale = 1,
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        builder: (context, child) => MediaQuery.withClampedTextScaling(
          minScaleFactor: textScale,
          maxScaleFactor: textScale,
          child: child!,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ThemeCubit(_FakeAppearanceRepository())..load(),
            ),
            BlocProvider(
              create: (_) => PlaybackSettingsCubit(playback)..load(),
            ),
            BlocProvider(
              create: (_) => StorageSummaryCubit(audiobooks, files)..measure(),
            ),
          ],
          child: const SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('titles every panel the settings screen carries', (tester) async {
    await pumpSettings(tester);

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Playback'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('states where each playback default stands', (tester) async {
    playback.stored = const PlaybackSettings(
      speed: 1.25,
      rewindInterval: Duration(seconds: 15),
      forwardInterval: Duration(seconds: 30),
    );

    await pumpSettings(tester);

    expect(find.text('Speed'), findsOneWidget);
    expect(find.text('1.25x'), findsOneWidget);
    expect(find.text('15s'), findsOneWidget);
    expect(find.text('30s'), findsOneWidget);
    // The interval that does nothing says so in words rather than in zeroes.
    expect(find.text('Off'), findsOneWidget);
  });

  testWidgets('choosing an interval stores it and shows it', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.text('Rewind key'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(PopupMenuItem<Duration>, '30s'));
    await tester.pumpAndSettle();

    expect(playback.stored.rewindInterval, const Duration(seconds: 30));
    expect(find.text('15s'), findsNothing);
  });

  testWidgets('holds its rows together at large text sizes', (tester) async {
    await pumpSettings(tester, size: const Size(320, 3000), textScale: 2);

    // The appearance control stacks rather than squeezing three segments in.
    expect(find.byType(SegmentedButton<AppThemePreference>), findsNothing);
    expect(find.text('Speed'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reports what the library takes on this device', (tester) async {
    await pumpSettings(tester);

    expect(find.text('Storage used'), findsOneWidget);
    expect(find.text('4.0 MB'), findsOneWidget);
    expect(
      find.textContaining('1 audiobook is copied into this app'),
      findsOneWidget,
    );
  });
}

class _FakePlaybackSettingsRepository implements PlaybackSettingsRepository {
  PlaybackSettings stored = const PlaybackSettings();

  @override
  Future<PlaybackSettings> loadPlaybackSettings() async => stored;

  @override
  Future<void> savePlaybackSettings(PlaybackSettings settings) async =>
      stored = settings;
}

class _FakeAppearanceRepository implements AppearanceRepository {
  AppThemePreference preference = AppThemePreference.system;

  @override
  Future<AppThemePreference> loadThemePreference() async => preference;

  @override
  Future<void> saveThemePreference(AppThemePreference preference) async =>
      this.preference = preference;
}
