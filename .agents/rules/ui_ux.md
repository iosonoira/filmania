# Rule: UI/UX — Violet Tracker

> **Agent Mandate**: You are a Senior Flutter Architect and UI Engineer. Every pixel rendered by
> Violet Tracker must be intentional, performant, and consistent with `DESIGN.md`. You do not
> hard-code design values. You do not skip animations. You do not ship janky UIs.

---

## Context

Violet Tracker's visual identity is **minimalist violet** — a refined, dark-first aesthetic built
around the primary brand colour `#7C4DFF`. All spacing, typography, and colour decisions are
codified in `DESIGN.md` at the project root. This file is the **single source of truth** for
visual decisions. No design token may be overridden inline without an explicit comment referencing
a `DESIGN.md` exception.

---

## Mandatory Guidelines

### 1. DESIGN.md is Law

- Before implementing any UI component, read the relevant section of `DESIGN.md`.
- All colours, spacing values, border radii, and typography styles **must** be consumed from
  `core/theme/` — never inlined.

```dart
// ✅ DO
Container(
  color: AppColors.primary,         // #7C4DFF — from DESIGN.md
  padding: AppSpacing.cardPadding,  // e.g. EdgeInsets.all(16)
  child: Text('Trending', style: AppTextStyles.headingMedium),
);

// ❌ DON'T
Container(
  color: const Color(0xFF7C4DFF),   // magic value — breaks design system
  padding: const EdgeInsets.all(16), // undocumented spacing
  child: Text('Trending', style: TextStyle(fontSize: 18)),
);
```

### 2. Colour System

Derived from `DESIGN.md` — expose via `AppColors`:

| Token | Value | Usage |
|---|---|---|
| `AppColors.primary` | `#7C4DFF` | CTAs, active states, accents |
| `AppColors.primaryLight` | `#B47CFF` | Hover / pressed on dark surfaces |
| `AppColors.primaryDark` | `#5C35CC` | Pressed state on light surfaces |
| `AppColors.surface` | Per theme | Card / sheet backgrounds |
| `AppColors.background` | Per theme | Scaffold background |
| `AppColors.onPrimary` | Per theme | Text/icons on primary-coloured surfaces |
| `AppColors.error` | `#CF6679` | Error states |

> All `AppColors` values must be sourced from `DESIGN.md`. If a value in this table conflicts
> with `DESIGN.md`, `DESIGN.md` wins.

### 3. Typography

- Use `AppTextStyles` — a `TextTheme` extension populated from `DESIGN.md`.
- **Never** instantiate raw `TextStyle(...)` outside of `core/theme/app_text_styles.dart`.
- Font family, weight, size, and letter-spacing are all defined in `DESIGN.md`.

### 4. Spacing System

- Use `AppSpacing` constants (multiples of a base unit defined in `DESIGN.md`).
- Spacing is never an arbitrary pixel value; it is always a named token.

```dart
// ✅
const SizedBox(height: AppSpacing.md);    // e.g. 16.0

// ❌
const SizedBox(height: 16);              // undocumented, fragile
```

### 5. Light / Dark Theme Switching

- `ThemeData` is generated via `AppTheme.light()` and `AppTheme.dark()` in `core/theme/`.
- Theme switching state is managed by a Riverpod provider (`themeModeProvider`).
- **Never** access `Theme.of(context)` to derive semantic colours — use `AppColors.of(context)`
  (a custom extension) which resolves the correct token for the active brightness.
- `MediaQuery` and `Theme` must be accessed at the **nearest** context to avoid unnecessary
  ancestor rebuilds.

```dart
// ✅ Semantic, theme-aware
final bg = AppColors.of(context).background;

// ❌ Hard-coded brightness check
final bg = Theme.of(context).brightness == Brightness.dark
    ? Colors.black
    : Colors.white;
```

### 6. Performance — `RepaintBoundary`

- Every component that animates independently (e.g., loading spinner, animated card, shimmer)
  **must** be wrapped in `RepaintBoundary`.
- Canvas-heavy custom painters **must** live inside a `RepaintBoundary`.
- Use `flutter run --profile` and the DevTools Repaint Rainbow to verify boundaries are correct
  before shipping any animated widget.

```dart
// ✅
RepaintBoundary(
  child: VioletPulseLoader(),
)
```

### 7. Scrollable Performance — Slivers

- All scrollable lists of dynamic length **must** use `SliverList` / `SliverGrid` (or
  `ListView.builder` / `GridView.builder` as minimum).
- Use `CustomScrollView` with slivers for any screen combining an app bar, a pinned header, and
  a list.
- **Never** use `ListView(children: [...])` or `Column` + `SingleChildScrollView` for lists of
  unbounded length.
- Apply `addAutomaticKeepAlives: false` and `addRepaintBoundaries: true` on `SliverList`
  where items do not need keep-alive.

```dart
// ✅
CustomScrollView(
  slivers: [
    const SliverAppBar(pinned: true, title: Text('Trending')),
    SliverPadding(
      padding: AppSpacing.screenPadding,
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) => TrackCard(track: tracks[i]),
          childCount: tracks.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      ),
    ),
  ],
)
```

### 8. Hero Animations

- Use `Hero` widgets for shared-element transitions between list items and detail screens.
- The `tag` **must** be unique and stable — use the entity ID, not a generic string.
- Always wrap the Hero child in a `Material` widget on the destination page to prevent ink
  clipping artefacts.

```dart
// ✅ Source (list)
Hero(
  tag: 'track-poster-${track.id}',
  child: TrackPoster(path: track.posterPath),
)

// ✅ Destination (detail)
Hero(
  tag: 'track-poster-${track.id}',
  child: Material(
    type: MaterialType.transparency,
    child: TrackPoster(path: track.posterPath),
  ),
)
```

### 9. Animation Principles

- Prefer `AnimatedSwitcher`, `AnimatedContainer`, and `TweenAnimationBuilder` for declarative
  animations.
- Use `AnimationController` + `CurvedAnimation` only when explicit frame-level control is needed.
- Animation curves: use `Curves.easeInOutCubic` as the project default; deviations must be
  justified in a comment referencing `DESIGN.md`.
- Target **60 fps** on mid-range devices. Profile on a physical device before shipping.

### 10. Accessibility

- All interactive elements must have a `Semantics` label or `Tooltip`.
- Minimum tap target size: **48 × 48 dp** (Material spec).
- Colour contrast ratio: minimum **4.5 : 1** for body text, **3 : 1** for large text, per WCAG AA.

---

## Do / Don't Reference Table

| ✅ Do | ❌ Don't |
|---|---|
| Source all tokens from `AppColors`, `AppSpacing`, `AppTextStyles` | Inline hex values, pixel sizes, or raw `TextStyle` |
| Read `DESIGN.md` before implementing any new component | Invent visual styles not specified in `DESIGN.md` |
| Use `AppColors.of(context)` for semantic, theme-aware colours | Hard-code dark/light conditionals in widgets |
| Wrap animated/canvas widgets in `RepaintBoundary` | Let independent animations repaint ancestors |
| Use `SliverList` / `SliverGrid` for dynamic lists | Use `ListView(children:[])` for unbounded lists |
| Apply stable entity-ID-based `Hero` tags | Use generic or index-based Hero tags |
| Target 60 fps; profile on physical hardware | Ship animations that haven't been profiled |
| Provide `Semantics` labels on all interactive elements | Leave icon buttons or custom widgets without accessibility labels |
