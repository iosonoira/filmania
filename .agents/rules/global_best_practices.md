# Rule: Global Best Practices — Violet Tracker

> **Agent Mandate**: You are a Senior Flutter Architect. You do not compromise on performance,
> correctness, or code quality. Every line you write is production-grade, maintainable, and
> auditable. Mediocrity is not an option.

---

## Context

These rules define the non-negotiable foundational standards for all Dart/Flutter code produced
in the Violet Tracker project. They are derived from the official
[Effective Dart](https://dart.dev/effective-dart) guidelines (Style, Documentation, Usage, Design)
and are enforced by a strict `analysis_options.yaml`. Any code that violates these rules must be
refactored before it is considered complete.

---

## Mandatory Guidelines

### 1. Effective Dart Compliance

All code **must** conform to the four pillars of Effective Dart:

| Pillar | Enforcement |
|---|---|
| **Style** | `dart format` on every save; `lints` / `flutter_lints` package active |
| **Documentation** | Public API members require `///` doc-comments; explain *why*, not *what* |
| **Usage** | Prefer language features over manual patterns (e.g., `?.`, `??`, spreads) |
| **Design** | Design for the call-site; prefer narrow, composable interfaces |

### 2. `const` — First-Class Citizen

- Every widget constructor that can be `const` **must** be `const`.
- Every immutable value (`Color`, `EdgeInsets`, `TextStyle`, decoration objects) **must** be
  declared `const`.
- Linter rule `prefer_const_constructors` is set to **error**, not warning.

```dart
// ✅ DO
const SizedBox(height: 16);
const EdgeInsets.symmetric(horizontal: 24);

// ❌ DON'T
SizedBox(height: 16);  // unnecessary allocation on every rebuild
```

### 3. Null Safety — Strict Mode

- `sound null safety` is mandatory; the project **must not** contain `// ignore: null_safety`.
- **Never** use the `!` (bang) operator unless you can prove with a comment that the value is
  provably non-null at that exact call-site.
- Prefer `?.`, `??`, `??=`, and early-return guards.

```dart
// ✅ DO
final name = user?.displayName ?? 'Anonymous';

// ❌ DON'T
final name = user!.displayName;  // crash waiting to happen
```

### 4. Widget Decomposition & Rebuild Minimisation

- A `build()` method **must not** exceed **50 lines**. Extract sub-widgets into dedicated
  `StatelessWidget` / `ConsumerWidget` classes — not private methods returning `Widget`.
- Private helper methods that return `Widget` bypass Flutter's element-tree optimisations
  and **are forbidden**.
- Use `RepaintBoundary` around isolated animation or canvas subtrees (see `ui_ux.md`).

```dart
// ✅ DO — dedicated class, can be const, has its own RenderObject lifecycle
class _TrackCard extends StatelessWidget { ... }

// ❌ DON'T — rebuilds with the parent, not independently optimisable
Widget _buildTrackCard() => Card(...);
```

### 5. Naming Conventions

| Artefact | Convention | Example |
|---|---|---|
| Files & directories | `snake_case` | `track_repository.dart` |
| Classes & enums | `UpperCamelCase` | `TrackRepository` |
| Variables, params, functions | `lowerCamelCase` | `fetchTracks()` |
| Constants | `lowerCamelCase` | `const maxRetries = 3` |
| Private members | `_lowerCamelCase` | `_cache` |
| Generic type params | Single uppercase | `T`, `E` |

### 6. DRY Principle

- Any logic repeated more than **twice** must be extracted into a utility function, extension, or
  mixin.
- UI themes and spacing tokens must **never** be hard-coded inline; reference `AppTheme` /
  `AppSpacing` constants derived from `DESIGN.md`.

### 7. SOLID Principles Applied to Flutter

| Principle | Flutter Manifestation |
|---|---|
| **S**ingle Responsibility | One widget = one visual concept; one provider = one piece of state |
| **O**pen/Closed | Extend behaviour via composition, not modification of existing widgets |
| **L**iskov Substitution | Repositories implement abstract interfaces; swap implementations freely |
| **I**nterface Segregation | Thin repository interfaces; separate `IReadRepository` / `IWriteRepository` |
| **D**ependency Inversion | Widgets depend on Riverpod providers, never on concrete service classes |

### 8. `analysis_options.yaml` Baseline

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    missing_required_param: error
    missing_return: error
    dead_code: warning

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - avoid_print               # use a logger abstraction
    - avoid_dynamic_calls
    - always_use_package_imports
    - directives_ordering
    - avoid_relative_lib_imports
```

---

## Do / Don't Reference Table

| ✅ Do | ❌ Don't |
|---|---|
| Use `const` everywhere possible | Omit `const` for immutable widgets/values |
| Extract widgets into their own classes | Return widgets from private helper methods |
| Use `?.` and `??` for null handling | Use `!` without a documented proof of safety |
| Write `///` doc-comments on public APIs | Leave public members undocumented |
| Reference `AppTheme` / `AppSpacing` for all design tokens | Hard-code hex colours or pixel values inline |
| Keep `build()` under 50 lines | Write monolithic build methods |
| Follow Effective Dart naming conventions | Use abbreviations or inconsistent casing |
| Enable all strict analyser flags | Disable or suppress linter rules without justification |
| Apply SOLID — thin interfaces, dependency inversion | Couple widgets directly to concrete service classes |
| Run `dart format` before every commit | Commit unformatted code |
