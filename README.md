# Filmania

Cinematic editorial app for discovering movies and TV series, building watchlists, and tracking what you've watched. Built with Flutter + Supabase.

> **Personal context**: This project exists for two reasons — to explore AI-assisted development workflows (Claude Code, Antigravity) and to learn Flutter and mobile development hands-on. Every architectural choice, design decision, and tooling setup has been made deliberately to push both goals.

---

## Features

| Area | What it does |
|---|---|
| **Discover** | Browse and search movies & TV series via TMDB API |
| **Home** | Trending bento-style editorial feed |
| **Movies** | Full details page with cast, overview, and actions |
| **TV Series** | Season/episode navigation with per-episode watched toggling |
| **Watchlist** | Create multiple named lists, add/remove media, picker sheet |
| **Watched** | Track watched movies and TV episodes via Supabase |
| **Profile** | User stats, avatar upload via Supabase Storage |
| **Settings** | Theme switching (Dark / Light / Pure Black), locale |
| **Auth** | Email/password login and registration via Supabase Auth |

---

## Technology Stack

### Core

| Package | Role |
|---|---|
| [Flutter](https://flutter.dev/) `^3.11.4` | Cross-platform UI framework |
| [Dart](https://dart.dev/) `^3.11.4` | Language |
| [Supabase Flutter](https://pub.dev/packages/supabase_flutter) `^2.12.2` | Auth, Postgres DB (RLS), Storage, Realtime |
| [Dio](https://pub.dev/packages/dio) `^5.9.2` | HTTP client for TMDB API |
| [GoRouter](https://pub.dev/packages/go_router) `^17.2.0` | Declarative routing |
| [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) `^3.3.1` | State management |

### Code Generation

| Package | Role |
|---|---|
| [riverpod_annotation](https://pub.dev/packages/riverpod_annotation) + [riverpod_generator](https://pub.dev/packages/riverpod_generator) | `@riverpod` code gen |
| [freezed](https://pub.dev/packages/freezed) + [freezed_annotation](https://pub.dev/packages/freezed_annotation) | Immutable entities |
| [json_serializable](https://pub.dev/packages/json_serializable) + [json_annotation](https://pub.dev/packages/json_annotation) | DTO serialization |
| [envied](https://pub.dev/packages/envied) + [envied_generator](https://pub.dev/packages/envied_generator) | Obfuscated secrets from `.env` |
| [build_runner](https://pub.dev/packages/build_runner) | Code generation runner |

### UI & Media

| Package | Role |
|---|---|
| [cached_network_image](https://pub.dev/packages/cached_network_image) `^3.4.1` | Poster/backdrop caching |
| [image_picker](https://pub.dev/packages/image_picker) `^1.2.1` | Avatar upload |
| [pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger) `^1.4.0` | Debug-only request logging |
| [shared_preferences](https://pub.dev/packages/shared_preferences) `^2.5.5` | Persisted theme/locale setting |
| [intl](https://pub.dev/packages/intl) `^0.20.2` | Localization |
| Manrope + Inter | Custom bundled fonts (display + body) |

### External APIs

- **TMDB API** — movies, TV series, trending, search, cast
- **Supabase** — auth, watchlists, watched state, profile, image storage

---

## Architecture

The code follows the structure of the [official Flutter architecture case study](https://docs.flutter.dev/app-architecture/case-study): **data and domain are shared and organised by type, the UI is organised by feature**. Repositories and services serve every screen that needs them; each feature owns only its pages and view models. Riverpod providers play the view-model and dependency-injection roles that the guide shows with `ChangeNotifier` + `provider`.

```
lib/
├── config/                   # Envied secrets (env.dart; env.g.dart generated, gitignored)
├── routing/                  # GoRouter AppRouter + AppRoutes constants
├── utils/                    # logger, concurrency helpers
├── l10n/                     # ARB files, generated AppLocalizations
├── domain/
│   ├── models/               # Immutable entities and enums (@freezed)
│   ├── failures/             # Sealed failure types
│   └── use_cases/            # Logic that needs several repositories (MarkAsWatchedUseCase)
├── data/
│   ├── models/               # DTOs (@JsonSerializable, toEntity())
│   ├── services/             # tmdb/ (Dio client, interceptors, datasources), supabase/, tvtime/
│   └── repositories/         # <name>/: interface (i_*.dart), implementation, read providers
├── ui/
│   ├── core/
│   │   ├── themes/           # AppColors, AppTheme, AppSpacing, theme_provider
│   │   ├── ui/               # Widgets shared by several features
│   │   └── view_models/      # State and actions shared by several features
│   └── <feature>/            # auth, discover, home, movies, tv_series, person, watched,
│       ├── view_models/      # watchlist, favorites, profile, settings, tvtime_import
│       └── widgets/          # Pages and widgets of the feature
└── main.dart
```

### Import Rules

Checked by `test/architecture/import_rules_test.dart`, which CI runs on every push and pull request, so a violation fails the build:

- a feature never imports another feature: they share only through `ui/core`, `data` and `domain`;
- `ui/core` never imports a feature;
- `data` never imports `ui` or `routing`;
- repositories are never aware of each other (the auth session is the one shared input);
- `domain/models` and `domain/failures` depend only on the domain.

Raw exceptions never reach the UI. Every datasource maps `DioException` / Supabase errors to sealed `Failure` types. Repositories translate to domain results.

---

## State Management (Riverpod 3.0)

- All providers use `@riverpod` code generation — no manual `Provider(...)` declarations.
- Every provider file has `part 'file.g.dart';`.
- `ref.watch` — reactive reads inside `build()` only.
- `ref.read` — inside callbacks (`onPressed`, etc.).
- `ref.listen` — side effects (navigation, snackbars, toasts).
- `AsyncValue.guard()` inside `AsyncNotifier` for safe error wrapping.
- `.select()` to narrow rebuilds and prevent unnecessary widget trees from repaint.
- One provider = one unit of state. No God providers.

```dart
// Mutation example
@riverpod
class WatchedNotifier extends _$WatchedNotifier {
  @override
  Future<List<WatchedItem>> build() async => ref.watch(watchedRepositoryProvider).getAll();

  Future<void> toggle(String mediaId) async {
    state = await AsyncValue.guard(() => ...);
  }
}
```

---

## Networking

### TMDB (Dio)

Single `Dio` instance via `@Riverpod(keepAlive: true)` in `data/services/tmdb/tmdb_client.dart`. Interceptor order is fixed:

1. `TmdbAuthInterceptor` — appends Bearer token from `Env.tmdbApiKey`
2. `PrettyDioLogger` — debug builds only (`kReleaseMode` check)
3. `TmdbRetryInterceptor` — up to 3 retries on `GET` requests, exponential back-off. Mutations (`POST`/`PUT`/`DELETE`) are never retried.

`DioException` maps to sealed `NetworkFailure`:
- `ServerFailure` — 4xx/5xx
- `ConnectionFailure` — no internet
- `TimeoutFailure` — connect/receive timeout
- `ParseFailure` — JSON decode error
- `UnauthorizedFailure` — 401

### Supabase

Initialized once in `main.dart`. Accessed via `supabaseClientProvider` — never via `Supabase.instance.client` outside `data/services/supabase/`. Auth state is a Riverpod `StreamProvider` on `onAuthStateChange`. RLS is required on every user-data table.

---

## Secrets & Environment

All secrets live in `.env` (gitignored). Accessed via `lib/config/env.dart` using [envied](https://pub.dev/packages/envied).

```
TMDB_API_KEY=...
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
```

`env.g.dart` is **not** committed (gitignored): Envied obfuscation is reversible, so the generated file is rebuilt locally, in the iOS build from the secrets, and in the test job from placeholder values.

After modifying `.env`, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Design System — Aura Cinema

> "Digital Curator" — editorial experience, not a database. High-end gallery for cinematic art.

Full specification in [`DESIGN.md`](DESIGN.md). The system is enforced via `ui/core/themes/` — nothing is hardcoded in feature code.

### Colors

| Role | Dark (`#`) | Light (`#`) |
|---|---|---|
| Background | `0F0E13` | `FAFAFA` |
| Surface / Cards | `1B1A23` | `FFFFFF` |
| Primary Text | `F5F5F5` | `1A1A1A` |
| Secondary Text | `938F99` | `666666` |
| Primary Action | `7C4DFF` | `7C4DFF` |
| Accent / Selection | `E1D5FF` | `E1D5FF` |

Three theme modes: **Dark** (default), **Light**, **Pure Black**.

Always use `AppColors.of(context)`. Never `Theme.of(context).colorScheme`, `Colors.black`, or hex literals.

### Typography

- **Manrope** — display, headlines (300–800 weight). Geometric precision.
- **Inter** — body, labels, metadata (100–900 weight). Legibility at small sizes.

Always use `AppTextStyles`. No raw `TextStyle` outside `ui/core/themes/`.

### Spacing

8dp multiples via `AppSpacing`. Never raw doubles for padding/margin.

### No-Line Philosophy

No 1px borders or dividers — ever. Use:
- Background color shifts (tonal tiers)
- 8dp vertical whitespace between sections
- Gradients to guide the eye

### Surface Layering

```
Layer 0 — background          (#0F0E13)
Layer 1 — surface-container-low
Layer 2 — surface-container(-high)
Layer 3 — surface-bright / floating modals
```

### Glassmorphism

Nav bars and sticky headers use `BackdropFilter` blur (20–40px) with `surface` colors at 70–80% opacity. **Not used** on small repeated widgets (grid card buttons) — see performance section.

---

## Performance

Documented in [`PERFORMANCE_FIXES.md`](PERFORMANCE_FIXES.md). Key rules:

| Issue | Rule |
|---|---|
| `BackdropFilter` on repeated small widgets | Use `Colors.black.withValues(alpha: 0.5)` instead |
| `Opacity` widget | Replace with `color.withValues(alpha:)` — avoids extra render layer |
| `Clip.antiAlias` in scroll lists | Use `Clip.hardEdge` |
| `CachedNetworkImage` | Always set `memCacheWidth` / `memCacheHeight` |
| Shadows in scroll lists | Keep `blurRadius` ≤ 15 |
| Independent animation subtrees | Wrap in `RepaintBoundary` |

Target: stable 60fps in release mode, 120fps on high-refresh devices.

Profile with:
```bash
flutter run --profile
```

---

## Routing

GoRouter in `lib/routing/app_router.dart`. Auth state wired via `RefreshListenable`. All path strings centralized in `AppRoutes` constants — no hardcoded path strings in feature code.

Primary sections use `StatefulShellBranch` under a root `StatefulShellRoute` (persistent bottom nav). Navigate with `context.go('/path')`.

---

## Localization

Flutter's built-in `flutter_localizations` + ARB files. Locale managed by `localeProvider` (Riverpod). Current supported locales: Italian, English.

---

## Project Conventions

### Entities

- Must use `@freezed`. No mutation — use `.copyWith()`.
- No JSON logic in entities (that lives in DTOs).

### DTOs

- `@JsonSerializable` in `data/models/`.
- Include a `toEntity()` method or extension.
- Mapping only in the repository layer.

### Widgets

- `build()` max 50 lines. Extract to named `StatelessWidget`/`ConsumerWidget`.
- Private helper methods returning `Widget` are forbidden.
- `const` everywhere it can be applied.

### Null Safety

- Sound null safety enforced. Never `!` without a comment proving it cannot be null.

### Comments

- No comments explaining what code does. Only comments for non-obvious constraints or workarounds.

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) `^3.11.4`
- Dart SDK `^3.11.4`
- A [Supabase](https://supabase.com/) project
- A [TMDB API key](https://developer.themoviedb.org/)

### Setup

1. **Clone**
   ```bash
   git clone https://github.com/iosonoira/filmania.git
   cd filmania
   ```

2. **Create `.env`** in the project root:
   ```
   TMDB_API_KEY=your_tmdb_api_key
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Run**
   ```bash
   flutter run
   ```

### Development Commands

```bash
# Watch mode — auto-regenerate on file changes
dart run build_runner watch --delete-conflicting-outputs

# Lint check
dart analyze

# Format check
dart format --set-exit-if-changed .

# Format all files
dart format .

# Run tests
flutter test

# Run single test
flutter test test/path/to/test_file.dart

# Profile build
flutter run --profile
```

---

## Testing

`test/` mirrors `lib/`. Coverage focuses on DTO parsing, repositories and use cases, and the UI behaviour of key interactive components, for example:

- `test/architecture/import_rules_test.dart` — the import rules above
- `test/domain/use_cases/mark_as_watched_use_case_test.dart`
- `test/data/repositories/watched/watched_repository_impl_test.dart`
- `test/ui/core/ui/watched_episode_button_icon_test.dart`
- `test/ui/tv_series/widgets/episode_card_test.dart`

Tests use `ProviderScope` overrides to inject mock repositories — never Mockito mocks of Supabase/Dio directly, and no test reaches the network.

CI (`.github/workflows/tests.yml`) runs `dart analyze` and `flutter test` on every push and pull request; `ios-build.yml` builds an unsigned iOS app on pushes to `main`.

---

## Attribution

<img src="assets/blue_square_2-d537fb228cf3ded904ef09b136fe3fec72548ebc1fea3fbbd1ad9e36364db38b.svg" alt="TMDB Logo" width="100" />

This application uses TMDB and the TMDB APIs but is not endorsed, certified, or otherwise approved by TMDB.

---

