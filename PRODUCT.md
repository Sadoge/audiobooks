# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

## Stack

Flutter and Dart, targeting iOS, Android, and macOS with platform-appropriate
navigation, accessibility, durable file access, and background-capable playback.

## Users

People who already own audiobook or long-form audio files on their phone or Mac,
or in a device-accessible document provider, and want a calm, dependable
listening app that works without an account or network connection.

## Product Purpose

The app imports, organizes, and plays device-owned audiobooks entirely offline.
Success means a user can import a single file or ordered group of chapter files,
begin listening quickly, continue in the background, and reliably resume from
the last position after relaunching.

## Positioning

An offline-first personal audiobook library whose organizing and playback
experience is as considered as a streaming app, while keeping the user's files
and listening data on the device.

## Operating Context

Users import MP3, M4A, M4B, or AAC files through native document pickers. On
phones they listen one-handed or while the app is backgrounded; on macOS they
browse in a resizable window, use a keyboard and pointer, and often listen while
working in another application. They resume listening, move through chapters,
adjust speed, set sleep timers, create bookmarks, and use system media controls.

## Capabilities and Constraints

- Version one is entirely offline: no backend, authentication, streaming,
  purchases, or recommendations. A library can be shared between a listener's
  own devices through a folder they already own and already sync — iCloud
  Drive, Dropbox, Syncthing — which the app reads and writes as ordinary
  files. That is a shelf, not sync: there is no server, no account, and no
  shared mutable state, so nothing is ever merged and no listening position
  travels. The catalog is the listener's own folder, never an external one.
- Imported media must be accessed durably without loading full files into
  memory; copying is used only where platform file access cannot be retained.
- The local model supports both one-file books and ordered multi-file chapters.
- Playback, file, persistence, and repository boundaries must remain replaceable
  so future remote services do not require presentation rewrites.
- Metadata failure must not block otherwise playable audio.
- Inaccessible, moved, deleted, corrupt, or unsupported files produce a useful
  recovery state instead of a crash.
- Embedded M4B chapters are read in Dart from the MP4 container itself, in both
  the Nero and QuickTime layouts, so extraction behaves the same on every
  platform. A file whose markers cannot be read still plays as one chapterless
  book.
- Cover art is read in Dart from ID3 and MP4 tags, or from an image beside the
  audio, and can be replaced by one the listener chooses at any time. A book
  without artwork still imports and plays.
- Covers are square, as published audiobooks are: artwork that arrives in
  another shape is centre-cropped and scaled once when it is stored, and
  artwork that cannot be decoded is drawn cropped to the same square.
- A book can be removed from the library, taking the media copied for it and
  its listening state with it, and only after the listener confirms.
- Playback belongs to the device, not to a screen. A book keeps playing with
  the app in the background and the phone locked, and the same transport is
  offered wherever the platform offers one: the lock screen, the notification
  shade, a headset button, a car head unit, a watch. A chapter is the media
  item the system shows, so system and in-app time agree.
- The device may take the audio away at any moment. A call or another player
  pauses the book and returns it where it was; a headphone jack pulled or a
  Bluetooth device out of range pauses it and never resumes, so a book is
  never played aloud to a room that did not ask for it.
- Wherever a listener is in the app, they can tell what is playing and stop it
  without going back to the player.
- A shared folder shows only what this device has not got. A book already in
  the library never appears on the shelf, and downloading one writes into
  storage of its own, so nothing already on the device is ever written over.
  Publishing is the same courtesy in the other direction: a book another
  device already put in the folder is left exactly as it is.

## Brand Commitments

The product is premium, understated, minimal, elegant, and calm, and it wears
the dress of a well-made personal player from the early 2000s: a brushed
housing, a recessed screen, hairline-ruled menu rows, and a wheel. Book covers
carry most of the visual personality. Interfaces use generous whitespace,
neutral surfaces, subtle contrast, restrained shape, and purposeful motion.
Gradients are structural — they model a moulded edge or a lit face — and never
decorative. Avoid clutter, excessive cards, arbitrary color, drop shadows, and
navigation destinations that do not earn their place. The period is a finish,
never a behaviour: nothing may be painted where a real platform control could
be laid over it instead.

## Evidence on Hand

There is no final product name, logo, cover-art library, or external content in
the project. Future work must not fabricate commercial claims, catalog content,
or user-owned books. Empty-state artwork may be abstract and non-illustrative.

## Product Principles

- Listening state is durable and trustworthy.
- Device-native behavior outranks visual novelty.
- The cover, title, author, progress, controls, and chapters remain the focus.
- Architecture stays clean at service boundaries and pragmatic everywhere else.
- Offline limitations are explained honestly and recoverably.

## Accessibility & Inclusion

Support text scaling, screen readers, semantic state descriptions, platform
touch-target minimums, sufficient contrast, reduced-motion preferences, and
non-color-only communication in both light and dark themes.
