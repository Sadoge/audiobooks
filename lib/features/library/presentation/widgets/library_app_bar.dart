import 'package:audiobooks/app/widgets/retro_widgets.dart';
import 'package:flutter/material.dart';

/// The housing bar over the library.
///
/// Importing is how the library grows, so it stays a key on the housing
/// whatever is loaded: the empty state offers it as the one full-width
/// action, and a library with books in it still has it here.
class LibraryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LibraryAppBar({
    required this.onImport,
    required this.onSettings,
    super.key,
  });

  final VoidCallback onImport;
  final VoidCallback onSettings;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ChromeAppBar(
      title: const Text('Library'),
      actions: [
        IconButton(
          tooltip: 'Import audiobooks',
          onPressed: onImport,
          icon: const Icon(Icons.add_rounded),
        ),
        IconButton(
          tooltip: 'Settings',
          onPressed: onSettings,
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
