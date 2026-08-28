# Player surface

- Mode: Operate. Scope: active local audiobook playback on compact and expanded
  windows.
- Audience and job: listeners need to understand what is playing, move through
  time and chapters, and control playback without losing focus on the book.
- Primary action: play or pause. Secondary actions: seek, change speed, and
  choose a chapter.
- Chosen direction: click-wheel era; the cover is the material anchor, the
  recessed readout carries the measurements, and the wheel carries the
  transport.
- Component grammar: bevelled chrome and recessed glass over flat semantic
  surfaces; a painted wheel face with ordinary buttons laid over it; platform
  sliders and menus; no enclosing player card.
- Type ramp: chapter and author support the book title; every measured quantity
  is set in the platform monospace readout face so digits sit still as they
  tick.
- Responsive rule: compact windows stack cover, readout, and wheel so all three
  reach the first screen — the compact cover is 216 and the wheel no more than
  228. At 900 logical pixels the player restructures into a cover pane and a
  control/chapter pane inside a shared 1160-logical-pixel maximum width, where
  the cover is 360 and the wheel 244.
- Desktop input: Space toggles play/pause. Left and Right seek backward 15 and
  forward 30 seconds. Every pointer target retains keyboard focus semantics.
- Motion: playback state changes remain local to controls; no decorative page
  transition competes with listening.
- Accessibility rule: the wheel is a picture with real controls on top. Nothing
  on it may be painted-only — each key keeps its tooltip, its 48-logical-pixel
  target, its focus stop, and its semantics.
- Unresolved: final cover art, sleep timer, bookmarks, and system media-control
  presentation.

## Ingredient inventory

| Ingredient | Commitment | Medium |
| --- | --- | --- |
| Cover | 216×216 compact, 360×360 expanded, behind a 3px chrome bezel | Flutter image / semantic surface |
| Identity | Chapter menu row, book title, author in one tight hierarchy | Semantic Flutter text |
| Readout | One recessed pane: slider, chapter elapsed and remaining, book remaining | Material slider on a bevelled panel |
| Transport | A moulded wheel: -15 west, +30 east, previous and next chapter north and south, play/pause in the centre well | Painted face, Material icon and filled controls |
| Speed | Compact native menu behind a small chrome key | Material popup menu |
| Chapters | Ruled rows; the chapter playing is the blue selection bar | Material list tiles |
| macOS layout | Two balanced columns with keyboard shortcuts | Responsive Flutter layout |
