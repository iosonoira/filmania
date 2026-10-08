# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Commands

```bash
# Install dependencies
flutter pub get

# Generate all code (Freezed, Riverpod, JsonSerializable, Envied)
dart run build_runner build --delete-conflicting-outputs

# Watch mode during development
dart run build_runner watch --delete-conflicting-outputs

# Run app
flutter run

# Run tests
flutter test

# Run single test file
flutter test test/path/to/test_file.dart

# Lint + format check
dart analyze
dart format --set-exit-if-changed .

# Format all files
dart format .

# Profile build (for performance profiling)
flutter run --profile
```

> After modifying `.env`, always re-run `build_runner build` — `env.g.dart` must be regenerated.

---

## Documentation Source

- For anything Flutter-related (widgets, APIs, patterns, performance, platform setup), rely ONLY on the official up-to-date Flutter documentation: https://docs.flutter.dev/
- Never invent APIs, parameters, or behaviors. If unsure or nothing is found, consult docs.flutter.dev — do NOT fall back on memory, blog posts, Stack Overflow, or outdated patterns. If the docs don't cover it, say so instead of guessing.

---

## Architecture

Follows the structure of the official Flutter architecture case study (https://docs.flutter.dev/app-architecture/case-study): **data and domain are shared and organised by type, the UI is organised by feature**. Repositories and services are not tied to a single feature; each feature owns only its screens and view models. The guide uses `ChangeNotifier` + `provider`; here Riverpod providers play the view-model and dependency-injection roles (the guide leaves state management to preference).

```
lib/
├── config/              # Envied secrets (env.dart; env.g.dart is generated and gitignored)
├── routing/             # GoRouter AppRouter + AppRoutes constants
├── utils/               # logger, concurrency helpers
├── l10n/                # ARB files, generated AppLocalizations, AuthFailure messages
├── domain/
│   ├── models/          # Freezed entities and enums (Movie, TVSeries, WatchedItem, MediaType…)
│   ├── failures/        # Sealed failure types (AuthFailure, WatchedFailure…)
│   └── use_cases/       # Logic that needs several repositories and is shared by several view models
├── data/
│   ├── models/          # DTOs with toEntity()
│   ├── services/        # tmdb/ (Dio client, interceptors, TMDB datasources), supabase/ (client,
│   │                    # Supabase datasources), tvtime/ (import parser and matcher), NetworkFailure
│   └── repositories/    # <name>/: interface (i_*.dart), implementation, <name>_providers.dart
├── ui/
│   ├── core/
│   │   ├── themes/      # AppColors, AppTheme, AppSpacing, theme_provider
│   │   ├── ui/          # Widgets used by several features (GlassmorphicAppBar, MediaGridCard,
│   │   │                # WatchedButton, FavoriteButton, watchlist picker, bottom nav bar…)
│   │   └── view_models/ # State and actions used by several features (WatchlistNotifier,
│   │                    # isMediaWatched, categorizedTvSeries, bulk actions)
│   └── <feature>/       # auth, discover, home, movies, tv_series, person, watched, watchlist,
│       ├── view_models/ # favorites, profile, settings, tvtime_import
│       └── widgets/     # The feature's pages and widgets
└── main.dart
```

`test/` mirrors `lib/`.

### Where things go

| What | Where |
|---|---|
| Used by one feature only | `ui/<feature>/view_models` or `ui/<feature>/widgets` |
| Widget used by several features | `ui/core/ui/` |
| State or action used by several features | `ui/core/view_models/` |
| Provider that only reads one repository | `data/repositories/<name>/<name>_providers.dart` |
| Logic combining several repositories, repeated across view models | `domain/use_cases/` |

### Import Rules

Enforced by `test/architecture/import_rules_test.dart` — run `flutter test test/architecture` after moving code.

| Folder | Never imports |
|---|---|
| `ui/<feature>/` | another `ui/<feature>/` — features share only through `ui/core`, `data` and `domain` |
| `ui/core/` | any `ui/<feature>/` |
| `data/` | `ui/`, `routing/` |
| `data/repositories/<a>/` | `data/repositories/<b>/` — repositories are never aware of each other (the auth session in `auth/auth_providers.dart` is the one shared input) |
| `domain/use_cases/` | `ui/`, `routing/` |
| `domain/models/`, `domain/failures/` | anything outside `domain/models` and `domain/failures` |

`routing/` may import every feature's pages.

---

## State Management (Riverpod 3.0)

- **Always** use `@riverpod` code generator. Never declare `Provider(...)` manually.
- Every file with a provider needs `part 'file.g.dart';`.
- `ref.watch` → reactive derivation inside `build()` only. `ref.read` → inside callbacks. `ref.listen` → side effects (SnackBars, toasts).
- Never call `ref.watch` inside callbacks, loops, or conditionals.
- Async state: use `AsyncValue.guard()` inside `AsyncNotifier`. Handle `.when(data:, loading:, error:)` exhaustively — never access `.value!` directly.
- One provider = one unit of state. No "God providers".
- Use `.select()` to narrow rebuilds.
- Mutations → `AsyncNotifier`. Computed reads → `@riverpod` function provider.

---

## Networking

- **Dio**: one singleton via `@Riverpod(keepAlive: true)` in `data/services/tmdb/tmdb_client.dart`. Never instantiate `Dio()` anywhere else.
- Interceptor order: Auth (`TmdbAuthInterceptor`) → Logging (`PrettyDioLogger`, debug only) → Retry (`TmdbRetryInterceptor`).
- Retry only `GET` requests (idempotent). Up to 3 retries, exponential back-off. Never retry `POST`/`PUT`/`DELETE`.
- Map all `DioException` to sealed `NetworkFailure` types in the datasource. Repositories translate to domain `Result`/`Failure`. Raw exceptions never reach UI.
- **Supabase**: init once in `main.dart`. Access via `supabaseClientProvider`. Never use `Supabase.instance.client` outside `data/services/supabase/`.
- Auth state = `authStateProvider` (stream on `onAuthStateChange`) in `data/repositories/auth/auth_providers.dart`; login/register live in `ui/auth/view_models/auth_notifier.dart`.
- Supabase Realtime → exposed as `Stream<T>` from datasource. Cancel in `ref.onDispose`.
- **RLS**: Must be enabled on every user-data table. Naming convention: `[table]_[role]_[action]`. Never disable RLS for convenience.

---

## Secrets (Envied)

- All secrets live in `.env` (gitignored). Never `String.fromEnvironment` or hardcoded literals.
- Access via `lib/config/env.dart` (`Env.tmdbApiKey`, `Env.supabaseUrl`, `Env.supabaseAnonKey`).
- `env.g.dart` is **not** committed (gitignored): Envied obfuscation is reversible and the repo is public. Regenerate it locally with `build_runner`; CI regenerates it from GitHub Secrets.
- After changing `.env`, run: `dart run build_runner build --delete-conflicting-outputs`.
- `.env.example` (key names only, no values) **is committed** — documents required secrets for new devs.
- CI/CD: store secrets in GitHub Secrets, never in workflow YAML. `.env` is created ephemerally in the runner.

---

## UI / Design System (Aura Cinema)

> Read `DESIGN.md` before any UI work. It is the single source of truth.

- **Colors**: Always `AppColors.of(context)`. Never `Theme.of(context).colorScheme`, `Colors.black`, or hex literals.
- **Spacing**: Always `AppSpacing` tokens (8dp multiples). Never raw doubles for padding.
- **Typography**: `AppTextStyles`. No raw `TextStyle` outside `ui/core/themes/`.
- **No-Line Rule**: No 1px borders/dividers. Use 8dp whitespace or tonal surface shifts.
- **Dark mode default**: `#0F0E13` background, `#1B1A23` surface, `#7C4DFF` primary.
- **Slivers**: Dynamic lists must use `SliverList`/`SliverGrid` inside `CustomScrollView`. No `Column` + `SingleChildScrollView` for unbounded content.
- **Hero animations**: Use entity ID as tag. Wrap destination in `Material(type: MaterialType.transparency)`.
- **Animations**: `Curves.easeInOutCubic` default. Wrap independent animation subtrees in `RepaintBoundary`. Target 60fps.
- **Accessibility**: `Semantics`/`Tooltip` on interactive elements. Min tap target 48x48. WCAG AA contrast (4.5:1).
- **Performance — known issues** (see `PERFORMANCE_FIXES.md`):
  - Avoid `BackdropFilter` on small/repeated widgets (e.g. card overlay buttons). Use `Colors.black.withValues(alpha:)` instead.
  - Replace `Opacity` widget with `color.withValues(alpha:)` — avoids extra render layer.
  - Prefer `Clip.hardEdge` over `Clip.antiAlias` in scroll lists.
  - Always set `memCacheWidth`/`memCacheHeight` on `CachedNetworkImage`.

---

## Code Standards

- **`const` everywhere**: Every widget/value that can be `const` must be. `prefer_const_constructors` = error.
- **Null safety**: Sound null safety. Never use `!` without a comment proving it cannot be null.
- **Widget decomposition**: `build()` max 50 lines. Extract to `StatelessWidget`/`ConsumerWidget`. Private helper methods returning `Widget` are forbidden.
- **Entities**: Must use `@freezed`. No mutation — use `.copyWith()`. No JSON logic in entities.
- **DTOs**: `@JsonSerializable` in `data/models/`. Include `toEntity()` extension/method. Mapping only in repository layer.
- **Failures**: One `sealed class` per area in `domain/failures/`. Repositories catch and map; UI sees only failure types.
- **Documentation**: Public APIs need `///` doc-comments explaining *why*, not what.
- **DRY**: Extract logic repeated more than 2 times.
- **Naming** (Effective Dart):

| Artefact | Convention | Example |
|---|---|---|
| Files/dirs | `snake_case` | `track_repository.dart` |
| Classes/enums | `UpperCamelCase` | `TrackRepository` |
| Vars/params/fns | `lowerCamelCase` | `fetchTracks()` |
| Constants | `lowerCamelCase` | `const maxRetries = 3` |
| Private | `_lowerCamelCase` | `_cache` |

- **SOLID in Flutter**:

| Principle | Manifestation |
|---|---|
| Single Responsibility | 1 widget = 1 concept; 1 provider = 1 state |
| Open/Closed | Composition over modification |
| Liskov | Repos implement abstract interfaces; swap easily |
| Interface Segregation | Thin interfaces (`IRead`, `IWrite`) |
| Dependency Inversion | Widgets depend on providers, not concrete classes |

---

## Routing (GoRouter)

- Router in `lib/routing/app_router.dart`. Auth state tied via `RefreshListenable`.
- All path strings centralized in `AppRoutes` constants. Never hardcode path strings outside that file.
- Navigate with `context.go('/path')`.
- Primary app sections = `StatefulShellBranch` under the root `StatefulShellRoute`. New top-level tabs go there, not as standalone routes.

---

## Wiki Knowledge Base
Path: ~/second-brain

When saving sessions or querying past knowledge:
1. Read ~/second-brain/wiki/hot.md first (recent context)
2. If not enough, read ~/second-brain/wiki/index.md
3. Save session notes to ~/second-brain/wiki/
