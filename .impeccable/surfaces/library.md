# Library surface

- Mode: Operate. Scope: the top-level library and its empty state.
- Audience and job: device-file audiobook listeners need to understand an empty
  local library and begin a native import flow immediately.
- Primary action: Import Audiobooks — the one full-width control on the empty
  state, and an icon key on the housing bar at every other time, so a library
  that already holds books can still grow. Secondary action: open Settings.
- Chosen direction: click-wheel era; the library is the menu on a personal
  player from the early 2000s.
- Memorable moment: a moulded pocket player with a blank recessed screen and a
  wheel, its centre key lighting as it settles — a library with nothing loaded
  on it yet.
- Component grammar: bevelled chrome housing over flat semantic surfaces, no
  enclosing card; tight 3-6px corners; hairline rules between rows instead of
  gaps; no drop shadows.
- Type ramp: Space Grotesk mapped to Material display, headline, body, and
  label roles, set heavier and tighter than running text; resume counters use
  the Space Mono readout face. The centred housing title orients, while the
  empty-state headline is the strongest content type on the screen.
- Responsive rule: composition stays centered and capped on phones, while its
  content width remains readable rather than stretching across tablets. The
  compact list carries its 16px inset inside each row so the rules span the
  full width; the grid keeps a 32px page inset. At 720 logical pixels and
  above, real books restructure into a measured cover grid rather than
  stretching phone list rows.
- Motion: the pocket player's centre key lights and settles into its well on
  first appearance; disabled entirely when accessible navigation/reduced motion
  is requested.
- Book covers: real artwork fills the square list thumbnail and the square
  grid tile, each behind a chrome bezel drawn inside the plane, with the title
  initial on a secondary-container plane standing in when a book has none.
  Artwork is squared when it is stored, so the grid reads as one even row of
  covers whatever shape the files carried. Per-book actions —
  add or change a cover, remove from the library — sit behind one quiet
  overflow control, over the corner of the artwork in the
  grid and after the play affordance in the list. Removal is confirmed in a
  dialog and reported in a snackbar over the library it changed.
- Now Playing bar: playback outlives the player page, so the Library carries a
  strip along the bottom of the housing whenever a book is loaded — the cover
  behind the same bezel at 40px, the title, the chapter (or the author on a
  book with none), the transport, and a counter. It sits under the list rather
  than over it, so nothing at the bottom of a long library is hidden behind it,
  and it takes no room at all when nothing is playing. Tapping the strip
  returns to that book's player; the keys work the transport without leaving
  the Library.
- Now Playing transport: a lit play or pause key with a quiet chapter key
  either side of it, so the primary action stays the loudest thing on the
  strip. The chapter keys appear only on a book divided into chapters, the same
  rule the player's wheel goes by. Everything else — scrubbing, the skip
  intervals, speed, the chapter list — stays on the player, which is one tap
  away.
- Now Playing counter: a second line running the full width of the strip —
  elapsed on the left, a 2px position line between, and time remaining on the
  right, all in the Space Mono readout face. It measures the chapter, as the
  player's own scrubber does, so the two never disagree. Until something knows
  how long the chapter runs, the line sits empty and the remaining time is
  withheld rather than guessed.
- Unresolved: final product name.

## Ingredient inventory

| Ingredient | Commitment | Medium |
| --- | --- | --- |
| Housing bar | Brushed chrome bar in the top safe area, centred `Library` title, an import action and a Settings action | Semantic Flutter widgets |
| Empty geometry | A moulded housing, a blank recessed screen, and a wheel | CustomPainter / Flutter shapes |
| Empty message | Headline plus concise local-only explanation | Semantic Flutter text |
| Primary action | Full-width accessible filled control | Material filled button |
| Dark mode | Same topology, graphite housing and a backlit screen | Theme color roles |
| macOS library | Flat cover grid with pointer and keyboard affordances | Responsive Flutter slivers |
| Book cover | Square artwork behind a chrome bezel, or the title initial on a quiet plane | Clipped image with letter fallback |
| Book actions | One overflow control per book: cover, removal | Material popup menu, confirm dialog |
| Now Playing bar | Bottom strip: 40px bezelled cover, title, chapter, tap to return | Semantic Flutter widgets over chrome tokens |
| Now Playing transport | Lit play/pause key, quiet previous/next chapter keys either side on a chaptered book | Material icon buttons |
| Now Playing counter | Full-width readout: elapsed, 2px position line, time remaining, in the mono face | Mono text and a determinate progress line |
