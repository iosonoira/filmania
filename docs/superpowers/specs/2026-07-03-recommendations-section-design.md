# Recommendations Section — Design Spec

Date: 2026-07-03

## Goal

Add a "Consigliati" / "Ti potrebbe piacere" section to `movie_details_page.dart` and `tv_series_details_page.dart`, backed by TMDB `movie/{id}/recommendations` and `tv/{id}/recommendations`.

## Scope

- Single TMDB page fetch (page 1), no pagination/load-more.
- Section hides entirely (renders nothing) on empty results, loading, or error — matches existing `CastSection` silent-fail convention.
- Tap on a recommended item pushes a new details page of the same media type (stack push, not replace).
- No new entities/DTOs — reuses `Movie`, `TVSeries`, `MovieDto`, `TvSeriesDto`.

## Data Layer

### Movies

`lib/features/movies/data/datasources/i_movies_remote_datasource.dart`
```dart
Future<List<MovieDto>> getMovieRecommendations(int movieId);
```

`lib/features/movies/data/datasources/movies_remote_datasource_impl.dart` — same try/on DioException → `NetworkFailure.fromDioException(e)` pattern as every other method:
```dart
@override
Future<List<MovieDto>> getMovieRecommendations(int movieId) async {
  try {
    final response = await _client.get('movie/$movieId/recommendations');
    final results = response.data['results'] as List<dynamic>;
    return results.map((json) => MovieDto.fromJson(json)).toList();
  } on DioException catch (e) {
    throw NetworkFailure.fromDioException(e);
  }
}
```

### TV Series

Same shape, `ITVSeriesRemoteDataSource.getTVSeriesRecommendations(int tvId)`, endpoint `tv/$tvId/recommendations`, returns `List<TvSeriesDto>`.

## Domain Layer

`IMoviesRepository.getMovieRecommendations(int movieId) → Future<List<Movie>>`
`ITVSeriesRepository.getTVSeriesRecommendations(int tvId) → Future<List<TVSeries>>`

Repository impls map dtos → entities via existing `toEntity()` extensions:
```dart
@override
Future<List<Movie>> getMovieRecommendations(int movieId) async {
  final dtos = await _remoteDataSource.getMovieRecommendations(movieId);
  return dtos.map((d) => d.toEntity()).toList();
}
```

## Providers

`lib/features/movies/ui/providers/movies_provider.dart`:
```dart
@riverpod
Future<List<Movie>> movieRecommendations(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieRecommendations(movieId);
}
```

`lib/features/tv_series/ui/providers/tv_series_provider.dart`:
```dart
@riverpod
Future<List<TVSeries>> tvSeriesRecommendations(Ref ref, int tvId) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVSeriesRecommendations(tvId);
}
```

Both plain `@riverpod` (autodispose family), matching `movieCredits`.

## UI Layer

### Shared widget

New `lib/core/widgets/recommendations_section.dart`, parallel to `cast_section.dart` but generic (not typed to a specific entity) so both features reuse it:

```dart
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

Height 220 to fit `MediaGridCard` poster aspect ratio (~0.7) at width 140 plus title/year text.

New l10n keys, added to `.arb` files following existing `castTitle` pattern:
- `recommendedMoviesTitle` = "Consigliati per te" (it) / "Recommended for you" (en)
- `recommendedSeriesTitle` = "Ti potrebbe piacere anche" (it) / "You might also like" (en)

### movie_details_page.dart

New private widget `_MovieRecommendationsSection`, same shape as `_MovieCastSection`:

```dart
class _MovieRecommendationsSection extends ConsumerWidget {
  final int movieId;
  const _MovieRecommendationsSection({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationsAsync = ref.watch(movieRecommendationsProvider(movieId));
    return recommendationsAsync.when(
      data: (movies) => RecommendationsSection(
        title: l10n.recommendedMoviesTitle,
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

Placed as the last sliver in `_MovieDetailsContent.build`, directly after `_MovieCastSection`, before the bottom spacer.

### tv_series_details_page.dart

Symmetric `_TVSeriesRecommendationsSection`, watches `tvSeriesRecommendationsProvider(seriesId)`, uses `MediaGridCard.tv(tv: ..., onTap: () => context.push(AppRoutes.tvSeriesDetails...))`.

Placed after `EpisodesSection`, before the bottom spacer (last content sliver).

## Routing

No new routes. Uses existing `AppRoutes.movieDetails` / TV details route constants with `context.push` (stack push, per confirmed requirement — enables back navigation and hero animation continuity).

## Testing

- `test/core/widgets/recommendations_section_test.dart`: copy `cast_section_test.dart` pattern — wrap in `GoRouter` with a destination route, tap an item, assert navigation occurred. Since `RecommendationsSection` is generic (itemBuilder-based), test with simple tappable placeholder widgets rather than real `MediaGridCard`.
- Datasource/repository/provider layers: **no new tests added**, matching existing gap for the credits feature (confirmed zero coverage at those layers in current codebase — not introducing a new pattern here).

## Out of scope

- Pagination / infinite scroll.
- "See all recommendations" page.
- Non-empty custom empty-state UI (section just hides).
