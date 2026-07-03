# Favorites UI — Design Spec (Task 11b)

Date: 2026-07-03
Depends on: Task 9 (detail page action bar/UI shell), Task 11a (favorites backend — commit `2f7e308`, done)

## Context

11a shipped the favorites backend: `FavoriteItem` entity, `FavoriteItemDto`, `IFavoritesRepository`/`FavoritesRepositoryImpl`, Supabase table `favorites` (RLS: owner select/insert/delete), and two providers in `lib/features/favorites/ui/providers/favorites_providers.dart`:

- `favoritesProvider` — `@riverpod Stream<List<FavoriteItem>>`, user's full favorites list.
- `isMediaFavoriteProvider({mediaId, mediaType})` — `@riverpod Future<bool>`, per-item favorited check.

No toggle notifier exists. There is no literal Task 9 placeholder in code (checked — only referenced in `filmania_task_split.md`); this task adds the favorite UI from scratch, following the existing watchlist/watched UI patterns.

Scope of this task: heart toggle button on movie/TV detail pages, a standalone Favorites page, an entry point from the profile page, and quick-remove from the grid. No changes to backend/providers beyond what 11a shipped.

## 1. Shared toggle widget

New file: `lib/features/favorites/ui/widgets/favorite_button.dart`

`FavoriteButton` (`ConsumerWidget`) — icon-only toggle, parametrized by `mediaId: int`, `mediaType: MediaType`, `mediaTitle: String`, `posterPath: String?` (needed to construct `FavoriteItem` on add), and a `size`/`style` knob so it can render both as a detail-page action icon and as a grid-card badge.

Behavior mirrors `WatchedButton` (`lib/features/watched/ui/widgets/watched_button.dart:43-86`) — no dedicated notifier exists for favorites (unlike watchlist's `watchlistProvider`), so:

- Watches `isMediaFavoriteProvider(mediaId: mediaId, mediaType: mediaType)` for current state (`AsyncValue<bool>`).
- Local `bool _isToggling` state (StatefulWidget wrapper or `useState` via flutter_hooks if already in use in the codebase — otherwise plain `StatefulWidget`) to disable double-taps and show inline spinner during the write.
- On tap: reads `favoritesRepositoryProvider`, calls `addFavorite(FavoriteItem(...))` or `removeFavorite(userId: ..., mediaId: ..., mediaType: ...)` depending on current state.
- On success: `ref.invalidate(isMediaFavoriteProvider(mediaId: mediaId, mediaType: mediaType))` and `ref.invalidate(favoritesProvider)`.
- On failure: catch `FavoriteFailure`, log via `AppLogger.error`, show inline error (SnackBar via `ref.listen` at call site is out of scope — button itself just reverts visual state and logs).
- Icon: `Icons.favorite_rounded` (favorited, primary color) / `Icons.favorite_border_rounded` (not favorited).
- `AsyncValue.when` exhaustive: `loading` → small spinner, `error` → border icon (fail-safe to "not favorited" visual, logged).

## 2. Detail-page integration

In `movie_details_page.dart` and `tv_series_details_page.dart`, add `FavoriteButton` next to the existing `_WatchlistButton` (both files, same position — action row near the top of the detail content). Visual weight: icon button (secondary), watchlist button remains the primary CTA (unchanged).

## 3. FavoritesPage

New file: `lib/features/favorites/ui/pages/favorites_page.dart`

Modeled on `lib/features/watchlist/ui/pages/watchlist_page.dart`:

- `CustomScrollView` + `GlassmorphicAppBar` (title "Preferiti").
- Data: `ref.watch(favoritesProvider)` (`AsyncValue<List<FavoriteItem>>`), `.when` exhaustive:
  - `loading`: shimmer grid cards (reuse/adapt `_WatchlistShimmerCard` pattern).
  - `error`: reuse `ErrorView` (core widget) with retry → `ref.invalidate(favoritesProvider)`.
  - `data` empty: `_FavoritesEmptyState` — `GlassOverlay` + heart icon + title "Nessun preferito" + description text, matching `_WatchlistEmptyState` structure.
  - `data` non-empty: `SliverGrid` (`SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.85, crossAxisSpacing: AppSpacing.sm, mainAxisSpacing: AppSpacing.sm)`), each cell a card:
    - `CachedNetworkImage` poster (`memCacheWidth`/`memCacheHeight` set per project performance rules), gradient overlay, bottom title text (`mediaTitle`).
    - Top-right `GlassOverlay` badge containing a filled-heart `FavoriteButton` (badge-size variant) — tap removes the item immediately (calls `removeFavorite`, list updates reactively via the `favoritesProvider` stream — no manual list mutation needed since it's Supabase Realtime-backed).
    - Tap on card body (outside badge) → navigate to `AppRoutes.movieDetails`/`AppRoutes.tvSeriesDetails` with `item.mediaId`, using `Hero` tag = media id (existing convention).

## 4. Routing

`lib/core/router/app_router.dart`:

- Add `static const favorites = '/favorites';` to `AppRoutes`.
- Add standalone `GoRoute(path: AppRoutes.favorites, builder: (context, state) => const FavoritesPage())` alongside the existing `watchedMovies`/`watchedTv` standalone routes (not a `StatefulShellBranch` — avoids a 5th bottom-tab, per task instructions).

## 5. Profile entry point

`lib/features/profile/ui/pages/profile_page.dart`, `_RecentActivitySection` (lines ~376-451): add a third `_CategoryCard`-style tile, heart icon, label "Preferiti", count sourced from `ref.watch(favoritesProvider).valueOrNull?.length ?? 0`, `onTap: () => context.push(AppRoutes.favorites)`. Reuses the existing `_CategoryCard` component (generalized if it currently hardcodes `WatchedItem`-specific data — adapt its count/icon inputs to be generic).

## Out of scope

- No bulk-select/multi-remove action bar for favorites (no `SelectionActionBar` wiring) — Task 9 did not actually add a favorites placeholder to any action bar in code, and favorites is single-item toggle by design (matches how watchlist's bookmark button works, not watched's bulk-select flow).
- No changes to `favorites_providers.dart` or repository/datasource layers — 11a's backend is used as-is.
