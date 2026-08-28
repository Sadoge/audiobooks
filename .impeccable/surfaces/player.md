# Player surface

- Mode: Operate. Scope: active local audiobook playback on compact and expanded
  windows.
- Audience and job: listeners need to understand what is playing, move through
  time and chapters, and control playback without losing focus on the book.
- Primary action: play or pause. Secondary actions: seek, change speed, and
  choose a chapter.
- Chosen direction: quiet listening room; the cover is the material anchor and
  the scarce brass voice identifies progress, play, and the active chapter.
- Component grammar: flat semantic surfaces, a circular primary transport
  action, platform sliders and menus, and no enclosing player card.
- Type ramp: chapter and author support the book title; elapsed and remaining
  time read as measurements without becoming display typography.
- Responsive rule: compact windows stack the experience; at 900 logical pixels
  the player restructures into a cover pane and a control/chapter pane inside a
  shared 1160-logical-pixel maximum width.
- Desktop input: Space toggles play/pause. Left and Right seek backward 15 and
  forward 30 seconds. Every pointer target retains keyboard focus semantics.
- Motion: playback state changes remain local to controls; no decorative page
  transition competes with listening.
- Unresolved: final cover art, sleep timer, bookmarks, and system media-control
  presentation.

## Ingredient inventory

| Ingredient | Commitment | Medium |
| --- | --- | --- |
| Cover | 240×320 compact, 320×430 expanded; real art or tonal placeholder | Flutter image / semantic surface |
| Identity | Chapter, book title, author in one tight hierarchy | Semantic Flutter text |
| Progress | Native slider, elapsed and remaining time | Material slider |
| Transport | Previous, -15, play/pause, +30, next | Material icon and filled controls |
| Speed | Compact native menu with persisted useful speeds | Material popup menu |
| Chapters | Flat selectable list; active chapter uses brass emphasis | Material list tiles |
| macOS layout | Two balanced columns with keyboard shortcuts | Responsive Flutter layout |
