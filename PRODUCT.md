# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

## Stack

Flutter and Dart, targeting iOS and Android with platform-appropriate navigation,
system media controls, accessibility, file access, and background playback.

## Users

People who already own audiobook or long-form audio files on their phone or in a
device-accessible document provider and want a calm, dependable listening app
that works without an account or network connection.

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

Users import MP3, M4A, M4B, or AAC files through iOS and Android document
providers. They browse a local library, resume recent listening, move through
chapters, adjust speed, set sleep timers, create bookmarks, and use lock-screen
or notification playback controls. Sessions often happen while the app is
backgrounded, the device is locked, or audio routes change.

## Capabilities and Constraints

- Version one is entirely offline: no backend, authentication, sync, streaming,
  external catalog, purchases, or recommendations.
- Imported media must be accessed durably without loading full files into
  memory; copying is used only where platform file access cannot be retained.
- The local model supports both one-file books and ordered multi-file chapters.
- Playback, file, persistence, and repository boundaries must remain replaceable
  so future remote services do not require presentation rewrites.
- Metadata failure must not block otherwise playable audio.
- Inaccessible, moved, deleted, corrupt, or unsupported files produce a useful
  recovery state instead of a crash.
- Embedded M4B chapters are an explicitly deferred capability until reliable
  cross-platform extraction is verified.

## Brand Commitments

The product is premium, understated, minimal, elegant, calm, and modern. Book
covers carry most of the visual personality. Interfaces use generous whitespace,
neutral surfaces, subtle contrast, restrained shape, and purposeful motion.
Avoid clutter, excessive cards, arbitrary color, decorative gradients, and
navigation destinations that do not earn their place.

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
