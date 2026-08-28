# Audiobooks

An offline-first Flutter audiobook player for audio files you already own.

![Library empty state](.impeccable/screenshots/library-title-fixed.png)

## Current milestone

The foundation release includes:

- A polished adaptive Library with light and dark themes on iOS, Android, and
  macOS.
- Native file selection for MP3, M4A, M4B, and AAC files.
- Durable, app-owned local media storage.
- A Drift database for books, chapters, progress, and bookmarks.
- Feature-first architecture with Cubit, repositories, dependency injection,
  and typed routing.
- A functional adaptive player with progress, chapter navigation, speed,
  keyboard shortcuts, and durable resume position.
- Unit, widget, repository, and golden tests.

Each selected file is currently imported as a separate audiobook. Metadata
editing, multi-file book grouping, book details, sleep timers, bookmarks, and
system media controls remain planned for later milestones.

## Development

Flutter 3.44.7 is pinned through FVM.

```sh
fvm flutter pub get
fvm flutter analyze
fvm flutter test
fvm flutter run
```

The iOS target requires iOS 14 or newer.

The macOS app uses a sandboxed native file picker and adapts from a compact
single-column layout to desktop Library grids and a two-column listening view.

## Project documentation

- [`PRODUCT.md`](PRODUCT.md) describes product principles and scope.
- [`DESIGN.md`](DESIGN.md) documents the visual system and reusable tokens.
- [`.impeccable/surfaces/library.md`](.impeccable/surfaces/library.md) records
  the approved Library composition contract.
