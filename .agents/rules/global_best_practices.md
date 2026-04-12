# Rule: Global Best Practices — Violet Tracker

> **Mandate**: Senior Flutter Architect role. No compromise on performance, correctness, quality. Production-grade code.

---

## Context

Foundation standards for Dart/Flutter. Derived from [Effective Dart](https://dart.dev/effective-dart). Enforced by `analysis_options.yaml`. Refactor violations.

---

## Mandatory Guidelines

### 1. Effective Dart

All code **must** conform:

| Pillar | Enforcement |
|---|---|
| **Style** | `dart format` every save; `lints` package active |
| **Documentation** | Public APIs need `///` doc-comments; explain *why* |
| **Usage** | Use language features (`?.`, `??`, spreads) |
| **Design** | Design for call-site; thin, composable interfaces |

### 2. `const` Everywhere

- Every widget constructor possible **must** be `const`.
- Immutable values (`Color`, `EdgeInsets`, `TextStyle`) **must** be `const`.
- `prefer_const_constructors` = **error**.

### 3. Null Safety — Strict

- `sound null safety` mandatory. No `// ignore`.
- **Never** use `!`. Use only with comment proof.
- Prefer `?.`, `??`, `??=`, early-return guards.

### 4. Widget Decomposition

- `build()` method **max 50 lines**. Extract sub-widgets to dedicated `StatelessWidget` / `ConsumerWidget` classes.
- Private helper methods returning `Widget` are **forbidden** (bypass optimizations).
- Use `RepaintBoundary` for animation subtrees.

### 5. Naming

| Artefact | Convention | Example |
|---|---|---|
| Files/dirs | `snake_case` | `track_repository.dart` |
| Classes/enums | `UpperCamelCase` | `TrackRepository` |
| Vars/params/fns | `lowerCamelCase` | `fetchTracks()` |
| Constants | `lowerCamelCase` | `const maxRetries = 3` |
| Private | `_lowerCamelCase` | `_cache` |

### 6. DRY Principle

- Extracts logic repeated > 2 times.
- No hard-coded UI/spacing; use `AppTheme` / `AppSpacing` (from `DESIGN.md`).

### 7. SOLID in Flutter

| Principle | Manifestation |
|---|---|
| **S**ingle Responsibility | 1 widget = 1 concept; 1 provider = 1 state |
| **O**pen/Closed | Composition over modification |
| Liskov | Repos impl abstract interfaces; swap easily |
| Interface Segregation | Thin interfaces (`IRead`, `IWrite`) |
| Dependency Inversion | Widgets depend on providers, not concrete classes |

### 8. `analysis_options.yaml` Baseline

Strict casts, inference, and raw types. Error on missing params/returns. Rules: `prefer_const_*`, `avoid_print`, `always_use_package_imports`.

---

## Do / Don't

| ✅ Do | ❌ Don't |
|---|---|
| `const` everywhere possible | Omit `const` for immutable widgets |
| Extract widgets to classes | Return widgets from helper methods |
| `?.` and `??` for nulls | Use `!` without proof |
| `///` doc-comments | Leave public members undocumented |
| `AppTheme`/`AppSpacing` | Hard-code colors/pixels |
| `build()` under 50 lines | Monolithic build methods |
| Effective Dart naming | Abbreviations/inconsistent casing |
| Strict analyser flags | Suppress linter without reason |
| SOLID composition | Couple widgets to concrete classes |
| `dart format` before commit | Commit unformatted code |
