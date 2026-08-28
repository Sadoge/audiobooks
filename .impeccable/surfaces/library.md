# Library surface

- Mode: Operate. Scope: the top-level library and its empty state.
- Audience and job: device-file audiobook listeners need to understand an empty
  local library and begin a native import flow immediately.
- Primary action: Import Audiobooks. Secondary action: open Settings.
- Chosen direction: quiet listening room; approved composition probe:
  `.impeccable/mocks/library-empty-doorway.png`.
- Memorable moment: two quiet vertical planes read as both an open doorway and
  paused playback, with a small warm listening marker between them.
- Component grammar: flat semantic surfaces, no enclosing card; restrained
  14px corners on filled actions; no decorative rules or drop shadows.
- Type ramp: platform system face mapped to Material display, headline, body,
  and label roles; the compact app-bar title orients, while the empty-state
  headline is the strongest content type on the screen.
- Responsive rule: composition stays centered and capped on phones, while its
  content width remains readable rather than stretching across tablets. At
  720 logical pixels and above, real books restructure into a measured cover
  grid rather than stretching phone list rows.
- Motion: the listening marker gently settles into place on first appearance;
  disabled entirely when accessible navigation/reduced motion is requested.
- Book covers: real artwork fills the square list thumbnail and the square
  grid tile, with the title initial on a secondary-container plane standing in
  when a book has none. Artwork is squared when it is stored, so the grid reads
  as one even row of covers whatever shape the files carried. Per-book actions — add or change a cover, remove from the library —
  sit behind one quiet overflow control, over the corner of the artwork in the
  grid and after the play affordance in the list. Removal is confirmed in a
  dialog and reported in a snackbar over the library it changed.
- Unresolved: final product name.

## Ingredient inventory

| Ingredient | Commitment | Medium |
| --- | --- | --- |
| App bar | Conventional compact `Library` title in the top safe area, one Settings action | Semantic Flutter widgets |
| Empty geometry | Two tall planes and one listening marker | CustomPainter / Flutter shapes |
| Empty message | Headline plus concise local-only explanation | Semantic Flutter text |
| Primary action | Full-width accessible filled control | Material filled button |
| Dark mode | Same topology, deep blue-charcoal surfaces | Theme color roles |
| macOS library | Flat cover grid with pointer and keyboard affordances | Responsive Flutter slivers |
| Book cover | Square artwork, or the title initial on a quiet plane | Clipped image with letter fallback |
| Book actions | One overflow control per book: cover, removal | Material popup menu, confirm dialog |
