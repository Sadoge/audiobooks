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
- Chapters from either audiobook layout: markers embedded in a single M4B, and
  ordered files imported together as one book.
- A functional adaptive player with chapter navigation, whole-book progress,
  speed, keyboard shortcuts, and durable resume position.
- Resume that remembers the chapter and the minute, shown in the Library and
  restored when a book is reopened.
- Real covers: artwork is read out of MP3 ID3 tags and MP4 `covr` boxes, or
  taken from an image sitting beside the audio, and any book can be given one
  by hand at import or afterwards. Covers are squared and scaled when stored,
  so the Library, the grid, and the player all read as square artwork.
- Removing a book from the Library, which deletes the media copied for it.
- Unit, widget, repository, and golden tests.

Selecting several files offers to import them as one book with a chapter per
file, or as separate books. Books imported before covers were read pick up
their artwork the next time the Library opens. Metadata editing, book details,
sleep timers, bookmarks, and system media controls remain planned for later
milestones.

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
