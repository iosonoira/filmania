# Discover Filters (Genre + Year Range) — Design

Date: 2026-07-02
Status: Implemented (manual UI smoke test outstanding — see plan Task 10)

## Problem

The Discover page (`lib/features/discover/ui/pages/discover_page.dart`) has a dead `Icons.tune_rounded` icon (line 218) with no `onTap`. Users cannot filter results by genre or release year, on either Movies or TV Series discover results.

## Goals

- Tapping the tune icon opens a bottom sheet to filter Discover results by genre (multi-select, OR logic) and release year (range).
- Filters apply only to the browse/discover query (`discoverMoviesProvider`/`discoverTVSeriesProvider`), not to text search.
- Movie and TV Series filters are independent state — switching the Film/Serie TV tab does not reset the other tab's filters.
- Visual indicator (badge) on the tune icon when the active tab has filters applied.

## Non-Goals

- Search-query filtering (only the empty-query discover browse path is affected).
- Persisting filter state across app restarts.
- Sort-order controls (existing `sort_by=popularity.desc` is unchanged).
- AND-logic genre combination (explicitly OR per design decision below).

## Architecture

### Shared entity: Genre

New shared domain entity, following the existing `CastMember` pattern (`core/domain/entities/cast_member.dart`):

- `lib/core/domain/entities/genre.dart`: `@freezed class Genre { int id; String name; }`
- `lib/core/data/models/genre_dto.dart`: `@freezed @JsonSerializable class GenreDto` with `toEntity()`.

Movies and TV Series genre catalogs are fetched from separate TMDB endpoints but share this identical shape — one entity avoids duplication.

### Datasource layer

`IMoviesRemoteDataSource` / `ITVSeriesRemoteDataSource` (and their impls) each gain:

```dart
Future<List<GenreDto>> getGenres();
```

- Movies: GET `genre/movie/list`, parse `response.data['genres']`.
- TV: GET `genre/tv/list`, parse `response.data['genres']`.

`discoverMovies` / `discoverTVSeries` signatures extend from `({int page = 1})` to:

```dart
Future<List<MovieDto>> discoverMovies({
  int page = 1,
  List<int> genreIds = const [],
  int? yearFrom,
  int? yearTo,
});
```

Query params built conditionally:

- `with_genres`: `genreIds.join('|')` when `genreIds.isNotEmpty` (pipe = OR, per TMDB discover semantics).
- Movies: `primary_release_date.gte`: `'$yearFrom-01-01'` when `yearFrom != null`; `primary_release_date.lte`: `'$yearTo-12-31'` when `yearTo != null`.
- TV: `first_air_date.gte`: `'$yearFrom-01-01'` when set; `first_air_date.lte`: `'$yearTo-12-31'` when set.
- `page` and `sort_by` unchanged.

`IMoviesRepository` / `ITVSeriesRepository` and their impls mirror this signature exactly (pure passthrough, no mapping logic beyond DTO→entity on the result list). Both also gain:

```dart
Future<List<Genre>> getGenres();
```

### Providers

`movies_provider.dart` / `tv_series_provider.dart` add:

```dart
@Riverpod(keepAlive: true)
Future<List<Genre>> movieGenres(Ref ref) =>
    ref.watch(moviesRepositoryProvider).getGenres();
```

(and the `tvGenres` equivalent). `keepAlive: true` because the genre list is static reference data, fetched once per session — same rationale as `tvSeriesDetails`/`seasonEpisodes` in the existing file.

`DiscoverMovies` / `DiscoverTVSeries` family providers extend from `build({int page = 1})` to:

```dart
FutureOr<List<Movie>> build({
  int page = 1,
  String genreIds = '',
  int? yearFrom,
  int? yearTo,
}) async {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.discoverMovies(
    page: page,
    genreIds: genreIds.isEmpty
        ? const []
        : genreIds.split(',').map(int.parse).toList(),
    yearFrom: yearFrom,
    yearTo: yearTo,
  );
}
```

**Why `String genreIds` and not `Set<int>`/`List<int>` as the family param:** Riverpod-generated family providers key their cache/equality on `==` of each argument. Dart's built-in `Set`/`List` do not override `==` with structural equality — two different instances with identical contents compare unequal, silently breaking provider memoization and causing redundant rebuilds/fetches. A canonical sorted, comma-joined `String` (e.g. `"12,28"`) has natural value equality and sidesteps this without pulling in an immutable-collections dependency. The string is only a family-key encoding; the repository/datasource layer underneath keeps the idiomatic `List<int> genreIds` signature.

### Filter state (`discover_providers.dart`)

```dart
@freezed
abstract class DiscoverFilters with _$DiscoverFilters {
  const factory DiscoverFilters({
    @Default(<int>{}) Set<int> genreIds,
    int? yearFrom,
    int? yearTo,
  }) = _DiscoverFilters;

  const DiscoverFilters._();

  bool get isActive => genreIds.isNotEmpty || yearFrom != null || yearTo != null;

  String get genreIdsKey => (genreIds.toList()..sort()).join(',');
}
```

Two independent notifiers, `MovieDiscoverFilters` and `TVDiscoverFilters` (both `@riverpod`, default build `const DiscoverFilters()`), each with:

- `void toggleGenre(int id)` — add/remove from the `genreIds` set.
- `void setYearRange(int? from, int? to)`.
- `void clear()` — reset to `const DiscoverFilters()`.

Kept as two separate notifiers (not one keyed by `DiscoverMediaType`) because movie and TV genre catalogs have different id→name mappings; a shared `Set<int>` of genre ids would be ambiguous across tabs. Year range semantics are identical across both, but sharing state there while splitting genre state would be inconsistent, so both fields live in the same per-type notifier.

`discover_page.dart` reads the active notifier based on `selectedMediaTypeProvider` and feeds `filters.genreIdsKey`, `filters.yearFrom`, `filters.yearTo` into `discoverMoviesProvider(...)`/`discoverTVSeriesProvider(...)`.

## UI

### Tune icon (discover_page.dart:218)

Wrapped in `GestureDetector`:

```dart
GestureDetector(
  onTap: () => _showFiltersSheet(context, ref, selectedMediaType),
  child: Stack(
    clipBehavior: Clip.none,
    children: [
      Icon(Icons.tune_rounded, color: colors.onSurfaceSecondary),
      if (isActive)
        Positioned(
          top: -2, right: -2,
          child: Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
          ),
        ),
    ],
  ),
)
```

`isActive` reads `ref.watch` on the notifier matching `selectedMediaType`.

### Filters bottom sheet

`_showFiltersSheet` follows the exact `showModalBottomSheet` pattern already established in `settings_page.dart`'s `_showThemePicker`/`_showLanguagePicker`: `backgroundColor: Colors.transparent`, content `Container` with `AppColors.of(context).background`, `BorderRadius.vertical(top: Radius.circular(AppSpacing.radius))`, `padding: AppSpacing.xl`.

Sheet contents (private widgets added to `discover_page.dart`, matching that file's existing convention of page-local private widgets rather than a shared widgets file):

- `_FiltersSheetHeader`: title "Filtri" + "Cancella filtri" `TextButton`, visible only when `filters.isActive`, calls `.clear()` on the active notifier.
- `_GenreFilterSection` (`ConsumerWidget`): `Wrap` of `_GenreChip`s sourced from `movieGenresProvider`/`tvGenresProvider` `.when(...)`; each chip tap calls `toggleGenre(id)` on the active notifier — selection re-renders immediately (same tap-and-live-update UX as the theme/language pickers), no separate "Apply" button needed since the sheet's `ref.watch` calls cascade into `discoverMoviesProvider`/`discoverTVSeriesProvider` automatically.
- `_YearRangeFilterSection`: `StatefulWidget` wrapping a `RangeSlider` (`min: 1950`, `max: <current year>`, `divisions: <current year> - 1950`). Local `State` holds live `RangeValues` for smooth dragging + label display; `onChangeEnd` commits to `setYearRange` on the notifier (avoids firing a network request per drag pixel). Label shows `"$yearFrom – $yearTo"` or `"Qualsiasi periodo"` when untouched (full range = no filter, encoded as `null`/`null` on commit if values equal the slider bounds).

All new widgets kept under the 50-line `build()` cap per project code standards; text is hardcoded Italian (no l10n) matching `discover_page.dart`'s existing convention (that file has zero l10n usage already — 'Discover', 'Nessun risultato trovato', etc.).

## Error Handling

No new failure paths — filtered queries go through the same `discoverMoviesProvider()`/`discoverTVSeriesProvider()` family already wired to `AppErrorView` with retry (`discover_page.dart:334-346`). A bad/empty TMDB response for a filter combination surfaces as the existing empty-state ("Nessun risultato trovato"), not an error.

## Testing

- Unit tests on `MoviesRemoteDataSourceImpl.discoverMovies` / `TVSeriesRemoteDataSourceImpl.discoverTVSeries`: verify exact query param names/values for genre-only, year-only, and combined filter cases — this is the highest-risk area since a wrong TMDB param name fails silently (API just ignores unknown params and returns unfiltered results).
- Unit test on `DiscoverFilters.genreIdsKey` / `isActive` — sorting and activity-detection logic.
- No new widget tests for the bottom sheet itself (scope-limited per YAGNI; existing `dart analyze` + manual verification cover the UI wiring).

## Files Touched

1. `lib/core/domain/entities/genre.dart` (new)
2. `lib/core/data/models/genre_dto.dart` (new)
3. `lib/features/movies/data/datasources/i_movies_remote_datasource.dart`
4. `lib/features/movies/data/datasources/movies_remote_datasource_impl.dart`
5. `lib/features/movies/domain/repositories/i_movies_repository.dart`
6. `lib/features/movies/data/repositories/movies_repository_impl.dart`
7. `lib/features/movies/ui/providers/movies_provider.dart`
8. `lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart`
9. `lib/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart`
10. `lib/features/tv_series/domain/repositories/i_tv_series_repository.dart`
11. `lib/features/tv_series/data/repositories/tv_series_repository_impl.dart`
12. `lib/features/tv_series/ui/providers/tv_series_provider.dart`
13. `lib/features/discover/ui/providers/discover_providers.dart`
14. `lib/features/discover/ui/pages/discover_page.dart`

Plus generated files (`*.freezed.dart`, `*.g.dart`) via `dart run build_runner build --delete-conflicting-outputs`.
