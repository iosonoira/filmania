# Design System Document: Aura Cinema - The Cinematic Editorial

## 1. Overview & Creative North Star
**Creative North Star: "The Digital Curator"**

This design system moves away from the utilitarian "database" feel of traditional trackers and toward a high-end editorial experience. We are not just listing data; we are curating a gallery of cinematic art.

To achieve this, we break the "template" look through **Intentional Asymmetry** and **Fluid Depth**. By leveraging extreme corner radii (24dp) and a "No-Line" philosophy, the interface feels less like software and more like a continuous, breathing canvas. We prioritize breathing room over information density, ensuring every movie poster and title feels like a featured exhibition.

---

## 2. Colors & Surface Philosophy

The palette is anchored in a sophisticated Deep Violet, utilizing Material-inspired tonal tiers to create depth without visual noise across two core theme variations.

### Theme Variations

#### Dark Mode (Default)
- **Background:** #0F0E13 (Deep Midnight)
- **Surface/Cards:** #1B1A23
- **Primary Text:** #F5F5F5
- **Secondary Text:** #938F99
- **Primary Action:** #7C4DFF (Deep Violet)
- **Accent/Selection:** #E1D5FF (Soft Lavender)

#### Light Mode
- **Background:** #FAFAFA
- **Surface/Cards:** #FFFFFF
- **Primary Text:** #1A1A1A
- **Secondary Text:** #666666
- **Primary Action:** #7C4DFF (Deep Violet)
- **Accent/Selection:** #E1D5FF (Soft Lavender)

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to section content. Boundaries must be defined solely through:
1. **Background Shifting:** A `surface-container-low` card sitting on a `background` surface.
2. **Vertical Rhythm:** Generous whitespace to denote new sections.
3. **Tonal Transitions:** Using subtle gradients to guide the eye.

### Surface Hierarchy & Nesting
Treat the UI as physical layers of "frosted violet glass."
- **Layer 0 (Base):** `background` for the app canvas.
- **Layer 1 (Sectioning):** `surface-container-low` for large content groupings.
- **Layer 2 (Interaction):** `surface-container` or `surface-container-high` for interactive cards and buttons.
- **Layer 3 (Floating):** `surface-bright` for modals and tooltips.

### The "Glass & Gradient" Rule
To elevate the experience, use **Glassmorphism** for navigation bars and overlay headers. Apply `surface` colors at 70-80% opacity with a `20px to 40px` backdrop blur.
*Signature Texture:* Use a subtle linear gradient from `primary` (#cdbdff) to `primary-container` (#7c4dff) at a 135-degree angle for hero CTAs to provide a "lit-from-within" glow.

---

## 3. Typography

The system utilizes a dual-sans-serif pairing to establish an authoritative yet modern editorial voice.

- **Display & Headlines (Manrope):** Chosen for its geometric precision and modern "tech-premium" feel. Use `display-lg` through `headline-sm` for titles and hero sections.
- **Body & Labels (Inter):** Chosen for its world-class legibility at small scales. Use `title-md` for metadata and `body-md` for synopses.

**Hierarchy as Brand Identity:**
Always lean into high-contrast weight usage. Pair a `headline-lg` (Bold) title with a `label-md` (Medium) subtitle in `secondary-fixed-dim` to create a sophisticated, tiered information architecture.

---

## 4. Elevation & Depth

We convey importance through **Tonal Layering** rather than structural lines.

### The Layering Principle
Depth is achieved by "stacking" surface tiers. Place a `surface-container-lowest` element inside a `surface-container-high` container to create an "inset" look, or vice versa for a "lifted" look.

### Ambient Shadows
Shadows are a last resort. When a "floating" effect is required (e.g., a floating action button):
- **Blur:** 32px to 64px.
- **Opacity:** 4% - 8% (Dark Mode) / 8% - 12% (Light Mode).
- **Color:** Use a tinted shadow (`primary-fixed-variant`) instead of pure black to mimic the violet ambient light of the environment.

### The "Ghost Border" Fallback
If a border is required for accessibility, it must be a **Ghost Border**: Use `outline-variant` at **15% opacity**. 100% opaque borders are strictly forbidden.

---

## 5. Components

### Buttons
- **Primary:** `primary-container` background with `on-primary-container` text. 24dp radius. Transitions should use a `cubic-bezier(0.4, 0, 0.2, 1)` curve for fluid expansion.
- **Secondary:** `surface-container-high` with `primary` text. No border.
- **Tertiary:** Ghost style. No background; `primary` text only.

### Cards & Lists
- **The "No-Divider" Rule:** Forbid 1px dividers. Separate list items using `8px` of vertical space or a subtle change from `surface-container-low` to `surface-container-lowest`.
- **Media Cards:** Use the `xl` (3rem/24dp) roundedness. Apply a subtle inner shadow (inset) to poster art to make it feel embedded in the UI.

### Chips
- **Filter Chips:** Use `secondary-container` with `on-secondary-container` text. When active, transition to `primary` with a soft outer glow (4% spread).

### Specialized Components (Tracker Context)
- **Progress Ring:** For "Episode Progress," use a dual-tone gradient stroke (`primary` to `secondary`) against a `surface-variant` track.
- **Episode Stack:** Use overlapping `surface` layers with 24dp corners to visually represent a "stack" of content, reducing the need for explicit "Season" labels.

---

## 6. Do's and Don'ts

### Do
- **Do** use asymmetrical spacing (e.g., more top padding than bottom) to create an editorial, "un-templated" feel.
- **Do** use backdrop blurs on sticky headers so movie posters bleed through as the user scrolls.
- **Do** use `tertiary` (#ffb688) sparingly as a "star" or "highlight" color to break the violet monotony.

### Don't
- **Don't** use pure black (#000000) or pure white (#FFFFFF) for surfaces. Stick to the defined `background` and `surface` tokens to maintain tonal depth.
- **Don't** use standard "drop shadows" with 0 blur. This breaks the "fluidity" requirement.
- **Don't** use 1px borders. If you feel you need one, try a background color shift first.
- **Don't** crowd the screen. If in doubt, add 16dp of extra whitespace.