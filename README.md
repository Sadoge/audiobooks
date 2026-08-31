# Audiobooks

An offline-first Flutter audiobook player for audio files you already own,
dressed as a personal player from the early 2000s: warm cream and graphite
housings, an amber-backlit readout, and a click wheel.

## Current milestone

The foundation release includes:

- A polished adaptive Library with light and dark themes on iOS, Android, and
  macOS, styled after a personal player from the early 2000s: a brushed chrome
  housing, hairline-ruled menu rows, a recessed readout, and a click wheel for
  the transport.
- Native file selection for MP3, M4A, M4B, and AAC files.
- Durable, app-owned local media storage.
- A Drift database for books, chapters, progress, and bookmarks.
- Feature-first architecture with Cubit, repositories, dependency injection,
  and typed routing.
- Chapters from either audiobook layout: markers embedded in a single M4B, and
  ordered files imported together as one book.
- A functional adaptive player with chapter navigation, whole-book progress,
  speed, keyboard shortcuts, and durable resume position. The wheel is a
  painted face with ordinary buttons laid over it, so every control keeps its
  tooltip, focus stop, touch target, and screen-reader semantics.
- Resume that remembers the chapter and the minute, shown in the Library and
  restored when a book is reopened.
- Real covers: artwork is read out of MP3 ID3 tags and MP4 `covr` boxes, or
  taken from an image sitting beside the audio, and any book can be given one
  by hand at import or afterwards. Covers are squared and scaled when stored,
  so the Library, the grid, and the player all read as square artwork.
- Removing a book from the Library, which deletes the media copied for it.
- Importing more books at any time: the Library housing bar carries the import
  key whether the library is empty or full.
- Settings that reach the player: the speed every book opens at, what the
  wheel's rewind and forward keys step by, and how far back a resumed book
  picks up. The panel also reports how much of the device the imported audio
  takes, and lists the licences the bundled fonts and packages ship under.
- Unit, widget, repository, and golden tests.

Selecting several files offers to import them as one book with a chapter per
file, or as separate books. Books imported before covers were read pick up
their artwork the next time the Library opens. Metadata editing, book details,
sleep timers, bookmarks, and system media controls remain planned for later
milestones.

## Type

The product is set in Space Grotesk, with Space Mono for every readout. Both
are bundled under the SIL Open Font License 1.1; the licences ship beside the
files in `assets/fonts/`. Space Grotesk is instanced from its upstream variable
font at weights 400 and 700 so bold text is a real weight rather than a
synthesised one.

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
- [`.impeccable/surfaces/player.md`](.impeccable/surfaces/player.md) records the
  same for the Player.

The captures under `.impeccable/screenshots/` predate the click-wheel pass and
need recapturing from a running app.
