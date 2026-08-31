---
name: Audiobooks
description: A device-shaped listening room for audiobooks you already own.
colors:
  device-seed: "#B4680F"
  primary-amber-light: "#A8580A"
  on-primary-light: "#FFFFFF"
  primary-amber-dark: "#F0A93B"
  on-primary-dark: "#2A1A00"
  secondary-clay-light: "#7A6A52"
  secondary-clay-dark: "#C0B39C"
  surface-screen-light: "#FCFAF4"
  surface-screen-dark: "#17140F"
  on-surface-ink-light: "#211E17"
  on-surface-ink-dark: "#F3EEE1"
  surface-low-light: "#F4F0E5"
  surface-low-dark: "#1E1A14"
  surface-highest-light: "#DDD4BF"
  surface-highest-dark: "#332D23"
  outline-hairline-light: "#D0C6AF"
  outline-hairline-dark: "#423B2E"
  chrome-edge-light: "#AD9F82"
  chrome-edge-dark: "#0E0C08"
  chrome-highlight-light: "#FFFFFF"
  chrome-highlight-dark: "#837860"
  readout-fill-light: "#DCD4BD"
  readout-fill-dark: "#120F08"
  readout-ink-light: "#2B2415"
  readout-ink-dark: "#FFBE55"
  selection-ink-light: "#FFFFFF"
  selection-ink-dark: "#2A1A00"
typography:
  display:
    fontFamily: 'SpaceGrotesk, system-ui, -apple-system, sans-serif'
    fontSize: "34px"
    fontWeight: 700
    letterSpacing: "-0.8px"
  headline:
    fontFamily: 'SpaceGrotesk, system-ui, -apple-system, sans-serif'
    fontSize: "24px"
    fontWeight: 700
    letterSpacing: "-0.3px"
  title:
    fontFamily: 'SpaceGrotesk, system-ui, -apple-system, sans-serif'
    fontSize: "19px"
    fontWeight: 700
    letterSpacing: "0.1px"
  body-large:
    fontFamily: 'SpaceGrotesk, system-ui, -apple-system, sans-serif'
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.4
  body:
    fontFamily: 'SpaceGrotesk, system-ui, -apple-system, sans-serif'
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.35
  label:
    fontFamily: 'SpaceGrotesk, system-ui, -apple-system, sans-serif'
    fontSize: "15px"
    fontWeight: 700
    letterSpacing: "0.3px"
  readout:
    fontFamily: 'SpaceMono, ui-monospace, Menlo, 'Courier New', monospace'
    fontSize: "14px"
    fontWeight: 400
    letterSpacing: "0px"
rounded:
  cover: "3px"
  screen: "5px"
  control: "6px"
spacing:
  xxs: "4px"
  xs: "8px"
  sm: "12px"
  md: "16px"
  lg: "24px"
  xl: "32px"
  xxl: "48px"
components:
  filled-button-light:
    backgroundColor: "{colors.primary-amber-light}"
    textColor: "{colors.on-primary-light}"
    typography: "{typography.label}"
    rounded: "{rounded.control}"
    padding: "12px 24px"
    height: "50px"
  filled-button-dark:
    backgroundColor: "{colors.primary-amber-dark}"
    textColor: "{colors.on-primary-dark}"
    typography: "{typography.label}"
    rounded: "{rounded.control}"
    padding: "12px 24px"
    height: "50px"
  icon-button:
    size: "48px"
    width: "48px"
    height: "48px"
  app-bar-light:
    backgroundColor: "{colors.surface-screen-light}"
    textColor: "{colors.on-surface-ink-light}"
    typography: "{typography.title}"
    borderColor: "{colors.chrome-edge-light}"
  app-bar-dark:
    backgroundColor: "{colors.surface-screen-dark}"
    textColor: "{colors.on-surface-ink-dark}"
    typography: "{typography.title}"
    borderColor: "{colors.chrome-edge-dark}"
  chrome-bezel:
    rounded: "{rounded.cover}"
    borderWidth: "1px"
    padding: "3px"
  readout-light:
    backgroundColor: "{colors.readout-fill-light}"
    textColor: "{colors.readout-ink-light}"
    typography: "{typography.readout}"
    rounded: "{rounded.screen}"
    borderWidth: "1px"
  readout-dark:
    backgroundColor: "{colors.readout-fill-dark}"
    textColor: "{colors.readout-ink-dark}"
    typography: "{typography.readout}"
    rounded: "{rounded.screen}"
    borderWidth: "1px"
  book-cover-placeholder:
    rounded: "{rounded.cover}"
    width: "56px"
    height: "56px"
  book-list-row:
    padding: "8px 16px"
    height: "80px"
  pocket-player-mark:
    width: "250px"
    height: "280px"
  click-wheel:
    width: "244px"
    height: "244px"
  click-wheel-centre:
    backgroundColor: "{colors.primary-amber-light}"
    width: "88px"
    height: "88px"
  player-cover-compact:
    rounded: "{rounded.cover}"
    width: "216px"
    height: "216px"
  player-cover-expanded:
    rounded: "{rounded.cover}"
    width: "360px"
    height: "360px"
---

# Design System: Audiobooks

## Overview

**Creative North Star: "The Click-Wheel Era"**

The interface should feel like a well-made personal player from the early
2000s: a brushed housing, a screen recessed behind a bezel, printed keys on a
moulded wheel, and one amber that marks the row you are on. The product is the
same calm, offline listening room it always was; what changed is that the room
now has the shape of a device you could hold.

The visual language uses drawn bevels instead of blur, hairline rules instead
of cards, monospaced digits for anything that counts, and tight corners
everywhere. Material 3 roles still structure Android presentation, iOS
navigation and transitions retain familiar platform behavior, and macOS
restructures content for resizable pointer-and-keyboard windows. The period
belongs to the surfaces, the geometry, and the wheel — never to the behavior:
every control underneath is a stock platform control with its own tooltip,
focus, touch target, and semantics.

**Key Characteristics:**

- Brushed chrome housing over a plain screen, in coordinated light and dark.
- One amber for the primary action, the marked row, and the bar of progress.
- Space Grotesk for reading, Space Mono for readouts; both bundled.
- Bevelled hairline edges; tight 3-6 logical-pixel corners; no drop shadows.
- Native navigation, controls, touch targets, and reduced-motion behavior.

## Colors

The palette pairs a warm cream or graphite housing with a bone screen and a
single period amber, lifted from the backlight of a display of that decade.

### Primary

- **Burnt Amber — Light** (`primary-amber-light`): Primary actions, the marked
  row, and progress on light surfaces.
- **Lit Amber — Dark** (`primary-amber-dark`): The same roles in the dark
  appearance.
- **Primary Contrast** (`on-primary-light`, `on-primary-dark`): Text and icons
  placed directly on their corresponding amber fills. Light amber carries
  white; lit amber is bright enough that it takes the dark warm ink instead.

### Secondary

- **Clay** (`secondary-clay-light`, `secondary-clay-dark`): The supporting warm
  neutral chroma used by the generated Material scheme.
- **Device Seed** (`device-seed`): The fidelity seed from which unoverridden
  Material color roles are generated.

### Neutral

- **Screen** (`surface-screen-light`, `surface-screen-dark`): The bone or
  near-black ground the content sits on, behind the housing bar.
- **Listening Ink** (`on-surface-ink-light`, `on-surface-ink-dark`):
  High-emphasis content on the corresponding surface.
- **Low Tonal Layer** (`surface-low-light`, `surface-low-dark`): Quiet
  separation for lower-emphasis grouped surfaces.
- **Moulding** (`surface-highest-light`, `surface-highest-dark`): The strongest
  neutral plane, including the cover placeholder.
- **Hairline** (`outline-hairline-light`, `outline-hairline-dark`): The
  one-pixel rules that separate rows and group settings.

### Chrome and Readout

- **Chrome Edge** (`chrome-edge-light`, `chrome-edge-dark`): The dark hairline
  where a moulded edge turns away from the light.
- **Chrome Highlight** (`chrome-highlight-light`, `chrome-highlight-dark`): The
  lit hairline along the top of that same edge.
- **Readout Glass** (`readout-fill-light`, `readout-fill-dark`): The recessed
  display behind the scrubber and the counters.
- **Readout Ink** (`readout-ink-light`, `readout-ink-dark`): The digits on it —
  dark warm ink on light, amber backlight on dark.
- **Selection Ink** (`selection-ink-light`, `selection-ink-dark`): What reads on
  the marked row, which is white on the light bar and dark warm ink on the lit
  one.

### Named Rules

**The One Amber Voice Rule.** Amber belongs to the primary action, the row
being played, and the bar of progress; its rarity is what makes it legible.

**The Bevel, Not Blur Rule.** Depth is a dark hairline and a lit hairline, or a
two-stop gradient across a moulded face. It is never a drop shadow.

## Typography

**Display Font:** Space Grotesk (bundled, SIL OFL 1.1)

**Body Font:** Space Grotesk

**Readout Font:** Space Mono (bundled, SIL OFL 1.1)

**Character:** Both faces are bundled rather than borrowed from the platform,
because the period is carried as much by the lettering as by the housing. Space
Grotesk is a squarish grotesque that reads as moulded product lettering, set
heavier and tighter than a document would be. Anything that counts — run times,
remaining time, chapter numbers, speeds, file sizes — is set in Space Mono so
digits sit still as they tick. Grotesk is instanced from its upstream variable
font at 400 and 700, so bold weights are real rather than synthesised, and both
licences ship beside the files in `assets/fonts/`.

### Hierarchy

- **Display** (`display`): Large top-level moments that need confident presence.
- **Headline** (`headline`): Empty-state titles and the book being played.
- **Title** (`title`): Housing-bar titles and settings section headings.
- **Body Large** (`body-large`): Explanations and primary reading copy.
- **Body** (`body`): Supporting information and denser metadata.
- **Label** (`label`): Filled-button labels and other prominent controls.
- **Readout** (`readout`): Every counter, duration, and measured quantity.

### Named Rules

**The Reading Rhythm Rule.** Preserve semantic type roles and text scaling;
never shrink or tighten copy merely to force a preferred composition.

**The Digits Sit Still Rule.** A number that changes while you watch it is set
in the readout face, so the line beside it never reflows.

## Layout

The system uses a compact seven-step spacing scale and generous outer breathing
room. Top-level library content sits below a brushed housing bar in the top
safe area, titled in the centre; task pages use the same bar, safe areas, and
straightforward vertical flows. The compact library carries its 16-logical-pixel
inset inside each row so the hairline rules span the full width, the way a menu
of rows did. Focused empty and import states use 24 logical pixels.

The empty-library composition remains centered within a maximum content width
of 460 logical pixels and keeps a practical minimum vertical canvas of 520
logical pixels. Settings switches from a segmented control to stacked
56-logical-pixel list choices below 360 logical pixels or when text scaling
exceeds 1.3. On windows at least 720 logical pixels wide, the Library becomes a
measured cover grid. At 900 logical pixels, the player restructures into a cover
pane and a listening-controls pane, capped together at 1160 logical pixels. The
compact player keeps its cover at 216 and its wheel at no more than 228 so the
cover, the readout, and the whole wheel reach the first screen together.

Touch targets are at least 48 logical pixels in the implemented theme. Safe
areas, scroll behavior, text scaling, iOS back transitions, Android predictive
back, macOS pointer focus, and keyboard traversal remain platform-owned. Space
toggles playback and the arrow keys seek on the desktop player.

## Elevation & Depth

The system has no shadow vocabulary. Depth comes from drawn bevels — a chrome
edge, a chrome highlight, and a two-stop face gradient — plus semantic surface
tones, hairline rules, content hierarchy, and whitespace. Housing bars stay flat
while content scrolls beneath them.

### Named Rules

**The Flat-Behind-the-Bevel Rule.** Separate layers with bevels, tonal roles,
and spacing; do not add drop shadows to rows, housing bars, readouts, or
controls.

## Shapes

Controls use 6-logical-pixel corners, the recessed readout uses 5, and artwork
uses 3 behind a 3-logical-pixel bezel drawn inside the plane so the artwork
keeps its measured size. Most layout remains unboxed: lists, empty states, and
settings groups sit directly on the screen, separated by hairlines rather than
enclosed in cards. The wheel is the one circle in the system, and the play key
at its centre is the one circular control.

## Components

### Buttons

- **Shape:** 6-logical-pixel corners with a minimum height of 50 logical pixels.
- **Primary:** Amber fill with its paired high-contrast foreground, `label`
  typography, 24-logical-pixel horizontal padding, and 12 vertical.
- **States:** Material handles hover, press, focus, and disabled overlays; busy
  import actions replace the leading icon with a compact progress indicator and
  disable repeated activation.
- **Chrome key:** Secondary controls that belong on the device rather than in
  the content — the speed selector — sit on a moulded key face with a chrome
  edge.
- **Tonal / Text:** Tonal buttons support recovery actions; text buttons support
  subordinate changes such as choosing different files.

### Cards / Containers

- **Corner Style:** Avoid generic card containers. The bezel and the readout are
  the two exceptions, and both are structural rather than decorative.
- **Background:** Semantic surface-container roles provide tonal distinction.
- **Shadow Strategy:** No shadows; use the bevel depth model above.
- **Border:** Hairline rules between rows, and around any recessed plane.
- **Internal Padding:** Use the spacing scale; library rows use 16 logical
  pixels horizontally and 8 vertically.

### Navigation

The top-level Library uses a brushed housing bar inside the top safe area:
a two-stop chrome gradient, a chrome-edge hairline along the bottom, a centered
`title`-style label, and one 48-logical-pixel Settings icon action. Import and
Settings use the same bar and the platform navigation stack. Android predictive
back and Cupertino transitions remain intact; the app does not introduce custom
global navigation.

### Book List Row

Library entries are flat native list tiles with an 80-logical-pixel minimum
height, a 56-by-56 square cover behind a 2-logical-pixel bezel, a two-line
ellipsized title, and author metadata. Rows are separated by hairline rules that
span the full width, and each is marked with the small arrow that leads into it.
The list tile owns its accessibility semantics without an additional wrapper.
Covers are square: artwork is centre-cropped to a square when it is stored, and
drawn cropped to fill rather than distorted if it was not.

### Pocket Player Mark

The 250-by-280 logical-pixel empty-state mark draws a moulded housing with a
blank recessed screen and a wheel: a library with nothing loaded on it. The
centre key lights and settles over the standard motion duration with emphasized
easing, and resolves immediately when animations or accessible navigation are
disabled.

### Readout

The player's scrubber and its counters sit together on one recessed pane: a
readout-glass fill, a hairline rim, the chapter position on the left, the
chapter remaining on the right, and what is left of the whole book between them.
Every figure on it is set in the readout face. The scrubber is a stock slider
with a rounded groove and a round knob.

### Click Wheel

The player's transport is a 244-logical-pixel moulded wheel, shrinking to no
less than 200 on narrow windows. Rewind 15 sits at west and forward 30 at east;
previous and next chapter appear at north and south only on a book that has
chapters; play and pause is the circular key in the centre well. The face is
painted, but every key on it is an ordinary button laid over the paint, so
tooltips, focus order, 48-logical-pixel touch targets, and screen-reader
semantics stay the platform's. Rewind and forward labels must exactly match
their 15- and 30-second behavior.

### Appearance Choice

Settings uses a native Material segmented control for System, Light, and Dark
at comfortable widths, squared to the control radius with a chrome edge. It
becomes a semantic stacked list with checkmark selection at narrow widths or
elevated text scale, preserving legibility and touch targets. Section headings
are ruled underneath.

### Desktop Book Grid

At expanded widths, books use a flat grid with a maximum 220-logical-pixel tile
extent and 24-logical-pixel gutters. The square cover plane sits behind a bezel
and owns most of each tile, taking the largest square the tile can spare so it
stays square as text scaling grows the lines below; title and author sit below
without a surrounding card. The entire tile is pointer, keyboard, and
screen-reader actionable.

### Chapter Sheet

Chapters are a menu of ruled rows. The chapter playing now is the amber bar —
a two-stop amber fill carrying the selection ink and a level glyph — the way the
row you were on was marked on the devices these controls came from. Every other row
carries its number in the readout face on the left and its length on the right.

### Player

The compact player stacks cover, identity, readout, wheel, and speed, sized so
all of them reach the first screen without scrolling. On macOS and other
expanded windows it becomes a balanced two-column listening room: a 360-by-360
square cover plane on the left and a readable control column on the right. The
chapter heading is a ruled menu row that leads into the chapter sheet.

## Do's and Don'ts

### Do:

- **Do** use semantic Material color roles so light and dark appearances remain
  coordinated.
- **Do** reserve amber for the primary action, the marked row, and progress.
- **Do** take the ink on the marked row from the palette rather than assuming
  white: the lit amber of dark appearance will not carry it.
- **Do** set every counted quantity in the readout face.
- **Do** keep content flows native, scrollable, safe-area aware, and resilient
  to text scaling.
- **Do** draw period surfaces with bevels and gradients, and leave the control
  underneath a stock platform control.
- **Do** disable the empty-state motion when reduced motion or accessible
  navigation is requested.

### Don't:

- **Don't** add drop shadows, glass effects, or arbitrary accent colors.
- **Don't** paint a control that a real button could be laid over instead.
- **Don't** wrap empty states, settings groups, or list rows in generic cards.
- **Don't** replace platform navigation, back behavior, segmented controls, list
  tiles, sliders, or progress indicators with web-shaped imitations.
- **Don't** fabricate cover art, catalog content, a logo, or a final product
  name, and don't imitate the branding of any device the period recalls.
- **Don't** stretch centered reading content across tablet widths or compress it
  to preserve a fixed phone composition.
