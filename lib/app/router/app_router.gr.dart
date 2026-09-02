// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ImportPage]
class ImportRoute extends PageRouteInfo<void> {
  const ImportRoute({List<PageRouteInfo>? children})
    : super(ImportRoute.name, initialChildren: children);

  static const String name = 'ImportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ImportPage());
    },
  );
}

/// generated route for
/// [LibraryPage]
class LibraryRoute extends PageRouteInfo<void> {
  const LibraryRoute({List<PageRouteInfo>? children})
    : super(LibraryRoute.name, initialChildren: children);

  static const String name = 'LibraryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LibraryPage();
    },
  );
}

/// generated route for
/// [PlayerPage]
class PlayerRoute extends PageRouteInfo<PlayerRouteArgs> {
  PlayerRoute({required String bookId, Key? key, List<PageRouteInfo>? children})
    : super(
        PlayerRoute.name,
        args: PlayerRouteArgs(bookId: bookId, key: key),
        rawPathParams: {'bookId': bookId},
        initialChildren: children,
      );

  static const String name = 'PlayerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PlayerRouteArgs>(
        orElse: () => PlayerRouteArgs(bookId: pathParams.getString('bookId')),
      );
      return PlayerPage(bookId: args.bookId, key: args.key);
    },
  );
}

class PlayerRouteArgs {
  const PlayerRouteArgs({required this.bookId, this.key});

  final String bookId;

  final Key? key;

  @override
  String toString() {
    return 'PlayerRouteArgs{bookId: $bookId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlayerRouteArgs) return false;
    return bookId == other.bookId && key == other.key;
  }

  @override
  int get hashCode => bookId.hashCode ^ key.hashCode;
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const SettingsPage());
    },
  );
}

/// generated route for
/// [ShelfPage]
class ShelfRoute extends PageRouteInfo<void> {
  const ShelfRoute({List<PageRouteInfo>? children})
    : super(ShelfRoute.name, initialChildren: children);

  static const String name = 'ShelfRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return WrappedRoute(child: const ShelfPage());
    },
  );
}
