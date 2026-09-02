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
- Background playback and system media controls. A book carries on with the app
  in the background and the phone locked, and appears on the lock screen and in
  the notification shade with its cover, its title, the chapter, and a
  transport: play and pause, rewind and forward by the intervals chosen in
  Settings, and previous and next chapter. Headset and Bluetooth buttons work
  the same transport — one press plays or pauses, two move on a chapter — and
  the chapter list is offered to a car head unit or a watch.
- Audio the device can take back. A call or another player pauses the book and
  hands it back where it was; unplugged headphones or a Bluetooth device out of
  range pause it and never resume, so the phone's own speaker never takes over.
- A Now Playing bar under the Library: the cover, the book, the chapter, play
  and pause with a chapter key either side of it, a counter running elapsed and
  remaining against a position line, and a tap back into the player. The
  chapter keys appear only on a book that has chapters, and the counter
  measures the chapter, as the player's own scrubber does.
- Unit, widget, repository, and golden tests.

- A shared library, for a collection kept on more than one device. Point the
  app at a folder your own sync service keeps in step — iCloud Drive, Dropbox,
  Syncthing — and the books in it appear under Shared Library, ready to bring
  across one at a time. It is a shelf rather than a sync: there is no server
  and no account, nothing merges, and your place in a book stays on the device
  you listened on. The shelf lists only what this device has not got, so a
  book already in the Library is never offered again, and a download writes
  into storage of its own — nothing already here is written over. Publishing
  a book into the folder leaves alone anything another device put there first.

Selecting several files offers to import them as one book with a chapter per
file, or as separate books. Books imported before covers were read pick up
their artwork the next time the Library opens. Metadata editing, book details,
sleep timers, and bookmarks remain planned for later milestones.

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

The iOS target requires iOS 14 or newer, and declares the `audio` background
mode. On Android the media session runs as a `mediaPlayback` foreground
service, which is what keeps a book playing with the screen off. From Android
13 that service's notification — and so the lock-screen controls, which are the
same notification — appears only once the listener has granted
`POST_NOTIFICATIONS`, which the app asks for the first time a book is opened.
Denying it leaves the book playing with no controls outside the app; it can be
granted afterwards in the system's notification settings for the app.

Changes to the Android manifest or to `MainActivity` need a full rebuild:
`flutter run` again rather than a hot restart. Whether the media session came
up at all is reported at startup under the `[audiobooks] media session:` tag,
and Settings › Playback › Lock screen controls says the same thing on the
device: `On` when the system has the player, `Blocked` when the notification
permission was declined (with a button through to the system settings that can
give it back), and `Off` with the reason when the session could not be
started.

The macOS app uses a sandboxed native file picker and adapts from a compact
single-column layout to desktop Library grids and a two-column listening view.
Reaching the shared folder needs two entitlements beyond the picker's own:
`files.user-selected.read-write`, without which a book cannot be published into
the folder, and `files.bookmarks.app-scope`, without which the folder is
forgotten at the next launch.

On Android the folder is chosen through the Storage Access Framework, and the
grant on it is taken persistently so it survives a reboot. A folder on the
device's own storage — which is what a service that syncs to a real directory,
such as Syncthing, gives you — is read directly. A folder belonging to a cloud
app's own document store has no path behind it; the app says so rather than
failing quietly, and asks for a different folder.

Holding onto a chosen folder across launches is not finished on iOS: the path
is remembered, but a proper security-scoped bookmark is not written yet, so a
folder the system stops resolving is reported as none chosen and has to be
picked again.

## Project documentation

- [`PRODUCT.md`](PRODUCT.md) describes product principles and scope.
- [`DESIGN.md`](DESIGN.md) documents the visual system and reusable tokens.
- [`.impeccable/surfaces/library.md`](.impeccable/surfaces/library.md) records
  the approved Library composition contract.
- [`.impeccable/surfaces/player.md`](.impeccable/surfaces/player.md) records the
  same for the Player.

The captures under `.impeccable/screenshots/` predate the click-wheel pass and
need recapturing from a running app.
