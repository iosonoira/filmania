# Rule: UI/UX — Violet Tracker

> **Mandate**: Senior Flutter Architect and UI Engineer. Every pixel intentional, performant, consistent with `DESIGN.md`. No hard-coding. No jank.

---

## Context

Minimalist violet identity (`#7C4DFF`). **DESIGN.md** is the single source of truth. No token overrides without comment.

---

## Mandatory Guidelines

### 1. DESIGN.md is Law

Read `DESIGN.md` first. All tokens from `core/theme/`. No inlining.

### 2. Colour System

Expose via `AppColors`:
- `primary`: `#7C4DFF`.
- `primaryLight`/`primaryDark`: Hovers/Pressed.
- `surface`/`background`/`error`: Per theme.

### 3. Typography

- Use `AppTextStyles` (extension on `TextTheme`).
- No raw `TextStyle` outside `core/theme/`.

### 4. Spacing System

- Use `AppSpacing` (8dp multiples).
- No arbitrary pixels.

### 5. Theme Switching

- `AppTheme.light()` / `.dark()`.
- Managed by Riverpod `themeModeProvider`.
- Use `AppColors.of(context)` for semantic resolution. Never hard-code brightness checks.

### 6. Performance

- Wrap independent animations/canvas in `RepaintBoundary`.
- Profile with `flutter run --profile`.

### 7. Slivers (Scrollables)

- Dynamic lists **must** use `SliverList` / `SliverGrid`.
- `CustomScrollView` for complex screens (pinned headers).
- No `Column` + `SingleChildScrollView` for unbounded lists.

### 8. Hero Animations

- Stable tags (entity ID).
- Wrap destination child in `Material(type: MaterialType.transparency)` to avoid clipping.

### 9. Animation

- Prefer `AnimatedSwitcher`, `AnimatedContainer`.
- Default curve: `Curves.easeInOutCubic`.
- Target 60 fps.

### 10. Accessibility

- `Semantics` or `Tooltip` for interactions.
- Min tap target: 48x48.
- WCAG AA contrast (4.5:1).

---

## Do / Don't

| ✅ Do | ❌ Don't |
|---|---|
| Use `AppTokens` | Inline hex/pixels |
| Match `DESIGN.md` | Invent visual styles |
| `AppColors.of(context)` | Hard-code brightness logic |
| `RepaintBoundary` for animations | Repaint ancestors needlessly |
| Slivers for dynamic lists | `ListView(children:[])` for dynamic content |
| ID-based Hero tags | Generic/Index Hero tags |
| Target 60 fps | Ship un-profiled animations |
| `Semantics` labels | Undocumented interactive icons |
