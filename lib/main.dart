import 'package:audiobooks/app/app.dart';
import 'package:audiobooks/app/di/configure_dependencies.dart';
import 'package:audiobooks/app/router/app_router.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(AudiobooksApp(router: getIt<AppRouter>()));
}
