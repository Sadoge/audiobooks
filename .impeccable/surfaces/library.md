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
- Unresolved: final product name and future real cover-art content.

## Ingredient inventory

| Ingredient | Commitment | Medium |
| --- | --- | --- |
| App bar | Conventional compact `Library` title in the top safe area, one Settings action | Semantic Flutter widgets |
| Empty geometry | Two tall planes and one listening marker | CustomPainter / Flutter shapes |
| Empty message | Headline plus concise local-only explanation | Semantic Flutter text |
| Primary action | Full-width accessible filled control | Material filled button |
| Dark mode | Same topology, deep blue-charcoal surfaces | Theme color roles |
| macOS library | Flat cover grid with pointer and keyboard affordances | Responsive Flutter slivers |
