# Design System Document: Aura Cinema - The Cinematic Editorial

## 1. Overview & Creative North Star
**North Star: "Digital Curator"**

Editorial experience, not database. High-end gallery for cinematic art.

**Intentional Asymmetry + Fluid Depth**: 24dp corner radii, "No-Line" philosophy. Interface as breathing canvas. Breathing room over density. Every poster/title as exhibition.

---

## 2. Colors & Surface Philosophy

Deep Violet palette. Material tonal tiers for depth.

### Theme Variations

#### Dark Mode (Default)
- **Background:** #0F0E13
- **Surface/Cards:** #1B1A23
- **Primary Text:** #F5F5F5
- **Secondary Text:** #938F99
- **Primary Action:** #7C4DFF
- **Accent/Selection:** #E1D5FF

#### Light Mode
- **Background:** #FAFAFA
- **Surface/Cards:** #FFFFFF
- **Primary Text:** #1A1A1A
- **Secondary Text:** #666666
- **Primary Action:** #7C4DFF
- **Accent/Selection:** #E1D5FF

### "No-Line" Rule
No 1px solid borders. Use:
1. **Background Shifting**: `surface-container-low` on `background`.
2. **Vertical Rhythm**: Whitespace for sections.
3. **Tonal Transitions**: Gradients to guide eye.

### Surface Hierarchy & Nesting
UI as "frosted violet glass" layers.
- **Layer 0 (Base):** `background`
- **Layer 1 (Sectioning):** `surface-container-low`
- **Layer 2 (Interaction):** `surface-container(-high)`
- **Layer 3 (Floating):** `surface-bright`

### "Glass & Gradient" Rule
**Glassmorphism** for nav bars/headers. `surface` colors @ 70-80% opacity, 20-40px backdrop blur.
Linear gradient `primary` (#cdbdff) to `primary-container` (#7c4dff). 135° angle for hero CTAs. "Lit-from-within" glow.

---

## 3. Typography

Dual-sans pairing. Authority + modern voice.

- **Display/Headlines (Manrope):** Geometric precision, tech-premium. `display-lg` to `headline-sm`.
- **Body/Labels (Inter):** Legibility at small scales. `title-md` for metadata, `body-md` for synopses.

**Brand Identity Hierarchy**: High-contrast weight usage. `headline-lg` (Bold) + `label-md` (Medium) subtitle in `secondary-fixed-dim`. Tiered architecture.

---

## 4. Elevation & Depth

**Tonal Layering** over structural lines.

### Layering Principle
Stacking surface tiers. `surface-container-lowest` in `surface-container-high` = inset. Lifted effect vice versa.

### Ambient Shadows
Last resort for floating effects.
- **Blur:** 32-64px.
- **Opacity:** 4-8% (Dark) / 8-12% (Light).
- **Color:** Tinted shadow (`primary-fixed-variant`).

### "Ghost Border" Fallback
Accessibility fix: `outline-variant` @ 15% opacity. 100% opaque borders forbidden.

---

## 5. Components

### Buttons
- **Primary:** `primary-container` background, `on-primary-container` text. 24dp radius. `cubic-bezier(0.4, 0, 0.2, 1)` transitions.
- **Secondary:** `surface-container-high`, `primary` text. No border.
- **Tertiary:** Ghost style. No background, `primary` text.

### Cards & Lists
- **No-Divider Rule**: No 1px dividers. 8px vertical space or surface shift.
- **Media Cards**: `xl` (24dp) roundedness. Inset shadow on poster art.

### Chips
- **Filter Chips**: `secondary-container`, `on-secondary-container` text. Active = `primary` + soft glow.

### Specialized (Tracker)
- **Progress Ring**: Dual-tone gradient stroke (`primary` to `secondary`) on `surface-variant`.
- **Episode Stack**: Overlapping layers, 24dp corners. Visual stack, less labels.

---

## 6. Do's and Don'ts

### Do
- Asymmetrical spacing. Editorial feel.
- Backdrop blurs on sticky headers.
- `tertiary` (#ffb688) sparingly as star/highlight.

### Don't
- Pure black/white for surfaces.
- Standard "drop shadows" with 0 blur.
- 1px borders. Shift background instead.
- Crowd screen. Use 16dp extra whitespace.