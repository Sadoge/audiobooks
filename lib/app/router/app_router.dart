import 'package:audiobooks/features/import/presentation/pages/import_page.dart';
import 'package:audiobooks/features/library/presentation/pages/library_page.dart';
import 'package:audiobooks/features/player/presentation/pages/player_page.dart';
import 'package:audiobooks/features/settings/presentation/pages/settings_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart' show Key;
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@lazySingleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LibraryRoute.page, initial: true),
    AutoRoute(page: ImportRoute.page),
    AutoRoute(page: PlayerRoute.page, path: '/player/:bookId'),
    AutoRoute(page: SettingsRoute.page),
  ];
}
