# Recommendations Section Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a "Consigliati" horizontal section to movie and TV series details pages, backed by TMDB `movie/{id}/recommendations` and `tv/{id}/recommendations`.

**Architecture:** Extend the existing datasource → repository → provider → UI chain (the same one `getMovieCredits`/`getTVSeriesCredits` uses) with a parallel `getMovieRecommendations`/`getTVSeriesRecommendations` path. No new entities/DTOs — reuses `Movie`/`TVSeries`/`MovieDto`/`TvSeriesDto`. A new shared, generic `RecommendationsSection` widget (parallel to `CastSection`) renders the horizontal list using the existing `MediaGridCard` widget.

**Tech Stack:** Flutter, Riverpod 3.0 (`@riverpod` codegen), Dio, GoRouter, Freezed/JsonSerializable (no changes needed to these here).

## Global Constraints

- Page 1 of TMDB results only — no pagination/load-more (per spec).
- Section renders nothing (`SizedBox.shrink()`) on empty, loading, or error state — matches `CastSection`/`_MovieCastSection` convention, never blocks the rest of the page.
- Tapping a recommended item does `context.push` to a new details page of the same media type (stack push, not replace).
- No new DTOs — reuse `MovieDto`/`TvSeriesDto` and their existing `toEntity()` mappers.
- No new tests added at datasource/repository/provider layers — this matches the existing zero-coverage gap for `getMovieCredits`/`getTVSeriesCredits` at those layers (confirmed in spec); only the new `RecommendationsSection` widget gets a test, using the `test/core/widgets/cast_section_test.dart` pattern.
- Cross-feature import of `MediaGridCard` (`lib/features/discover/ui/widgets/discover_widgets.dart`) from `movies`/`tv_series` features is acceptable — `lib/features/person/ui/pages/person_details_page.dart` already imports it, establishing precedent despite the general "no cross-feature imports" rule in CLAUDE.md.
- Route path constant for TV details is `AppRoutes.tvDetails` (`/tv/:id`), not `tvSeriesDetails` — verify against `lib/core/router/app_router.dart:37`.
- After every provider/riverpod-annotated change: run `dart run build_runner build --delete-conflicting-outputs`.
- After l10n `.arb` changes: run `flutter gen-l10n` (project has `generate: true` in `pubspec.yaml:40`).

---

### Task 1: Movie recommendations — datasource, repository, provider

**Files:**
- Modify: `lib/features/movies/data/datasources/i_movies_remote_datasource.dart`
- Modify: `lib/features/movies/data/datasources/movies_remote_datasource_impl.dart`
- Modify: `lib/features/movies/domain/repositories/i_movies_repository.dart`
- Modify: `lib/features/movies/data/repositories/movies_repository_impl.dart`
- Modify: `lib/features/movies/ui/providers/movies_provider.dart`

**Interfaces:**
- Produces: `IMoviesRemoteDataSource.getMovieRecommendations(int movieId) → Future<List<MovieDto>>`
- Produces: `IMoviesRepository.getMovieRecommendations(int movieId) → Future<List<Movie>>`
- Produces: `movieRecommendationsProvider(int movieId) → AsyncValue<List<Movie>>` (Riverpod family provider, generated as `movieRecommendationsProvider` in `movies_provider.g.dart`)

- [ ] **Step 1: Add method to `IMoviesRemoteDataSource`**

Edit `lib/features/movies/data/datasources/i_movies_remote_datasource.dart` — add one line after `getMovieCredits`:

```dart
abstract interface class IMoviesRemoteDataSource {
  Future<List<MovieDto>> getTrendingMovies({int page = 1});
  Future<List<MovieDto>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<MovieDto> getMovieDetails(int movieId);
  Future<List<MovieDto>> searchMovies(String query, {int page = 1});
  Future<CreditsDto> getMovieCredits(int movieId);
  Future<List<MovieDto>> getMovieRecommendations(int movieId);
  Future<List<GenreDto>> getGenres();
}
```

- [ ] **Step 2: Implement it in `MoviesRemoteDataSourceImpl`**

Edit `lib/features/movies/data/datasources/movies_remote_datasource_impl.dart` — insert a new method right after `getMovieCredits` (after line 103, before `getGenres`):

```dart
  @override
  Future<List<MovieDto>> getMovieRecommendations(int movieId) async {
    try {
      final response = await _client.get('movie/$movieId/recommendations');
      final List<dynamic> results = response.data['results'];
      return results.map((json) => MovieDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
```

- [ ] **Step 3: Add method to `IMoviesRepository`**

Edit `lib/features/movies/domain/repositories/i_movies_repository.dart`:

```dart
abstract class IMoviesRepository {
  Future<List<Movie>> getTrendingMovies({int page = 1});
  Future<List<Movie>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<Movie> getMovieDetails(int movieId);
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<Credits> getMovieCredits(int movieId);
  Future<List<Movie>> getMovieRecommendations(int movieId);
  Future<List<Genre>> getGenres();
}
```

- [ ] **Step 4: Implement it in `MoviesRepositoryImpl`**

Edit `lib/features/movies/data/repositories/movies_repository_impl.dart` — insert after `getMovieCredits` (after line 56, before `getGenres`):

```dart
  @override
  Future<List<Movie>> getMovieRecommendations(int movieId) async {
    final dtos = await _remoteDataSource.getMovieRecommendations(movieId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
```

- [ ] **Step 5: Add the provider**

Edit `lib/features/movies/ui/providers/movies_provider.dart` — insert after `movieCredits` (after line 57, before `movieGenres`):

```dart
@riverpod
Future<List<Movie>> movieRecommendations(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieRecommendations(movieId);
}
```

- [ ] **Step 6: Regenerate code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes with no errors; `movies_provider.g.dart` now contains `movieRecommendationsProvider`.

- [ ] **Step 7: Verify statically**

Run: `dart analyze lib/features/movies`
Expected: `No issues found!`

- [ ] **Step 8: Commit**

```bash
git add lib/features/movies/data/datasources/i_movies_remote_datasource.dart lib/features/movies/data/datasources/movies_remote_datasource_impl.dart lib/features/movies/domain/repositories/i_movies_repository.dart lib/features/movies/data/repositories/movies_repository_impl.dart lib/features/movies/ui/providers/movies_provider.dart lib/features/movies/ui/providers/movies_provider.g.dart
git commit -m "feat: add movie recommendations datasource/repository/provider"
```

---

### Task 2: TV series recommendations — datasource, repository, provider

**Files:**
- Modify: `lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart`
- Modify: `lib/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart`
- Modify: `lib/features/tv_series/domain/repositories/i_tv_series_repository.dart`
- Modify: `lib/features/tv_series/data/repositories/tv_series_repository_impl.dart`
- Modify: `lib/features/tv_series/ui/providers/tv_series_provider.dart`

**Interfaces:**
- Consumes: nothing from Task 1 (fully symmetric, independent path).
- Produces: `ITVSeriesRemoteDataSource.getTVSeriesRecommendations(int tvId) → Future<List<TVSeriesDto>>`
- Produces: `ITVSeriesRepository.getTVSeriesRecommendations(int tvId) → Future<List<TVSeries>>`
- Produces: `tvSeriesRecommendationsProvider(int tvId) → AsyncValue<List<TVSeries>>`

- [ ] **Step 1: Add method to `ITVSeriesRemoteDataSource`**

Edit `lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart` — add after `getTVSeriesCredits`/`getTVEpisodeCredits`, before `getGenres`:

```dart
abstract class ITVSeriesRemoteDataSource {
  Future<List<TVSeriesDto>> getTrendingTVSeries({int page = 1});
  Future<List<TVSeriesDto>> discoverTVSeries({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<TVSeriesDto> getTVSeriesDetails(int tvId);
  Future<List<TVSeriesDto>> searchTVSeries(String query, {int page = 1});
  Future<List<TVEpisodeDto>> getSeasonEpisodes(int tvId, int seasonNumber);
  Future<TVEpisodeDto> getTVEpisodeDetails(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  );
  Future<CreditsDto> getTVSeriesCredits(int tvId);
  Future<List<CastMemberDto>> getTVEpisodeCredits(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  );
  Future<List<TVSeriesDto>> getTVSeriesRecommendations(int tvId);
  Future<List<GenreDto>> getGenres();
}
```

- [ ] **Step 2: Implement it in `TVSeriesRemoteDataSourceImpl`**

Edit `lib/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart` — insert after `getTVEpisodeCredits` (after line 152), before `getGenres`:

```dart
  @override
  Future<List<TVSeriesDto>> getTVSeriesRecommendations(int tvId) async {
    try {
      final response = await _client.get('tv/$tvId/recommendations');
      final List<dynamic> results = response.data['results'];
      return results.map((json) => TVSeriesDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
```

- [ ] **Step 3: Add method to `ITVSeriesRepository`**

Edit `lib/features/tv_series/domain/repositories/i_tv_series_repository.dart`:

```dart
abstract class ITVSeriesRepository {
  Future<List<TVSeries>> getTrendingTVSeries({int page = 1});
  Future<List<TVSeries>> discoverTVSeries({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<TVSeries> getTVSeriesDetails(int tvId);
  Future<List<TVSeries>> searchTVSeries(String query, {int page = 1});
  Future<List<TVEpisode>> getSeasonEpisodes(int tvId, int seasonNumber);
  Future<TVEpisode> getTVEpisodeDetails(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  );
  Future<Credits> getTVSeriesCredits(int tvId);
  Future<List<CastMember>> getTVEpisodeCredits(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  );
  Future<List<TVSeries>> getTVSeriesRecommendations(int tvId);
  Future<List<Genre>> getGenres();
}
```

- [ ] **Step 4: Implement it in `TVSeriesRepositoryImpl`**

Edit `lib/features/tv_series/data/repositories/tv_series_repository_impl.dart` — insert after `getTVEpisodeCredits` (after line 91), before `getGenres`:

```dart
  @override
  Future<List<TVSeries>> getTVSeriesRecommendations(int tvId) async {
    final dtos = await _remoteDataSource.getTVSeriesRecommendations(tvId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
```

- [ ] **Step 5: Add the provider**

Edit `lib/features/tv_series/ui/providers/tv_series_provider.dart` — insert after `tvEpisodeCredits` (after line 94), before `tvGenres`:

```dart
@riverpod
Future<List<TVSeries>> tvSeriesRecommendations(Ref ref, int tvId) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVSeriesRecommendations(tvId);
}
```

Note: plain `@riverpod` (autodispose), not `@Riverpod(keepAlive: true)` like most of this file — matches `movieRecommendations` in Task 1, and there's no need to keep a paginated recommendations list alive across navigations.

- [ ] **Step 6: Regenerate code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes with no errors; `tv_series_provider.g.dart` now contains `tvSeriesRecommendationsProvider`.

- [ ] **Step 7: Verify statically**

Run: `dart analyze lib/features/tv_series`
Expected: `No issues found!`

- [ ] **Step 8: Commit**

```bash
git add lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart lib/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart lib/features/tv_series/domain/repositories/i_tv_series_repository.dart lib/features/tv_series/data/repositories/tv_series_repository_impl.dart lib/features/tv_series/ui/providers/tv_series_provider.dart lib/features/tv_series/ui/providers/tv_series_provider.g.dart
git commit -m "feat: add TV series recommendations datasource/repository/provider"
```

---

### Task 3: Add l10n strings

**Files:**
- Modify: `lib/core/l10n/arb/app_it.arb`
- Modify: `lib/core/l10n/arb/app_en.arb`

**Interfaces:**
- Produces: `AppLocalizations.recommendedMoviesTitle`, `AppLocalizations.recommendedSeriesTitle` (generated getters, used by Task 4/5/6).

- [ ] **Step 1: Add Italian strings**

Edit `lib/core/l10n/arb/app_it.arb` — insert after line 82 (`"crewTitle": "Staff",`):

```json
  "recommendedMoviesTitle": "Consigliati per te",
  "recommendedSeriesTitle": "Ti potrebbe piacere anche",
```

- [ ] **Step 2: Add English strings**

Edit `lib/core/l10n/arb/app_en.arb` — insert after the equivalent `"crewTitle": "Crew",` line:

```json
  "recommendedMoviesTitle": "Recommended for you",
  "recommendedSeriesTitle": "You might also like",
```

- [ ] **Step 3: Regenerate localizations**

Run: `flutter gen-l10n`
Expected: completes with no errors; `lib/core/l10n/generated/app_localizations.dart` (and per-locale files) now expose `recommendedMoviesTitle`/`recommendedSeriesTitle` getters.

- [ ] **Step 4: Verify statically**

Run: `dart analyze lib/core/l10n`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/l10n/arb/app_it.arb lib/core/l10n/arb/app_en.arb lib/core/l10n/generated/
git commit -m "feat: add l10n strings for recommendations section"
```

---

### Task 4: Shared `RecommendationsSection` widget

**Files:**
- Create: `lib/core/widgets/recommendations_section.dart`
- Test: `test/core/widgets/recommendations_section_test.dart`

**Interfaces:**
- Consumes: nothing (no domain/provider dependency — pure presentational widget, same as `CastSection`).
- Produces: `RecommendationsSection({required String title, required int itemCount, required IndexedWidgetBuilder itemBuilder})` — a `StatelessWidget`. Used by Task 5 and Task 6.

- [ ] **Step 1: Write the failing widget test**

Create `test/core/widgets/recommendations_section_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/recommendations_section.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('hides when itemCount is zero', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: RecommendationsSection(
            title: 'Consigliati',
            itemCount: 0,
            itemBuilder: _unusedBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Consigliati'), findsNothing);
  });

  testWidgets('renders title and tapping an item navigates', (tester) async {
    final router = GoRouter(
      initialLocation: '/movie/1',
      routes: [
        GoRoute(
          path: '/movie/1',
          builder: (context, state) => Scaffold(
            body: RecommendationsSection(
              title: 'Consigliati',
              itemCount: 2,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => context.push('/movie/${index + 100}'),
                child: Text('Item $index'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/movie/:id',
          builder: (context, state) =>
              Scaffold(body: Text('Movie ${state.pathParameters['id']}')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pump();

    expect(find.text('Consigliati'), findsOneWidget);

    await tester.tap(find.text('Item 0'));
    await tester.pumpAndSettle();

    expect(find.text('Movie 100'), findsOneWidget);
  });
}

Widget _unusedBuilder(BuildContext context, int index) => const SizedBox();
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/recommendations_section_test.dart`
Expected: FAIL — `Error: Couldn't resolve the package 'filmania' in 'package:filmania/core/widgets/recommendations_section.dart'` (file doesn't exist yet).

- [ ] **Step 3: Implement `RecommendationsSection`**

Create `lib/core/widgets/recommendations_section.dart`:

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RecommendationsSection extends StatelessWidget {
  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const RecommendationsSection({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 220,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: itemCount,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.md),
            itemBuilder: itemBuilder,
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/recommendations_section_test.dart`
Expected: PASS (`00:0X +2: All tests passed!`)

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/recommendations_section.dart test/core/widgets/recommendations_section_test.dart
git commit -m "feat: add shared RecommendationsSection widget"
```

---

### Task 5: Wire recommendations into `movie_details_page.dart`

**Files:**
- Modify: `lib/features/movies/ui/pages/movie_details_page.dart`

**Interfaces:**
- Consumes: `movieRecommendationsProvider(int movieId)` (Task 1), `RecommendationsSection` (Task 4), `AppLocalizations.recommendedMoviesTitle` (Task 3), `MediaGridCard.movie({required Movie movie, VoidCallback? onTap})` (existing, `lib/features/discover/ui/widgets/discover_widgets.dart`), `AppRoutes.movieDetails` (existing, `lib/core/router/app_router.dart:36`).

- [ ] **Step 1: Add imports**

Edit `lib/features/movies/ui/pages/movie_details_page.dart` — insert 4 new import lines immediately after line 16 (`import 'package:filmania/core/widgets/crew_section.dart';`), before line 17 (`import 'package:filmania/core/l10n/generated/app_localizations.dart';`). Do not modify any other existing import lines.

```dart
import 'package:filmania/core/widgets/recommendations_section.dart';
import 'package:filmania/core/router/app_router.dart';
import 'package:filmania/features/discover/ui/widgets/discover_widgets.dart';
import 'package:go_router/go_router.dart';
```

- [ ] **Step 2: Insert the recommendations sliver**

Edit `lib/features/movies/ui/pages/movie_details_page.dart` — in `_MovieDetailsContent.build`, change:

```dart
        _MovieOverviewSection(overview: movie.overview),
        SliverToBoxAdapter(child: _MovieCastSection(movieId: movie.id)),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.xxxl + AppSpacing.xl + AppSpacing.xs,
          ),
        ),
```

to:

```dart
        _MovieOverviewSection(overview: movie.overview),
        SliverToBoxAdapter(child: _MovieCastSection(movieId: movie.id)),
        SliverToBoxAdapter(child: _MovieRecommendationsSection(movieId: movie.id)),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.xxxl + AppSpacing.xl + AppSpacing.xs,
          ),
        ),
```

- [ ] **Step 3: Add the `_MovieRecommendationsSection` widget**

Edit `lib/features/movies/ui/pages/movie_details_page.dart` — append after `_MovieCastSection` (end of file, after the closing `}` of `_MovieCastSection`):

```dart

class _MovieRecommendationsSection extends ConsumerWidget {
  final int movieId;

  const _MovieRecommendationsSection({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(
      movieRecommendationsProvider(movieId),
    );

    return recommendationsAsync.when(
      data: (movies) => RecommendationsSection(
        title: AppLocalizations.of(context)!.recommendedMoviesTitle,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return SizedBox(
            width: 140,
            child: MediaGridCard.movie(
              movie: movie,
              onTap: () => context.push(
                AppRoutes.movieDetails.replaceAll(':id', movie.id.toString()),
              ),
            ),
          );
        },
      ),
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
```

- [ ] **Step 4: Verify statically**

Run: `dart analyze lib/features/movies/ui/pages/movie_details_page.dart`
Expected: `No issues found!`

- [ ] **Step 5: Run existing movie details tests (if any) and full test suite sanity check**

Run: `flutter test test/core/widgets/recommendations_section_test.dart test/core/widgets/cast_section_test.dart`
Expected: PASS (confirms nothing broken by shared imports/router constants)

- [ ] **Step 6: Commit**

```bash
git add lib/features/movies/ui/pages/movie_details_page.dart
git commit -m "feat: show recommended movies on movie details page"
```

---

### Task 6: Wire recommendations into `tv_series_details_page.dart`

**Files:**
- Modify: `lib/features/tv_series/ui/pages/tv_series_details_page.dart`

**Interfaces:**
- Consumes: `tvSeriesRecommendationsProvider(int tvId)` (Task 2), `RecommendationsSection` (Task 4), `AppLocalizations.recommendedSeriesTitle` (Task 3), `MediaGridCard.tv({required TVSeries tv, VoidCallback? onTap})` (existing, `lib/features/discover/ui/widgets/discover_widgets.dart`), `AppRoutes.tvDetails` (existing, `lib/core/router/app_router.dart:37`).

- [ ] **Step 1: Add imports**

Edit `lib/features/tv_series/ui/pages/tv_series_details_page.dart` — insert 4 new import lines immediately after line 16 (`import 'package:filmania/core/widgets/crew_section.dart';`), before line 17 (`import '../../../watched/ui/widgets/watched_button.dart';`). Do not modify any other existing import lines.

```dart
import 'package:filmania/core/widgets/recommendations_section.dart';
import 'package:filmania/core/router/app_router.dart';
import 'package:filmania/features/discover/ui/widgets/discover_widgets.dart';
import 'package:go_router/go_router.dart';
```

- [ ] **Step 2: Insert the recommendations sliver after episodes**

Edit `lib/features/tv_series/ui/pages/tv_series_details_page.dart` — change:

```dart
        // Sezione episodi
        SliverToBoxAdapter(
          child: EpisodesSection(
            tvId: series.id,
            seasons: series.seasons,
            seriesTitle: series.name,
            seriesPosterPath: series.posterPath,
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.xxxl + AppSpacing.xl + AppSpacing.xs,
          ),
        ),
```

to:

```dart
        // Sezione episodi
        SliverToBoxAdapter(
          child: EpisodesSection(
            tvId: series.id,
            seasons: series.seasons,
            seriesTitle: series.name,
            seriesPosterPath: series.posterPath,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

        // Consigliati
        SliverToBoxAdapter(
          child: _TVSeriesRecommendationsSection(seriesId: series.id),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.xxxl + AppSpacing.xl + AppSpacing.xs,
          ),
        ),
```

- [ ] **Step 3: Add the `_TVSeriesRecommendationsSection` widget**

Edit `lib/features/tv_series/ui/pages/tv_series_details_page.dart` — append after `_TVSeriesCastSection` (end of file):

```dart

class _TVSeriesRecommendationsSection extends ConsumerWidget {
  final int seriesId;

  const _TVSeriesRecommendationsSection({required this.seriesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(
      tvSeriesRecommendationsProvider(seriesId),
    );

    return recommendationsAsync.when(
      data: (series) => RecommendationsSection(
        title: AppLocalizations.of(context)!.recommendedSeriesTitle,
        itemCount: series.length,
        itemBuilder: (context, index) {
          final tv = series[index];
          return SizedBox(
            width: 140,
            child: MediaGridCard.tv(
              tv: tv,
              onTap: () => context.push(
                AppRoutes.tvDetails.replaceAll(':id', tv.id.toString()),
              ),
            ),
          );
        },
      ),
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
```

- [ ] **Step 4: Verify statically**

Run: `dart analyze lib/features/tv_series/ui/pages/tv_series_details_page.dart`
Expected: `No issues found!`

- [ ] **Step 5: Run widget sanity tests**

Run: `flutter test test/core/widgets/recommendations_section_test.dart test/core/widgets/cast_section_test.dart test/core/widgets/crew_section_test.dart`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add lib/features/tv_series/ui/pages/tv_series_details_page.dart
git commit -m "feat: show recommended TV series on TV series details page"
```

---

### Task 7: Full verification pass

**Files:** none (verification only)

- [ ] **Step 1: Full static analysis**

Run: `dart analyze`
Expected: `No issues found!`

- [ ] **Step 2: Format check**

Run: `dart format --set-exit-if-changed .`
Expected: exit code 0, no files listed as needing formatting. If files are listed, run `dart format .` and re-commit.

- [ ] **Step 3: Full test suite**

Run: `flutter test`
Expected: all tests pass, including the two new tests in `test/core/widgets/recommendations_section_test.dart` and every pre-existing test (no regressions).

- [ ] **Step 4: Manual smoke test**

Run: `flutter run --profile` (or `flutter run` in debug), navigate to any movie details page and any TV series details page.
Expected:
- Movie details page shows "Consigliati per te" section after cast/crew, horizontally scrollable, posters tappable → pushes a new movie details page.
- TV series details page shows "Ti potrebbe piacere anche" section after the episodes section, same behavior for TV.
- If a title has no recommendations (rare, e.g. very obscure titles), the section area shows nothing — no visual gap or spinner.

- [ ] **Step 5: Commit (only if format step produced changes)**

```bash
git add -A
git commit -m "style: apply dart format"
```
