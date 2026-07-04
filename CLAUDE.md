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

## Architecture

Feature-first Clean Architecture. No flat `screens/` folder.

```
lib/
├── core/
│   ├── domain/          # Shared entities (CastMember, MediaType)
│   ├── data/            # Shared DTOs (CastMemberDto)
│   ├── env/             # Envied secrets (env.dart + env.g.dart)
│   ├── network/         # Singleton Dio (tmdb_client), interceptors, NetworkFailure
│   ├── router/          # GoRouter AppRouter + AppRoutes constants
│   ├── supabase/        # supabaseClientProvider
│   ├── theme/           # AppColors, AppTheme, AppSpacing, theme_provider
│   ├── utils/           # logger.dart
│   └── widgets/         # Shared widgets (GlassmorphicAppBar, ErrorView, etc.)
├── features/
│   ├── auth/            # Supabase auth (login, register, AuthNotifier)
│   ├── discover/        # TMDB discover/search
│   ├── home/            # Home feed (trending bento sections)
│   ├── movies/          # Movie domain + TMDB datasource + details page
│   ├── tv_series/       # TV series domain + TMDB datasource + details/episode pages
│   ├── watched/         # Watched items (Supabase) + categorized TV provider
│   ├── watchlist/       # Watchlists (Supabase) + picker sheet
│   ├── profile/         # Profile page, user stats, image upload
│   └── settings/        # Settings page
└── main.dart
```

### Layer Import Rules

| Layer | May Import |
|---|---|
| `data/datasources` | `core/`, Supabase/Dio |
| `data/models` | Dart SDK only |
| `data/repositories` | `domain/`, `data/datasources` |
| `domain/entities` | Dart SDK only |
| `domain/repositories` | `domain/entities` |
| `ui/providers` | `domain/repositories`, other providers |
| `ui/pages` + `ui/widgets` | `ui/providers`, `core/theme` |

**No cross-feature imports.** Features talk to each other only via `core/` or shared domain entities.

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

- **Dio**: one singleton via `@Riverpod(keepAlive: true)` in `core/network/tmdb_client.dart`. Never instantiate `Dio()` in features.
- Interceptor order: Auth (`TmdbAuthInterceptor`) → Logging (`PrettyDioLogger`, debug only) → Retry (`TmdbRetryInterceptor`).
- Retry only `GET` requests (idempotent). Up to 3 retries, exponential back-off. Never retry `POST`/`PUT`/`DELETE`.
- Map all `DioException` to sealed `NetworkFailure` types in the datasource. Repositories translate to domain `Result`/`Failure`. Raw exceptions never reach UI.
- **Supabase**: init once in `main.dart`. Access via `supabaseClientProvider`. Never use `Supabase.instance.client` in features.
- Auth state = `StreamProvider` on `onAuthStateChange` via `AuthNotifier`.
- Supabase Realtime → exposed as `Stream<T>` from datasource. Cancel in `ref.onDispose`.
- **RLS**: Must be enabled on every user-data table. Naming convention: `[table]_[role]_[action]`. Never disable RLS for convenience.

---

## Secrets (Envied)

- All secrets live in `.env` (gitignored). Never `String.fromEnvironment` or hardcoded literals.
- Access via `lib/core/env/env.dart` (`Env.tmdbApiKey`, `Env.supabaseUrl`, `Env.supabaseAnonKey`).
- `env.g.dart` **is committed** (obfuscated values, no plain strings).
- After changing `.env`, run: `dart run build_runner build --delete-conflicting-outputs`.
- `.env.example` (key names only, no values) **is committed** — documents required secrets for new devs.
- CI/CD: store secrets in GitHub Secrets, never in workflow YAML. `.env` is created ephemerally in the runner.

---

## UI / Design System (Aura Cinema)

> Read `DESIGN.md` before any UI work. It is the single source of truth.

- **Colors**: Always `AppColors.of(context)`. Never `Theme.of(context).colorScheme`, `Colors.black`, or hex literals.
- **Spacing**: Always `AppSpacing` tokens (8dp multiples). Never raw doubles for padding.
- **Typography**: `AppTextStyles`. No raw `TextStyle` outside `core/theme/`.
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
- **Failures**: Each feature defines a `sealed class` in `domain/failures/`. Repositories catch and map; UI sees only failure types.
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

- Router in `lib/core/router/app_router.dart`. Auth state tied via `RefreshListenable`.
- All path strings centralized in `AppRoutes` constants. Never hardcode path strings outside that file.
- Navigate with `context.go('/path')`.
- Primary app sections = `StatefulShellBranch` under the root `StatefulShellRoute`. New top-level tabs go there, not as standalone routes.

---

## Skills (`.claude/skills/`)

Three project-specific skills exist for complex tasks:

| Skill | Trigger |
|---|---|
| `generate_feature` | Creating a new feature from scratch |
| `apply_design_system` | Building/styling any UI component |
| `state_management_and_routing` | Adding providers, routes, or navigation logic |

---

## Wiki Knowledge Base
Path: ~/second-brain

When saving sessions or querying past knowledge:
1. Read ~/second-brain/wiki/hot.md first (recent context)
2. If not enough, read ~/second-brain/wiki/index.md
3. Save session notes to ~/second-brain/wiki/
