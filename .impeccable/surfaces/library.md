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
