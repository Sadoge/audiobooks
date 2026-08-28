---
name: Audiobooks
description: A quiet, adaptive listening room for device-owned audiobooks.
colors:
  slate-seed: "#515B83"
  primary-brass-light: "#6E530F"
  on-primary-light: "#FFFFFF"
  primary-brass-dark: "#E9C46A"
  on-primary-dark: "#352A00"
  secondary-slate-light: "#4B557B"
  secondary-slate-dark: "#BCC6F4"
  surface-paper-light: "#F8F9FC"
  surface-room-dark: "#111823"
  on-surface-ink-light: "#101828"
  on-surface-ink-dark: "#F1F3F8"
  surface-low-light: "#F1F3F8"
  surface-low-dark: "#171F2C"
  surface-highest-light: "#DDE1EA"
  surface-highest-dark: "#303A49"
  outline-soft-light: "#D7DAE2"
  outline-soft-dark: "#3B4554"
typography:
  display:
    fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: "36px"
    fontWeight: 600
    letterSpacing: "-1px"
  headline:
    fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: "25px"
    fontWeight: 600
    letterSpacing: "-0.4px"
  title:
    fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: "22px"
    fontWeight: 600
  body-large:
    fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: "17px"
    fontWeight: 400
    lineHeight: 1.45
  body:
    fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: "15px"
    fontWeight: 400
    lineHeight: 1.4
  label:
    fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif'
    fontSize: "16px"
    fontWeight: 600
rounded:
  cover: "12px"
  control: "14px"
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
    backgroundColor: "{colors.primary-brass-light}"
    textColor: "{colors.on-primary-light}"
    typography: "{typography.label}"
    rounded: "{rounded.control}"
    padding: "16px 24px"
    height: "54px"
  filled-button-dark:
    backgroundColor: "{colors.primary-brass-dark}"
    textColor: "{colors.on-primary-dark}"
    typography: "{typography.label}"
    rounded: "{rounded.control}"
    padding: "16px 24px"
    height: "54px"
  icon-button:
    size: "48px"
    width: "48px"
    height: "48px"
  app-bar-light:
    backgroundColor: "{colors.surface-paper-light}"
    textColor: "{colors.on-surface-ink-light}"
    typography: "{typography.title}"
  app-bar-dark:
    backgroundColor: "{colors.surface-room-dark}"
    textColor: "{colors.on-surface-ink-dark}"
    typography: "{typography.title}"
  book-cover-placeholder:
    rounded: "{rounded.cover}"
    width: "48px"
    height: "64px"
  book-list-row:
    padding: "8px 12px"
    height: "80px"
  listening-doorway:
    width: "250px"
    height: "280px"
  player-cover-compact:
    rounded: "{rounded.cover}"
    width: "240px"
    height: "320px"
  player-cover-expanded:
    rounded: "{rounded.cover}"
    width: "320px"
    height: "430px"
  player-play-dark:
    backgroundColor: "{colors.primary-brass-dark}"
    textColor: "{colors.on-primary-dark}"
    width: "64px"
    height: "64px"
---

# Design System: Audiobooks

## Overview

**Creative North Star: "The Quiet Listening Room"**

The interface should feel like entering a calm room made for listening: cool semantic surfaces create stillness, tall slate planes suggest an open doorway, and one restrained brass marker signals the listening action. The system is premium and understated without becoming precious; book covers and user content are allowed to carry the personality while the surrounding interface recedes.

The visual language uses flat tonal layering, generous negative space, comfortable reading rhythm, and adaptive native behavior. Material 3 roles structure Android presentation, iOS navigation and transitions retain familiar platform behavior, and macOS restructures content for resizable pointer-and-keyboard windows. Expression belongs in the palette, measured geometry, and the signature listening marker—not in decorative gradients, excessive cards, or custom controls that compete with native expectations.

**Key Characteristics:**

- Cool semantic surfaces in coordinated light and dark appearances.
- One scarce brass accent for the primary listening marker and action.
- Platform system typography with a calm, compact hierarchy.
- Flat tonal layering, restrained corners, and no decorative shadow vocabulary.
- Native navigation, controls, touch targets, and reduced-motion behavior.

## Colors

The palette pairs cool paper and blue-charcoal surfaces with slate structure and a single warm brass voice.

### Primary

- **Deep Listening Brass — Light** (`primary-brass-light`): Primary actions and the listening marker on light surfaces.
- **Lit Listening Brass — Dark** (`primary-brass-dark`): The same scarce action and marker role in dark appearance.
- **Primary Contrast** (`on-primary-light`, `on-primary-dark`): Text and icons placed directly on their corresponding brass fills.

### Secondary

- **Quiet Slate — Light** (`secondary-slate-light`): The cool supporting chroma used by the generated Material scheme.
- **Moonlit Slate — Dark** (`secondary-slate-dark`): The dark-appearance counterpart for secondary semantic roles.
- **Slate Seed** (`slate-seed`): The fidelity seed from which unoverridden Material color roles are generated.

### Neutral

- **Cool Paper** (`surface-paper-light`): The light scaffold and app-bar ground.
- **Blue-Charcoal Room** (`surface-room-dark`): The dark scaffold and app-bar ground.
- **Listening Ink** (`on-surface-ink-light`, `on-surface-ink-dark`): High-emphasis content on the corresponding surface.
- **Low Tonal Layer** (`surface-low-light`, `surface-low-dark`): Quiet separation for lower-emphasis grouped surfaces.
- **Doorway Plane** (`surface-highest-light`, `surface-highest-dark`): The strongest neutral plane, including the signature empty-state geometry.
- **Soft Outline** (`outline-soft-light`, `outline-soft-dark`): One-pixel dividers and edges that clarify without becoming decoration.

### Named Rules

**The One Brass Voice Rule.** Brass belongs to the primary listening marker and primary action; its rarity is what makes it legible.

## Typography

**Display Font:** Platform system UI

**Body Font:** Platform system UI

**Character:** The native system face keeps the product trustworthy and adaptive. Weight, spacing, and line height create the premium reading rhythm instead of introducing a decorative brand font.

### Hierarchy

- **Display** (`display`): Large top-level moments that need confident presence without theatrical scale.
- **Headline** (`headline`): Empty-state titles and task-leading messages.
- **Title** (`title`): App-bar titles and settings section headings.
- **Body Large** (`body-large`): Explanations and primary reading copy with the most comfortable line spacing.
- **Body** (`body`): Supporting information and denser metadata.
- **Label** (`label`): Filled-button labels and other prominent controls.

### Named Rules

**The Reading Rhythm Rule.** Preserve semantic type roles and text scaling; never shrink or tighten copy merely to force a preferred composition.

## Layout

The system uses a compact seven-step spacing scale and generous outer breathing room. Top-level library content sits below a conventional app bar in the top safe area; task pages use the same standard app-bar pattern, safe areas, and straightforward vertical flows. Library rows use 16 logical pixels of horizontal page inset, while focused empty and import states use 24 logical pixels.

The empty-library composition remains centered within a maximum content width of 460 logical pixels and keeps a practical minimum vertical canvas of 520 logical pixels. Settings switches from a segmented control to stacked 56-logical-pixel list choices below 360 logical pixels or when text scaling exceeds 1.3. On windows at least 720 logical pixels wide, the Library becomes a measured cover grid. At 900 logical pixels, the player restructures into a cover pane and a listening-controls pane, capped together at 1160 logical pixels. Wider devices preserve readable content widths instead of stretching the composition edge to edge.

Touch targets are at least 48 logical pixels in the implemented theme. Safe areas, scroll behavior, text scaling, iOS back transitions, Android predictive back, macOS pointer focus, and keyboard traversal remain platform-owned. Space toggles playback and the arrow keys seek on the desktop player.

## Elevation & Depth

The system has no decorative shadow vocabulary. Depth comes from semantic surface tones, one-pixel soft outlines, content hierarchy, and whitespace; app bars stay flat while content scrolls beneath them.

### Named Rules

**The Flat-by-Default Rule.** Separate layers with tonal roles and spacing; do not add drop shadows to cards, app bars, doorway planes, or controls.

## Shapes

Controls use gently rounded 14-logical-pixel corners, while audiobook cover placeholders use a slightly tighter 12-logical-pixel radius. Most layout remains unboxed: lists, empty states, and settings groups sit directly on the scaffold rather than inside enclosing cards. The signature doorway uses two tall, slightly irregular open planes and a circular marker, creating a recognizable silhouette without decorative framing.

## Components

### Buttons

- **Shape:** Gently rounded controls with the shared `control` radius and a minimum height of 54 logical pixels.
- **Primary:** Brass fill with its paired high-contrast foreground, `label` typography, 24-logical-pixel horizontal padding, and 16-logical-pixel vertical padding.
- **States:** Material handles hover, press, focus, and disabled overlays; busy import actions replace the leading icon with a compact progress indicator and disable repeated activation.
- **Tonal / Text:** Tonal buttons support recovery actions; text buttons support subordinate changes such as choosing different files.

### Cards / Containers

- **Corner Style:** Avoid generic card containers. The implemented cover placeholder is the compact exception and uses the `cover` radius.
- **Background:** Semantic surface-container roles provide tonal distinction.
- **Shadow Strategy:** No shadows; use the flat depth model above.
- **Border:** Soft one-pixel outlines only when a boundary needs clarification.
- **Internal Padding:** Use the spacing scale; library rows use 12 logical pixels horizontally and 8 logical pixels vertically.

### Navigation

The top-level Library uses a conventional fixed native app bar inside the top safe area, with a `title`-style label and one 48-logical-pixel Settings icon action. Import and Settings use the same standard app-bar pattern and the platform navigation stack. Android predictive back and Cupertino transitions remain intact; the app does not introduce custom global navigation.

### Book List Row

Library entries are flat native list tiles with an 80-logical-pixel minimum height, a 48-by-64 cover placeholder, a two-line ellipsized title, and author metadata. The list tile owns its accessibility semantics without an additional wrapper. Real cover art may replace the placeholder without changing the row rhythm.

### Listening Doorway

The 250-by-280 logical-pixel empty-state mark pairs two surface-highest planes with soft outline edges and one primary-colored circular marker. The marker settles upward over the standard motion duration with emphasized easing, and resolves immediately when animations or accessible navigation are disabled.

### Appearance Choice

Settings uses a native Material segmented control for System, Light, and Dark at comfortable widths. It becomes a semantic stacked list with checkmark selection at narrow widths or elevated text scale, preserving legibility and touch targets.

### Desktop Book Grid

At expanded widths, books use a flat grid with a maximum 220-logical-pixel tile extent and 24-logical-pixel gutters. The cover plane owns most of each tile; title and author sit below without a surrounding card. The entire tile is pointer, keyboard, and screen-reader actionable.

### Player

The compact player stacks cover, identity, progress, transport, speed, and chapters. On macOS and other expanded windows it becomes a balanced two-column listening room: a 320-by-430 cover plane on the left and a readable control/chapter column on the right. The warm brass voice is reserved for progress, the play action, and the active chapter. Rewind and forward labels must exactly match their 15- and 30-second behavior.

## Do's and Don'ts

### Do:

- **Do** use semantic Material color roles so light and dark appearances remain coordinated.
- **Do** reserve brass for the primary listening marker, primary action, and necessary interactive emphasis.
- **Do** keep content flows native, scrollable, safe-area aware, and resilient to text scaling.
- **Do** use the spacing, radius, type, touch-target, and motion tokens already defined in the Flutter theme.
- **Do** disable the listening-marker motion when reduced motion or accessible navigation is requested.

### Don't:

- **Don't** add decorative gradients, glass effects, arbitrary accent colors, or drop shadows.
- **Don't** wrap empty states, settings groups, or list rows in generic cards.
- **Don't** replace platform navigation, back behavior, segmented controls, list tiles, or progress indicators with web-shaped imitations.
- **Don't** fabricate cover art, catalog content, a logo, or a final product name.
- **Don't** stretch centered reading content across tablet widths or compress it to preserve a fixed phone composition.
