# Favorites UI Implementation Plan (Task 11b)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the favorites UI: a reusable heart toggle button, a standalone Favorites grid page, routing, and a profile entry point — wired to the existing 11a backend.

**Architecture:** Follows Clean Architecture layering already established by `features/watchlist` and `features/watched`. All new code lives in `lib/features/favorites/ui/` (widgets + pages) plus small, additive edits to `movie_details_page.dart`, `tv_series_details_page.dart`, `profile_page.dart`, and `app_router.dart`. No changes to domain/data layers — 11a's `IFavoritesRepository`, `favoritesRepositoryProvider`, `favoritesProvider`, `isMediaFavoriteProvider` are used as-is.

**Tech Stack:** Flutter, Riverpod 3.0 (`@riverpod` codegen — no new providers needed in this plan), GoRouter, `cached_network_image`, existing `AppColors`/`AppSpacing`/`GlassOverlay`/`GlassmorphicAppBar`/`AppErrorView` core widgets.

## Global Constraints

- Colors: always `AppColors.of(context)`. Never `Theme.of(context).colorScheme`, `Colors.black` literals outside alpha-blended overlays already used in the codebase, or hex literals.
- Spacing: always `AppSpacing` tokens. Never raw doubles for padding/margin.
- No 1px borders/dividers (No-Line Rule) — match existing tonal-surface / whitespace patterns already in `watchlist_page.dart` and `movie_details_page.dart`.
- `const` everywhere it's valid.
- No `ref.watch` inside callbacks/loops/conditionals — only inside `build()`.
- `CachedNetworkImage` must set `memCacheWidth`/`memCacheHeight`.
- `build()` methods stay under ~50 lines; extract private widgets rather than private methods returning `Widget`.
- No cross-feature imports beyond `core/` and the explicit imports of `favorites`/`auth` providers shown below (mirrors how `watchlist`/`watched` are consumed today from movie/tv/profile pages).

---

### Task 1: `FavoriteButton` shared toggle widget

**Files:**
- Create: `lib/features/favorites/ui/widgets/favorite_button.dart`
- Test: `test/features/favorites/ui/widgets/favorite_button_test.dart`

**Interfaces:**
- Consumes: `isMediaFavoriteProvider({required int mediaId, required MediaType mediaType})` → `AsyncValue<bool>` (`lib/features/favorites/ui/providers/favorites_providers.dart`); `favoritesProvider` (same file); `favoritesRepositoryProvider` → `IFavoritesRepository` (`lib/features/favorites/data/repositories/favorites_repository_impl.dart`) with `Future<void> addFavorite(FavoriteItem item)` / `Future<void> removeFavorite({required String userId, required int mediaId, required MediaType mediaType})`; `authStateProvider` → `AsyncValue<User?>` (`lib/features/auth/ui/providers/auth_notifier.dart`, `User.id` is `String`); `FavoriteItem` entity (`lib/features/favorites/domain/entities/favorite_item.dart`: `id, userId, mediaId, mediaTitle, mediaType, posterPath?, createdAt`); `AppLogger.error(String message, {String? tag, Object? exception})` (`lib/core/utils/logger.dart`).
- Produces: `FavoriteButton` widget with constructor `FavoriteButton({Key? key, required int mediaId, required String mediaTitle, required MediaType mediaType, String? posterPath, double size = 32, bool hasBackground = true})`. Used by Task 2 (detail pages, `size: 44`) and Task 3 (grid badge, `size: 28`).

- [ ] **Step 1: Write the failing widget test**

```dart
// test/features/favorites/ui/widgets/favorite_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/favorites/ui/widgets/favorite_button.dart';
import 'package:filmania/features/favorites/ui/providers/favorites_providers.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';

Widget _buildSubject({bool isFavorite = false}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      isMediaFavoriteProvider(
        mediaId: 1,
        mediaType: MediaType.movie,
      ).overrideWith((ref) => Future.value(isFavorite)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: const Scaffold(
        body: Center(
          child: FavoriteButton(
            mediaId: 1,
            mediaTitle: 'Test Movie',
            mediaType: MediaType.movie,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows favorite_border_rounded when not favorited', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject(isFavorite: false));
    await tester.pump();
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsNothing);
  });

  testWidgets('shows favorite_rounded when favorited', (tester) async {
    await tester.pumpWidget(_buildSubject(isFavorite: true));
    await tester.pump();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/favorites/ui/widgets/favorite_button_test.dart`
Expected: FAIL — `Error: Couldn't resolve the package 'filmania' in 'package:filmania/features/favorites/ui/widgets/favorite_button.dart'` (file doesn't exist yet).

- [ ] **Step 3: Write the widget implementation**

```dart
// lib/features/favorites/ui/widgets/favorite_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../domain/entities/favorite_item.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../providers/favorites_providers.dart';

/// Icon-only toggle for adding/removing a movie or TV series from
/// favorites. Reused as a secondary action on detail pages and as the
/// removal badge on the Favorites grid.
class FavoriteButton extends ConsumerStatefulWidget {
  final int mediaId;
  final String mediaTitle;
  final MediaType mediaType;
  final String? posterPath;
  final double size;
  final bool hasBackground;

  const FavoriteButton({
    super.key,
    required this.mediaId,
    required this.mediaTitle,
    required this.mediaType,
    this.posterPath,
    this.size = 32,
    this.hasBackground = true,
  });

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton> {
  bool _isToggling = false;

  Future<void> _toggle(bool isFavorite, String? userId) async {
    if (userId == null || _isToggling) return;
    setState(() => _isToggling = true);

    final repo = ref.read(favoritesRepositoryProvider);
    try {
      if (isFavorite) {
        await repo.removeFavorite(
          userId: userId,
          mediaId: widget.mediaId,
          mediaType: widget.mediaType,
        );
      } else {
        await repo.addFavorite(
          FavoriteItem(
            id: '',
            userId: userId,
            mediaId: widget.mediaId,
            mediaTitle: widget.mediaTitle,
            mediaType: widget.mediaType,
            posterPath: widget.posterPath,
            createdAt: DateTime.now(),
          ),
        );
      }
      ref.invalidate(
        isMediaFavoriteProvider(
          mediaId: widget.mediaId,
          mediaType: widget.mediaType,
        ),
      );
      ref.invalidate(favoritesProvider);
    } catch (e) {
      AppLogger.error(
        'Favorite toggle failed',
        tag: 'FavoriteButton',
        exception: e,
      );
    } finally {
      if (mounted) setState(() => _isToggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final user = ref.watch(authStateProvider).value;
    final isFavoriteAsync = ref.watch(
      isMediaFavoriteProvider(
        mediaId: widget.mediaId,
        mediaType: widget.mediaType,
      ),
    );
    final isFavorite = isFavoriteAsync.value ?? false;

    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: widget.size,
        minHeight: widget.size,
        maxWidth: widget.size,
        maxHeight: widget.size,
      ),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: widget.hasBackground
            ? (isFavorite
                  ? colors.primary.withValues(alpha: 0.8)
                  : Colors.black.withValues(alpha: 0.3))
            : Colors.transparent,
        foregroundColor: (widget.hasBackground || !isFavorite)
            ? Colors.white
            : colors.primary,
        minimumSize: Size(widget.size, widget.size),
        fixedSize: Size(widget.size, widget.size),
        padding: EdgeInsets.zero,
      ),
      icon: _isToggling
          ? SizedBox(
              width: widget.size * 0.5,
              height: widget.size * 0.5,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: widget.size * 0.55,
            ),
      onPressed: _isToggling ? null : () => _toggle(isFavorite, user?.id),
      tooltip: isFavorite ? 'Rimuovi dai preferiti' : 'Aggiungi ai preferiti',
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/favorites/ui/widgets/favorite_button_test.dart`
Expected: PASS (2/2 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/features/favorites/ui/widgets/favorite_button.dart test/features/favorites/ui/widgets/favorite_button_test.dart
git commit -m "feat(favorites): add FavoriteButton toggle widget"
```

---

### Task 2: Wire `FavoriteButton` into movie and TV detail pages

**Files:**
- Modify: `lib/features/movies/ui/pages/movie_details_page.dart:64-83` (the `Column` containing `_WatchlistButton` and `WatchedButton`)
- Modify: `lib/features/tv_series/ui/pages/tv_series_details_page.dart:199-212` (same `Column` shape)
- Test: `test/features/movies/ui/pages/movie_details_page_test.dart` (new — no existing test file for this page)

**Interfaces:**
- Consumes: `FavoriteButton` from Task 1 (`lib/features/favorites/ui/widgets/favorite_button.dart`).
- Produces: nothing new consumed by later tasks — this is a leaf integration.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/movies/ui/pages/movie_details_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/favorites/ui/providers/favorites_providers.dart';
import 'package:filmania/features/watchlist/ui/providers/watchlist_providers.dart';
import 'package:filmania/features/watched/ui/providers/watched_providers.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/features/movies/ui/providers/movies_provider.dart';
import 'package:filmania/features/movies/ui/pages/movie_details_page.dart';

final _movie = Movie(
  id: 42,
  title: 'Test Movie',
  overview: 'overview',
  posterPath: null,
  backdropPath: null,
  releaseDate: null,
  voteAverage: 0,
  runtime: null,
);

Widget _buildSubject() {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      movieDetailsProvider(42).overrideWith((ref) async => _movie),
      isMediaFavoriteProvider(
        mediaId: 42,
        mediaType: MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
      isMediaInWatchlistProvider(
        42,
        MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
      isMediaWatchedProvider(
        mediaId: 42,
        mediaType: MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: const MovieDetailsPage(movieId: 42),
    ),
  );
}

void main() {
  testWidgets('shows a FavoriteButton (heart icon) on the detail page', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject());
    await tester.pump();
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/movies/ui/pages/movie_details_page_test.dart`
Expected: FAIL — `findsOneWidget` fails with 0 matches (no `FavoriteButton` on the page yet). If the `Movie` entity's constructor field list doesn't match, fix the test fixture to match the real `Movie` entity fields first (check `lib/features/movies/domain/entities/movie.dart`), then re-run to confirm it fails for the expected reason (missing heart icon, not a compile error).

- [ ] **Step 3: Add `FavoriteButton` to `movie_details_page.dart`**

Add the import near the other feature-widget imports (after the `WatchedButton` import at line 14):

```dart
import '../../../favorites/ui/widgets/favorite_button.dart';
```

Change the `Column` at lines 67-81 from:

```dart
              children: [
                _WatchlistButton(movie: movie),
                const SizedBox(height: AppSpacing.md),
                WatchedButton(
                  mediaId: movie.id,
                  mediaTitle: movie.title,
                  mediaType: MediaType.movie,
                  posterPath: movie.posterPath,
                  runtimeMinutes: movie.runtime,
                  isIconOnly: false,
                ),
              ],
```

to:

```dart
              children: [
                _WatchlistButton(movie: movie),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: WatchedButton(
                        mediaId: movie.id,
                        mediaTitle: movie.title,
                        mediaType: MediaType.movie,
                        posterPath: movie.posterPath,
                        runtimeMinutes: movie.runtime,
                        isIconOnly: false,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    FavoriteButton(
                      mediaId: movie.id,
                      mediaTitle: movie.title,
                      mediaType: MediaType.movie,
                      posterPath: movie.posterPath,
                      size: 44,
                    ),
                  ],
                ),
              ],
```

- [ ] **Step 4: Apply the same change to `tv_series_details_page.dart`**

Add the import after the `WatchedButton` import (line 21):

```dart
import '../../../favorites/ui/widgets/favorite_button.dart';
```

Change the `Column` at lines 199-211 from:

```dart
              children: [
                _WatchlistButton(series: series),
                const SizedBox(height: AppSpacing.md),
                WatchedButton(
                  mediaId: series.id,
                  mediaTitle: series.name,
                  mediaType: MediaType.tv,
                  posterPath: series.posterPath,
                  isIconOnly: false,
                ),
              ],
```

to:

```dart
              children: [
                _WatchlistButton(series: series),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: WatchedButton(
                        mediaId: series.id,
                        mediaTitle: series.name,
                        mediaType: MediaType.tv,
                        posterPath: series.posterPath,
                        isIconOnly: false,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    FavoriteButton(
                      mediaId: series.id,
                      mediaTitle: series.name,
                      mediaType: MediaType.tv,
                      posterPath: series.posterPath,
                      size: 44,
                    ),
                  ],
                ),
              ],
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/movies/ui/pages/movie_details_page_test.dart`
Expected: PASS (1/1 test).

- [ ] **Step 6: Run the full test suite to catch regressions**

Run: `flutter test`
Expected: all tests PASS, including `test/features/person/ui/pages/person_details_page_test.dart` and any other test that renders `MovieDetailsPage`/`TVSeriesDetailsPage` indirectly.

- [ ] **Step 7: Commit**

```bash
git add lib/features/movies/ui/pages/movie_details_page.dart lib/features/tv_series/ui/pages/tv_series_details_page.dart test/features/movies/ui/pages/movie_details_page_test.dart
git commit -m "feat(favorites): wire FavoriteButton into movie and TV detail pages"
```

---

### Task 3: `FavoritesPage`

**Files:**
- Create: `lib/features/favorites/ui/pages/favorites_page.dart`
- Test: `test/features/favorites/ui/pages/favorites_page_test.dart`

**Interfaces:**
- Consumes: `favoritesProvider` → `AsyncValue<List<FavoriteItem>>` (Task-1 dependency, already exists from 11a); `FavoriteButton` from Task 1 (badge mode: `size: 28, hasBackground: false` inside a `GlassOverlay` badge — the badge supplies its own background, so the button itself stays transparent); `AppRoutes.movieDetails` / `AppRoutes.tvDetails` (`lib/core/router/app_router.dart`) for card-tap navigation; `AppErrorView` (`lib/core/widgets/error_view.dart`); `GlassOverlay` (`lib/core/widgets/glass_overlay.dart`); `GlassmorphicAppBar` (`lib/core/widgets/glassmorphic_app_bar.dart`).
- Produces: `FavoritesPage` (`ConsumerWidget`, no constructor params) — consumed by Task 4 (routing).

- [ ] **Step 1: Write the failing test**

```dart
// test/features/favorites/ui/pages/favorites_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/favorites/domain/entities/favorite_item.dart';
import 'package:filmania/features/favorites/ui/providers/favorites_providers.dart';
import 'package:filmania/features/favorites/ui/pages/favorites_page.dart';

Widget _buildSubject(List<FavoriteItem> items) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      favoritesProvider.overrideWith((ref) => Stream.value(items)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: const FavoritesPage(),
    ),
  );
}

void main() {
  testWidgets('shows empty state when there are no favorites', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject(const []));
    await tester.pump();
    expect(find.text('Nessun preferito'), findsOneWidget);
  });

  testWidgets('shows one card per favorite item', (tester) async {
    final items = [
      FavoriteItem(
        id: '1',
        userId: 'u1',
        mediaId: 42,
        mediaTitle: 'Test Movie',
        mediaType: MediaType.movie,
        posterPath: null,
        createdAt: DateTime(2026, 1, 1),
      ),
      FavoriteItem(
        id: '2',
        userId: 'u1',
        mediaId: 7,
        mediaTitle: 'Test Series',
        mediaType: MediaType.tv,
        posterPath: null,
        createdAt: DateTime(2026, 1, 1),
      ),
    ];
    await tester.pumpWidget(_buildSubject(items));
    await tester.pump();
    expect(find.text('Test Movie'), findsOneWidget);
    expect(find.text('Test Series'), findsOneWidget);
    expect(find.text('Nessun preferito'), findsNothing);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/favorites/ui/pages/favorites_page_test.dart`
Expected: FAIL — `favorites_page.dart` doesn't exist yet (import error).

- [ ] **Step 3: Write `FavoritesPage`**

```dart
// lib/features/favorites/ui/pages/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/glass_overlay.dart';
import '../../../../core/widgets/glassmorphic_app_bar.dart';
import '../../domain/entities/favorite_item.dart';
import '../providers/favorites_providers.dart';
import '../widgets/favorite_button.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true, minimal: true),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height:
                  MediaQuery.of(context).padding.top +
                  kToolbarHeight +
                  AppSpacing.xl,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Preferiti',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  color: colors.onSurfacePrimary,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          favoritesAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: _FavoritesEmptyState(),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _FavoriteCard(item: items[index]),
                    childCount: items.length,
                  ),
                ),
              );
            },
            loading: () => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const _FavoriteShimmerCard(),
                  childCount: 4,
                ),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorView(
                error: err,
                onRetry: () => ref.invalidate(favoritesProvider),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: AppSpacing.xxxl * 2 + AppSpacing.sm + AppSpacing.xs,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteItem item;

  const _FavoriteCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final posterUrl = item.posterPath != null
        ? 'https://image.tmdb.org/t/p/w342${item.posterPath}'
        : null;

    return GestureDetector(
      onTap: () {
        final path = item.mediaType == MediaType.movie
            ? AppRoutes.movieDetails.replaceAll(':id', item.mediaId.toString())
            : AppRoutes.tvDetails.replaceAll(':id', item.mediaId.toString());
        context.push(path);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (posterUrl != null)
              CachedNetworkImage(
                imageUrl: posterUrl,
                fit: BoxFit.cover,
                memCacheWidth: 300,
                placeholder: (context, url) =>
                    Container(color: colors.surface.withValues(alpha: 0.2)),
                errorWidget: (context, url, err) =>
                    _FavoritePosterPlaceholder(colors: colors),
              )
            else
              _FavoritePosterPlaceholder(colors: colors),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.black.withValues(alpha: 0.1),
                    ],
                    stops: const [0.0, 0.6],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                item.mediaTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GlassOverlay(
                sigma: 10,
                borderRadius: BorderRadius.circular(10),
                color: colors.primary.withValues(alpha: 0.75),
                child: FavoriteButton(
                  mediaId: item.mediaId,
                  mediaTitle: item.mediaTitle,
                  mediaType: item.mediaType,
                  posterPath: item.posterPath,
                  size: 28,
                  hasBackground: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritePosterPlaceholder extends StatelessWidget {
  final AppColorScheme colors;
  const _FavoritePosterPlaceholder({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary.withValues(alpha: 0.3), colors.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.movie_filter_rounded,
          size: 40,
          color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _FavoriteShimmerCard extends StatelessWidget {
  const _FavoriteShimmerCard();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colors.surface.withValues(alpha: 0.05),
            colors.surface.withValues(alpha: 0.12),
            colors.surface.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class _FavoritesEmptyState extends StatelessWidget {
  const _FavoritesEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return GlassOverlay(
      borderRadius: BorderRadius.circular(24),
      color: colors.onSurfacePrimary.withValues(alpha: 0.05),
      sigma: 10,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 64,
              color: colors.onSurfacePrimary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Nessun preferito',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Aggiungi un film o una serie dalla pagina dettaglio per vederlo qui.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/favorites/ui/pages/favorites_page_test.dart`
Expected: PASS (2/2 tests).

- [ ] **Step 5: Commit**

```bash
git add lib/features/favorites/ui/pages/favorites_page.dart test/features/favorites/ui/pages/favorites_page_test.dart
git commit -m "feat(favorites): add FavoritesPage grid with quick-remove badge"
```

---

### Task 4: Routing

**Files:**
- Modify: `lib/core/router/app_router.dart`

**Interfaces:**
- Consumes: `FavoritesPage` from Task 3 (`lib/features/favorites/ui/pages/favorites_page.dart`).
- Produces: `AppRoutes.favorites = '/favorites'` — consumed by Task 5 (profile entry point).

- [ ] **Step 1: Add the import**

After line 17 (`import '../../features/watched/ui/pages/watched_list_page.dart';`):

```dart
import '../../features/favorites/ui/pages/favorites_page.dart';
```

- [ ] **Step 2: Add the route constant**

In `AppRoutes` (after `static const watchedTv = '/watched/tv';` at line 41):

```dart
  static const favorites = '/favorites';
```

- [ ] **Step 3: Register the standalone `GoRoute`**

After the `watchedTv` `GoRoute` block (lines 193-197), before `trendingMovies`:

```dart
      GoRoute(
        path: AppRoutes.favorites,
        builder: (context, state) => const FavoritesPage(),
      ),
```

- [ ] **Step 4: Verify the app still analyzes and builds**

Run: `dart analyze`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/router/app_router.dart
git commit -m "feat(favorites): register standalone /favorites route"
```

---

### Task 5: Profile entry point

**Files:**
- Modify: `lib/features/profile/ui/pages/profile_page.dart:376-543` (`_RecentActivitySection` and `_CategoryCard`)
- Test: none new — covered by manual verification in Step 4 (no existing test file for `profile_page.dart`, and generalizing `_CategoryCard`'s data param is a pure refactor with no new branching logic worth a dedicated unit test)

**Interfaces:**
- Consumes: `AppRoutes.favorites` from Task 4; `favoritesProvider` (`lib/features/favorites/ui/providers/favorites_providers.dart`).
- Produces: nothing consumed by later tasks — this is the final leaf integration.

- [ ] **Step 1: Add the import**

After line 12 (`import '../../../watched/domain/entities/watched_item.dart';`):

```dart
import '../../../favorites/ui/providers/favorites_providers.dart';
```

- [ ] **Step 2: Generalize `_CategoryCard` to accept poster paths instead of `WatchedItem`s**

`_CategoryCard` currently only needs `item.posterPath` from each `WatchedItem` (see `profile_page.dart:497-527`) — change its param from `List<WatchedItem> items` to `List<String?> posterPaths` so it works for favorites too, without adding a new near-duplicate widget.

Change the class declaration (lines 453-462) from:

```dart
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.items,
    required this.onTap,
  });

  final String title;
  final List<WatchedItem> items;
  final VoidCallback onTap;
```

to:

```dart
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.posterPaths,
    required this.onTap,
  });

  final String title;
  final List<String?> posterPaths;
  final VoidCallback onTap;
```

Change the body (lines 495-527) from:

```dart
        child: Stack(
          children: [
            if (items.isNotEmpty)
              Positioned.fill(
                child: Row(
                  children: items
                      .take(3)
                      .map(
                        (item) => Expanded(
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (item.posterPath != null)
                                  CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w200${item.posterPath}',
                                    fit: BoxFit.cover,
                                    memCacheWidth: 150,
                                  ),
                                Container(
                                  color: Colors.black.withValues(alpha: 0.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
```

to:

```dart
        child: Stack(
          children: [
            if (posterPaths.isNotEmpty)
              Positioned.fill(
                child: Row(
                  children: posterPaths
                      .take(3)
                      .map(
                        (posterPath) => Expanded(
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (posterPath != null)
                                  CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w200$posterPath',
                                    fit: BoxFit.cover,
                                    memCacheWidth: 150,
                                  ),
                                Container(
                                  color: Colors.black.withValues(alpha: 0.6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
```

- [ ] **Step 3: Update the two existing call sites**

In `_RecentActivitySection.build` (lines 391-399), change:

```dart
              child: asyncMovies.when(
                data: (movies) => _CategoryCard(
                  title: AppLocalizations.of(context)!.moviesTitle,
                  items: movies,
                  onTap: () => context.push(AppRoutes.watchedMovies),
                ),
                loading: () => const _CategoryCardPlaceholder(),
                error: (e, st) => const _CategoryCardPlaceholder(),
              ),
```

to:

```dart
              child: asyncMovies.when(
                data: (movies) => _CategoryCard(
                  title: AppLocalizations.of(context)!.moviesTitle,
                  posterPaths: movies.map((m) => m.posterPath).toList(),
                  onTap: () => context.push(AppRoutes.watchedMovies),
                ),
                loading: () => const _CategoryCardPlaceholder(),
                error: (e, st) => const _CategoryCardPlaceholder(),
              ),
```

And similarly (lines 403-411):

```dart
              child: asyncTv.when(
                data: (tv) => _CategoryCard(
                  title: AppLocalizations.of(context)!.tvSeriesTitle,
                  items: tv,
                  onTap: () => context.push(AppRoutes.watchedTv),
                ),
                loading: () => const _CategoryCardPlaceholder(),
                error: (e, st) => const _CategoryCardPlaceholder(),
              ),
```

to:

```dart
              child: asyncTv.when(
                data: (tv) => _CategoryCard(
                  title: AppLocalizations.of(context)!.tvSeriesTitle,
                  posterPaths: tv.map((t) => t.posterPath).toList(),
                  onTap: () => context.push(AppRoutes.watchedTv),
                ),
                loading: () => const _CategoryCardPlaceholder(),
                error: (e, st) => const _CategoryCardPlaceholder(),
              ),
```

- [ ] **Step 4: Add the third Favorites tile to the `Row`**

Change the `Row` in `_RecentActivitySection.build` (lines 388-414) from:

```dart
        Row(
          children: [
            Expanded(
              child: asyncMovies.when(
                data: (movies) => _CategoryCard(
                  title: AppLocalizations.of(context)!.moviesTitle,
                  posterPaths: movies.map((m) => m.posterPath).toList(),
                  onTap: () => context.push(AppRoutes.watchedMovies),
                ),
                loading: () => const _CategoryCardPlaceholder(),
                error: (e, st) => const _CategoryCardPlaceholder(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: asyncTv.when(
                data: (tv) => _CategoryCard(
                  title: AppLocalizations.of(context)!.tvSeriesTitle,
                  posterPaths: tv.map((t) => t.posterPath).toList(),
                  onTap: () => context.push(AppRoutes.watchedTv),
                ),
                loading: () => const _CategoryCardPlaceholder(),
                error: (e, st) => const _CategoryCardPlaceholder(),
              ),
            ),
          ],
        ),
```

to:

```dart
        Row(
          children: [
            Expanded(
              child: asyncMovies.when(
                data: (movies) => _CategoryCard(
                  title: AppLocalizations.of(context)!.moviesTitle,
                  posterPaths: movies.map((m) => m.posterPath).toList(),
                  onTap: () => context.push(AppRoutes.watchedMovies),
                ),
                loading: () => const _CategoryCardPlaceholder(),
                error: (e, st) => const _CategoryCardPlaceholder(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: asyncTv.when(
                data: (tv) => _CategoryCard(
                  title: AppLocalizations.of(context)!.tvSeriesTitle,
                  posterPaths: tv.map((t) => t.posterPath).toList(),
                  onTap: () => context.push(AppRoutes.watchedTv),
                ),
                loading: () => const _CategoryCardPlaceholder(),
                error: (e, st) => const _CategoryCardPlaceholder(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final asyncFavorites = ref.watch(favoritesProvider);
                  return asyncFavorites.when(
                    data: (favorites) => _CategoryCard(
                      title: 'Preferiti',
                      posterPaths: favorites
                          .map((f) => f.posterPath)
                          .toList(),
                      onTap: () => context.push(AppRoutes.favorites),
                    ),
                    loading: () => const _CategoryCardPlaceholder(),
                    error: (e, st) => const _CategoryCardPlaceholder(),
                  );
                },
              ),
            ),
          ],
        ),
```

- [ ] **Step 5: Run the full test suite and analyzer**

Run: `flutter test`
Expected: all tests PASS (no test file directly covers `profile_page.dart`, so this confirms nothing else broke).

Run: `dart analyze`
Expected: `No issues found!`

- [ ] **Step 6: Manual verification**

Run: `flutter run` (or `flutter run --profile`), log in, navigate to Profile tab. Confirm three tiles (Film / Serie TV / Preferiti) render side by side, tapping "Preferiti" navigates to `/favorites`, and the empty state shows if no favorites exist yet. Add a favorite from a movie detail page (tap the new heart icon), confirm the Preferiti tile poster collage and the Favorites page update.

- [ ] **Step 7: Commit**

```bash
git add lib/features/profile/ui/pages/profile_page.dart
git commit -m "feat(favorites): add Preferiti entry point tile to profile page"
```

---

## Self-Review Notes

- **Spec coverage:** Task 1 covers "icona cuore reattiva" shared logic; Task 2 covers "icona cuore reattiva nelle pagine dettaglio film/serie (stesso pattern del bookmark in `_WatchlistButton`)"; Task 3 covers "Pagina 'Preferiti' (griglia poster, stile watched_list_page.dart/watchlist_page.dart)"; Task 4+5 cover "raggiungibile da un punto coerente con la nav esistente... voce in profilo"; Task 1's `addFavorite`/`removeFavorite` wiring covers "Collega l'azione Aggiungi/rimuovi dai preferiti... a questa feature." All spec sections have a task.
- **Type consistency checked:** `FavoriteButton` constructor params (`mediaId, mediaTitle, mediaType, posterPath, size, hasBackground`) are identical across Task 1's definition and Task 2/3's call sites. `AppRoutes.favorites` is defined once in Task 4 and only referenced (not redefined) in Task 5.
- **No placeholders:** every step has complete, runnable code — no TBD/TODO markers.
