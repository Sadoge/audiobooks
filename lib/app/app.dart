import 'package:audiobooks/app/di/configure_dependencies.dart';
import 'package:audiobooks/app/router/app_router.dart';
import 'package:audiobooks/app/theme/app_theme.dart';
import 'package:audiobooks/features/library/presentation/cubit/library_cubit.dart';
import 'package:audiobooks/features/player/presentation/cubit/now_playing_cubit.dart';
import 'package:audiobooks/features/settings/domain/entities/app_theme_preference.dart';
import 'package:audiobooks/features/settings/presentation/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudiobooksApp extends StatelessWidget {
  const AudiobooksApp({required this.router, super.key});

  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ThemeCubit>()..load()),
        BlocProvider(create: (_) => getIt<LibraryCubit>()..start()),
        // Playback outlives the player page, so what is playing is known above
        // every route rather than inside one.
        BlocProvider.value(value: getIt<NowPlayingCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, AppThemePreference>(
        builder: (context, preference) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Audiobooks',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: preference.themeMode,
            routerConfig: router.config(),
          );
        },
      ),
    );
  }
}
