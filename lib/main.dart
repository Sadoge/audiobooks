import 'package:audiobooks/app/app.dart';
import 'package:audiobooks/app/di/configure_dependencies.dart';
import 'package:audiobooks/app/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The bundled faces and the licence each one ships under.
const _bundledFontLicenses = <String, String>{
  'Space Grotesk': 'assets/fonts/SpaceGrotesk-OFL.txt',
  'Space Mono': 'assets/fonts/SpaceMono-OFL.txt',
};

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _registerFontLicenses();
  await configureDependencies();
  runApp(AudiobooksApp(router: getIt<AppRouter>()));
}

/// The Open Font License asks that it travel with the fonts, so the bundled
/// faces declare themselves on the app's own licence page.
void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final entry in _bundledFontLicenses.entries) {
      yield LicenseEntryWithLineBreaks(<String>[
        entry.key,
      ], await rootBundle.loadString(entry.value));
    }
  });
}
