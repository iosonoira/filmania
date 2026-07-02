# Discover Filters (Genre + Year Range) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Wire the dead `Icons.tune_rounded` icon on the Discover page to a working genre (multi-select, OR) + release-year-range filter that modifies `discoverMoviesProvider`/`discoverTVSeriesProvider` queries, with a badge indicator when filters are active.

**Architecture:** Add a shared `Genre` entity/DTO; extend the movies/tv datasource, repository, and provider layers with `getGenres()` and filter params on `discoverMovies`/`discoverTVSeries`; add per-media-type `DiscoverFilters` state (`MovieDiscoverFilters`/`TvDiscoverFilters` notifiers) in the discover feature; wire a new bottom sheet into `discover_page.dart`.

**Tech Stack:** Flutter, Riverpod 3 (`@riverpod` codegen), Freezed, Dio, TMDB REST API.

**Full design doc:** `docs/superpowers/specs/2026-07-02-discover-filters-design.md`

## Global Constraints

- `@riverpod` code generator only — never `Provider(...)` manually. Every provider file needs `part 'file.g.dart';`; freezed classes need `part 'file.freezed.dart';`.
- `ref.watch` → inside `build()` only. `ref.read` → inside callbacks only.
- Colors via `AppColors.of(context)` only. Spacing via `AppSpacing` tokens only (8dp multiples). No raw `TextStyle` outside `core/theme/`.
- No-Line Rule: no 1px borders/dividers — use whitespace or tonal surface shifts (`colors.surface.withValues(alpha: ...)`).
- `build()` methods max 50 lines. No private helper methods returning `Widget` — extract to widget classes.
- Entities: `@freezed`, no mutation, `.copyWith()` only. DTOs: `@JsonSerializable` with a `toEntity()` method; mapping only happens in the repository layer.
- Effective Dart naming. TV-prefixed Riverpod-annotated classes/functions must spell it `Tv`/`tv` (lowercase v), not `TV`, when "Tv" is the first word — e.g. `TvDiscoverFilters`, `tvGenres` — otherwise `riverpod_generator` produces an ugly `tVFooProvider` (only the very first character gets lowercased). This matches the existing codebase convention (`tvSeriesDetails`, `tvEpisodeCredits` in `tv_series_provider.dart`).
- Riverpod family provider arguments must have natural value equality (`String`, `int`, `int?`, `bool`) — never pass a `Set`/`List` directly as a family arg; Dart collections don't override `==`, which silently breaks provider memoization.
- Run `dart run build_runner build --delete-conflicting-outputs` after every step that adds/changes a `@freezed` or `@riverpod` annotation, before running any test that imports the affected file.
- Run `dart analyze` at the end of every task; it must report "No issues found!" before moving on.

---

## File Structure

New files:
- `lib/core/domain/entities/genre.dart` — shared `Genre` entity (id, name).
- `lib/core/data/models/genre_dto.dart` — `GenreDto` + `toEntity()`.
- `test/core/data/models/genre_dto_test.dart`
- `test/features/movies/data/datasources/movies_query_params_test.dart`
- `test/features/tv_series/data/datasources/tv_series_query_params_test.dart`
- `test/features/discover/ui/providers/discover_filters_test.dart`

Modified files:
- `lib/features/movies/data/datasources/i_movies_remote_datasource.dart`, `movies_remote_datasource_impl.dart`
- `lib/features/movies/domain/repositories/i_movies_repository.dart`, `lib/features/movies/data/repositories/movies_repository_impl.dart`
- `lib/features/movies/ui/providers/movies_provider.dart`
- `lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart`, `tv_series_remote_datasource_impl.dart`
- `lib/features/tv_series/domain/repositories/i_tv_series_repository.dart`, `lib/features/tv_series/data/repositories/tv_series_repository_impl.dart`
- `lib/features/tv_series/ui/providers/tv_series_provider.dart`
- `lib/features/discover/ui/providers/discover_providers.dart`
- `lib/features/discover/ui/pages/discover_page.dart`

---

### Task 1: Shared Genre entity + DTO

**Files:**
- Create: `lib/core/domain/entities/genre.dart`
- Create: `lib/core/data/models/genre_dto.dart`
- Test: `test/core/data/models/genre_dto_test.dart`

**Interfaces:**
- Produces: `Genre({required int id, required String name})` (freezed entity); `GenreDto({required int id, required String name})` with `factory GenreDto.fromJson(Map<String, dynamic> json)` and `Genre toEntity()`.

Note: freezed classes require generated code to compile at all, so strict red-green TDD doesn't apply here (there is no way to run a test against code that can't compile yet). Implement, generate, then verify with a test — this is the pattern used for every freezed/riverpod-codegen task in this plan.

- [ ] **Step 1: Create the Genre entity**

```dart
// lib/core/domain/entities/genre.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre.freezed.dart';

@freezed
abstract class Genre with _$Genre {
  const factory Genre({
    required int id,
    required String name,
  }) = _Genre;
}
```

- [ ] **Step 2: Create the GenreDto**

```dart
// lib/core/data/models/genre_dto.dart
import 'package:filmania/core/domain/entities/genre.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre_dto.freezed.dart';
part 'genre_dto.g.dart';

@freezed
abstract class GenreDto with _$GenreDto {
  const factory GenreDto({
    required int id,
    required String name,
  }) = _GenreDto;

  factory GenreDto.fromJson(Map<String, dynamic> json) =>
      _$GenreDtoFromJson(json);

  const GenreDto._();

  Genre toEntity() => Genre(id: id, name: name);
}
```

- [ ] **Step 3: Run build_runner**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes with no errors; `genre.freezed.dart`, `genre_dto.freezed.dart`, `genre_dto.g.dart` are created.

- [ ] **Step 4: Write the verification test**

```dart
// test/core/data/models/genre_dto_test.dart
import 'package:filmania/core/data/models/genre_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GenreDto', () {
    test('fromJson parses id and name', () {
      final dto = GenreDto.fromJson({'id': 28, 'name': 'Azione'});

      expect(dto.id, 28);
      expect(dto.name, 'Azione');
    });

    test('toEntity maps to Genre with the same fields', () {
      const dto = GenreDto(id: 28, name: 'Azione');

      final entity = dto.toEntity();

      expect(entity.id, 28);
      expect(entity.name, 'Azione');
    });
  });
}
```

- [ ] **Step 5: Run the test**

Run: `flutter test test/core/data/models/genre_dto_test.dart`
Expected: `00:0X +2: All tests passed!`

- [ ] **Step 6: Commit**

```bash
git add lib/core/domain/entities/genre.dart lib/core/domain/entities/genre.freezed.dart lib/core/data/models/genre_dto.dart lib/core/data/models/genre_dto.freezed.dart lib/core/data/models/genre_dto.g.dart test/core/data/models/genre_dto_test.dart
git commit -m "feat: add shared Genre entity and DTO"
```

---

### Task 2: Movies datasource — query param builder + getGenres + discoverMovies filters

**Files:**
- Modify: `lib/features/movies/data/datasources/i_movies_remote_datasource.dart`
- Modify: `lib/features/movies/data/datasources/movies_remote_datasource_impl.dart`
- Test: `test/features/movies/data/datasources/movies_query_params_test.dart`

**Interfaces:**
- Consumes: `GenreDto` from Task 1 (`lib/core/data/models/genre_dto.dart`).
- Produces: `buildMovieDiscoverQueryParams({required int page, List<int> genreIds = const [], int? yearFrom, int? yearTo}) → Map<String, dynamic>` (top-level, `@visibleForTesting`, in `movies_remote_datasource_impl.dart`). `IMoviesRemoteDataSource.discoverMovies({int page = 1, List<int> genreIds = const [], int? yearFrom, int? yearTo})`. `IMoviesRemoteDataSource.getGenres() → Future<List<GenreDto>>`.

This task's core logic (the query param builder) is pure and testable without network mocking — the codebase has no HTTP mocking library installed, so this plan tests the pure param-building function directly rather than adding a mocking dependency.

- [ ] **Step 1: Write the failing test for the query param builder**

```dart
// test/features/movies/data/datasources/movies_query_params_test.dart
import 'package:filmania/features/movies/data/datasources/movies_remote_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildMovieDiscoverQueryParams', () {
    test('with no filters returns only page and sort_by', () {
      final params = buildMovieDiscoverQueryParams(page: 1);

      expect(params, {'page': 1, 'sort_by': 'popularity.desc'});
    });

    test('with genre filter joins ids with a pipe (OR semantics)', () {
      final params = buildMovieDiscoverQueryParams(page: 1, genreIds: [28, 12]);

      expect(params['with_genres'], '28|12');
    });

    test('omits with_genres when genreIds is empty', () {
      final params = buildMovieDiscoverQueryParams(page: 1);

      expect(params.containsKey('with_genres'), isFalse);
    });

    test('with year range sets primary_release_date bounds', () {
      final params =
          buildMovieDiscoverQueryParams(page: 1, yearFrom: 2000, yearTo: 2010);

      expect(params['primary_release_date.gte'], '2000-01-01');
      expect(params['primary_release_date.lte'], '2010-12-31');
    });

    test('omits year keys when null', () {
      final params = buildMovieDiscoverQueryParams(page: 1);

      expect(params.containsKey('primary_release_date.gte'), isFalse);
      expect(params.containsKey('primary_release_date.lte'), isFalse);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/movies/data/datasources/movies_query_params_test.dart`
Expected: FAIL — `buildMovieDiscoverQueryParams` is not defined (compile error).

- [ ] **Step 3: Update the datasource interface**

```dart
// lib/features/movies/data/datasources/i_movies_remote_datasource.dart
import 'package:filmania/core/data/models/cast_member_dto.dart';
import 'package:filmania/core/data/models/genre_dto.dart';
import 'package:filmania/features/movies/data/models/movie_dto.dart';

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
  Future<List<CastMemberDto>> getMovieCredits(int movieId);
  Future<List<GenreDto>> getGenres();
}
```

- [ ] **Step 4: Implement the query param builder, extended discoverMovies, and getGenres**

```dart
// lib/features/movies/data/datasources/movies_remote_datasource_impl.dart
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:filmania/core/network/network_failure.dart';
import 'package:filmania/features/movies/data/datasources/i_movies_remote_datasource.dart';
import 'package:filmania/core/data/models/cast_member_dto.dart';
import 'package:filmania/core/data/models/genre_dto.dart';
import 'package:filmania/features/movies/data/models/movie_dto.dart';

@visibleForTesting
Map<String, dynamic> buildMovieDiscoverQueryParams({
  required int page,
  List<int> genreIds = const [],
  int? yearFrom,
  int? yearTo,
}) {
  return {
    'page': page,
    'sort_by': 'popularity.desc',
    if (genreIds.isNotEmpty) 'with_genres': genreIds.join('|'),
    if (yearFrom != null) 'primary_release_date.gte': '$yearFrom-01-01',
    if (yearTo != null) 'primary_release_date.lte': '$yearTo-12-31',
  };
}

class MoviesRemoteDataSourceImpl implements IMoviesRemoteDataSource {
  final Dio _client;

  const MoviesRemoteDataSourceImpl(this._client);

  @override
  Future<List<MovieDto>> getTrendingMovies({int page = 1}) async {
    try {
      final response = await _client.get(
        'trending/movie/day',
        queryParameters: {'page': page},
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => MovieDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<MovieDto>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  }) async {
    try {
      final response = await _client.get(
        'discover/movie',
        queryParameters: buildMovieDiscoverQueryParams(
          page: page,
          genreIds: genreIds,
          yearFrom: yearFrom,
          yearTo: yearTo,
        ),
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => MovieDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<MovieDto> getMovieDetails(int movieId) async {
    try {
      final response = await _client.get('movie/$movieId');
      return MovieDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<MovieDto>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _client.get(
        'search/movie',
        queryParameters: {'query': query, 'page': page},
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => MovieDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<CastMemberDto>> getMovieCredits(int movieId) async {
    try {
      final response = await _client.get('movie/$movieId/credits');
      final List<dynamic> cast = response.data['cast'];
      return cast.map((json) => CastMemberDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<GenreDto>> getGenres() async {
    try {
      final response = await _client.get('genre/movie/list');
      final List<dynamic> genres = response.data['genres'];
      return genres.map((json) => GenreDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/movies/data/datasources/movies_query_params_test.dart`
Expected: `00:0X +5: All tests passed!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/movies/data/datasources/i_movies_remote_datasource.dart lib/features/movies/data/datasources/movies_remote_datasource_impl.dart test/features/movies/data/datasources/movies_query_params_test.dart
git commit -m "feat: add genre/year filters and getGenres to movies datasource"
```

---

### Task 3: Movies repository — wire getGenres and discoverMovies filters

**Files:**
- Modify: `lib/features/movies/domain/repositories/i_movies_repository.dart`
- Modify: `lib/features/movies/data/repositories/movies_repository_impl.dart`

**Interfaces:**
- Consumes: `IMoviesRemoteDataSource.discoverMovies({page, genreIds, yearFrom, yearTo})` and `.getGenres()` from Task 2; `Genre`/`GenreDto.toEntity()` from Task 1.
- Produces: `IMoviesRepository.discoverMovies({int page = 1, List<int> genreIds = const [], int? yearFrom, int? yearTo}) → Future<List<Movie>>`; `IMoviesRepository.getGenres() → Future<List<Genre>>`.

This is pure passthrough wiring (no branching logic beyond what Task 2 already tested) — no new test, verified via `dart analyze` and the existing movies provider/UI still compiling.

- [ ] **Step 1: Update the repository interface**

```dart
// lib/features/movies/domain/repositories/i_movies_repository.dart
import 'package:filmania/core/domain/entities/genre.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/core/domain/entities/cast_member.dart';

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
  Future<List<CastMember>> getMovieCredits(int movieId);
  Future<List<Genre>> getGenres();
}
```

- [ ] **Step 2: Update the repository implementation**

```dart
// lib/features/movies/data/repositories/movies_repository_impl.dart
import 'package:filmania/core/domain/entities/genre.dart';
import 'package:filmania/core/network/tmdb_client.dart';
import 'package:filmania/features/movies/data/datasources/i_movies_remote_datasource.dart';
import 'package:filmania/features/movies/data/datasources/movies_remote_datasource_impl.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/core/domain/entities/cast_member.dart';

import 'package:filmania/features/movies/domain/repositories/i_movies_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_repository_impl.g.dart';

class MoviesRepositoryImpl implements IMoviesRepository {
  final IMoviesRemoteDataSource _remoteDataSource;

  const MoviesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    final dtos = await _remoteDataSource.getTrendingMovies(page: page);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Movie>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  }) async {
    final dtos = await _remoteDataSource.discoverMovies(
      page: page,
      genreIds: genreIds,
      yearFrom: yearFrom,
      yearTo: yearTo,
    );
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    final dto = await _remoteDataSource.getMovieDetails(movieId);
    return dto.toEntity();
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final dtos = await _remoteDataSource.searchMovies(query, page: page);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<CastMember>> getMovieCredits(int movieId) async {
    final dtos = await _remoteDataSource.getMovieCredits(movieId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Genre>> getGenres() async {
    final dtos = await _remoteDataSource.getGenres();
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}

@riverpod
IMoviesRemoteDataSource moviesRemoteDataSource(Ref ref) {
  return MoviesRemoteDataSourceImpl(ref.watch(tmdbClientProvider));
}

@riverpod
IMoviesRepository moviesRepository(Ref ref) {
  return MoviesRepositoryImpl(ref.watch(moviesRemoteDataSourceProvider));
}
```

- [ ] **Step 3: Run build_runner**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes with no errors (no signature change to the `@riverpod` functions here, but re-running keeps generated code consistent with the rest of the plan's changes).

- [ ] **Step 4: Verify analyze is clean**

Run: `dart analyze lib/features/movies`
Expected: "No issues found!" (Task 4 will still show errors for the provider file until it's updated next — if so, that's expected and resolved in Task 4).

- [ ] **Step 5: Commit**

```bash
git add lib/features/movies/domain/repositories/i_movies_repository.dart lib/features/movies/data/repositories/movies_repository_impl.dart
git commit -m "feat: wire genre/year filters through movies repository"
```

---

### Task 4: Movies provider — movieGenres + DiscoverMovies filter params

**Files:**
- Modify: `lib/features/movies/ui/providers/movies_provider.dart`

**Interfaces:**
- Consumes: `IMoviesRepository.discoverMovies({page, genreIds, yearFrom, yearTo})` and `.getGenres()` from Task 3.
- Produces: `discoverMoviesProvider({int page = 1, String genreIds = '', int? yearFrom, int? yearTo})` (family, `AsyncValue<List<Movie>>`); `movieGenresProvider` (`@Riverpod(keepAlive: true)`, `AsyncValue<List<Genre>>`).

`genreIds` is a `String` (comma-joined sorted ids) here, not `List<int>` — see Global Constraints on family-arg equality. It's split back into `List<int>` before calling the repository.

- [ ] **Step 1: Update movies_provider.dart**

```dart
// lib/features/movies/ui/providers/movies_provider.dart
import 'package:filmania/core/domain/entities/genre.dart';
import 'package:filmania/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/core/domain/entities/cast_member.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_provider.g.dart';

@riverpod
class TrendingMovies extends _$TrendingMovies {
  @override
  FutureOr<List<Movie>> build({int page = 1}) async {
    final repository = ref.watch(moviesRepositoryProvider);
    return repository.getTrendingMovies(page: page);
  }
}

@riverpod
class DiscoverMovies extends _$DiscoverMovies {
  @override
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
}

@riverpod
Future<Movie> movieDetails(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieDetails(movieId);
}

@riverpod
Future<List<Movie>> searchMovies(Ref ref, String query, {int page = 1}) {
  if (query.isEmpty) return Future.value([]);
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.searchMovies(query, page: page);
}

@riverpod
Future<List<CastMember>> movieCredits(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieCredits(movieId);
}

@Riverpod(keepAlive: true)
Future<List<Genre>> movieGenres(Ref ref) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getGenres();
}
```

(Removed the two commented-out "Persistence (Awaiting correct library implementation)" blocks that were dead code on `TrendingMovies`/`DiscoverMovies` — no functional change, just cleanup while touching these classes.)

- [ ] **Step 2: Run build_runner**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes with no errors; `movies_provider.g.dart` regenerated with the new `DiscoverMovies` family params and `movieGenresProvider`.

- [ ] **Step 3: Verify analyze is clean**

Run: `dart analyze lib/features/movies`
Expected: "No issues found!"

- [ ] **Step 4: Commit**

```bash
git add lib/features/movies/ui/providers/movies_provider.dart lib/features/movies/ui/providers/movies_provider.g.dart
git commit -m "feat: add movieGenres provider and filter params to DiscoverMovies"
```

---

### Task 5: TV datasource — query param builder + getGenres + discoverTVSeries filters

**Files:**
- Modify: `lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart`
- Modify: `lib/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart`
- Test: `test/features/tv_series/data/datasources/tv_series_query_params_test.dart`

**Interfaces:**
- Consumes: `GenreDto` from Task 1.
- Produces: `buildTVDiscoverQueryParams({required int page, List<int> genreIds = const [], int? yearFrom, int? yearTo}) → Map<String, dynamic>` (top-level, `@visibleForTesting`, in `tv_series_remote_datasource_impl.dart`). `ITVSeriesRemoteDataSource.discoverTVSeries({int page = 1, List<int> genreIds = const [], int? yearFrom, int? yearTo})`. `ITVSeriesRemoteDataSource.getGenres() → Future<List<GenreDto>>`.

Mirrors Task 2 exactly, except the year param names: TV uses `first_air_date.gte`/`first_air_date.lte` (movies use `primary_release_date.gte`/`.lte`).

- [ ] **Step 1: Write the failing test for the query param builder**

```dart
// test/features/tv_series/data/datasources/tv_series_query_params_test.dart
import 'package:filmania/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildTVDiscoverQueryParams', () {
    test('with no filters returns only page and sort_by', () {
      final params = buildTVDiscoverQueryParams(page: 1);

      expect(params, {'page': 1, 'sort_by': 'popularity.desc'});
    });

    test('with genre filter joins ids with a pipe (OR semantics)', () {
      final params = buildTVDiscoverQueryParams(page: 1, genreIds: [10759, 35]);

      expect(params['with_genres'], '10759|35');
    });

    test('omits with_genres when genreIds is empty', () {
      final params = buildTVDiscoverQueryParams(page: 1);

      expect(params.containsKey('with_genres'), isFalse);
    });

    test('with year range sets first_air_date bounds', () {
      final params =
          buildTVDiscoverQueryParams(page: 1, yearFrom: 2015, yearTo: 2020);

      expect(params['first_air_date.gte'], '2015-01-01');
      expect(params['first_air_date.lte'], '2020-12-31');
    });

    test('omits year keys when null', () {
      final params = buildTVDiscoverQueryParams(page: 1);

      expect(params.containsKey('first_air_date.gte'), isFalse);
      expect(params.containsKey('first_air_date.lte'), isFalse);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/tv_series/data/datasources/tv_series_query_params_test.dart`
Expected: FAIL — `buildTVDiscoverQueryParams` is not defined (compile error).

- [ ] **Step 3: Update the datasource interface**

```dart
// lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart
import 'package:filmania/core/data/models/cast_member_dto.dart';
import 'package:filmania/core/data/models/genre_dto.dart';
import '../models/tv_episode_dto.dart';
import '../models/tv_series_dto.dart';

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
  Future<TVEpisodeDto> getTVEpisodeDetails(int tvId, int seasonNumber, int episodeNumber);
  Future<List<CastMemberDto>> getTVSeriesCredits(int tvId);
  Future<List<CastMemberDto>> getTVEpisodeCredits(int tvId, int seasonNumber, int episodeNumber);
  Future<List<GenreDto>> getGenres();
}
```

- [ ] **Step 4: Implement the query param builder, extended discoverTVSeries, and getGenres**

```dart
// lib/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:filmania/core/network/network_failure.dart';
import 'package:filmania/core/data/models/cast_member_dto.dart';
import 'package:filmania/core/data/models/genre_dto.dart';
import 'package:filmania/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart';
import 'package:filmania/features/tv_series/data/models/tv_episode_dto.dart';
import 'package:filmania/features/tv_series/data/models/tv_series_dto.dart';

@visibleForTesting
Map<String, dynamic> buildTVDiscoverQueryParams({
  required int page,
  List<int> genreIds = const [],
  int? yearFrom,
  int? yearTo,
}) {
  return {
    'page': page,
    'sort_by': 'popularity.desc',
    if (genreIds.isNotEmpty) 'with_genres': genreIds.join('|'),
    if (yearFrom != null) 'first_air_date.gte': '$yearFrom-01-01',
    if (yearTo != null) 'first_air_date.lte': '$yearTo-12-31',
  };
}

class TVSeriesRemoteDataSourceImpl implements ITVSeriesRemoteDataSource {
  final Dio _client;

  const TVSeriesRemoteDataSourceImpl(this._client);

  @override
  Future<List<TVSeriesDto>> getTrendingTVSeries({int page = 1}) async {
    try {
      final response = await _client.get(
        'trending/tv/day',
        queryParameters: {'page': page},
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => TVSeriesDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<TVSeriesDto>> discoverTVSeries({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  }) async {
    try {
      final response = await _client.get(
        'discover/tv',
        queryParameters: buildTVDiscoverQueryParams(
          page: page,
          genreIds: genreIds,
          yearFrom: yearFrom,
          yearTo: yearTo,
        ),
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => TVSeriesDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<TVSeriesDto> getTVSeriesDetails(int tvId) async {
    try {
      final response = await _client.get('tv/$tvId');
      return TVSeriesDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<TVSeriesDto>> searchTVSeries(String query, {int page = 1}) async {
    try {
      final response = await _client.get(
        'search/tv',
        queryParameters: {'query': query, 'page': page},
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => TVSeriesDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<TVEpisodeDto>> getSeasonEpisodes(
    int tvId,
    int seasonNumber,
  ) async {
    try {
      final response = await _client.get('tv/$tvId/season/$seasonNumber');
      final List<dynamic> episodes = response.data['episodes'];
      return episodes.map((json) => TVEpisodeDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<TVEpisodeDto> getTVEpisodeDetails(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    try {
      final response =
          await _client.get('tv/$tvId/season/$seasonNumber/episode/$episodeNumber');
      return TVEpisodeDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<CastMemberDto>> getTVSeriesCredits(int tvId) async {
    try {
      final response = await _client.get('tv/$tvId/credits');
      final List<dynamic> cast = response.data['cast'];
      return cast.map((json) => CastMemberDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<CastMemberDto>> getTVEpisodeCredits(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    try {
      final response = await _client.get(
        'tv/$tvId/season/$seasonNumber/episode/$episodeNumber/credits',
      );
      final List<dynamic> cast = response.data['cast'];
      return cast.map((json) => CastMemberDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<GenreDto>> getGenres() async {
    try {
      final response = await _client.get('genre/tv/list');
      final List<dynamic> genres = response.data['genres'];
      return genres.map((json) => GenreDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/features/tv_series/data/datasources/tv_series_query_params_test.dart`
Expected: `00:0X +5: All tests passed!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart lib/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart test/features/tv_series/data/datasources/tv_series_query_params_test.dart
git commit -m "feat: add genre/year filters and getGenres to tv series datasource"
```

---

### Task 6: TV repository — wire getGenres and discoverTVSeries filters

**Files:**
- Modify: `lib/features/tv_series/domain/repositories/i_tv_series_repository.dart`
- Modify: `lib/features/tv_series/data/repositories/tv_series_repository_impl.dart`

**Interfaces:**
- Consumes: `ITVSeriesRemoteDataSource.discoverTVSeries({page, genreIds, yearFrom, yearTo})` and `.getGenres()` from Task 5.
- Produces: `ITVSeriesRepository.discoverTVSeries({int page = 1, List<int> genreIds = const [], int? yearFrom, int? yearTo}) → Future<List<TVSeries>>`; `ITVSeriesRepository.getGenres() → Future<List<Genre>>`.

Pure passthrough wiring, mirrors Task 3 — no new test.

- [ ] **Step 1: Update the repository interface**

```dart
// lib/features/tv_series/domain/repositories/i_tv_series_repository.dart
import 'package:filmania/core/domain/entities/cast_member.dart';
import 'package:filmania/core/domain/entities/genre.dart';
import '../entities/tv_episode.dart';
import '../entities/tv_series.dart';

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
  Future<TVEpisode> getTVEpisodeDetails(int tvId, int seasonNumber, int episodeNumber);
  Future<List<CastMember>> getTVSeriesCredits(int tvId);
  Future<List<CastMember>> getTVEpisodeCredits(int tvId, int seasonNumber, int episodeNumber);
  Future<List<Genre>> getGenres();
}
```

- [ ] **Step 2: Update the repository implementation**

```dart
// lib/features/tv_series/data/repositories/tv_series_repository_impl.dart
import 'package:filmania/core/domain/entities/cast_member.dart';
import 'package:filmania/core/domain/entities/genre.dart';
import 'package:filmania/core/network/tmdb_client.dart';
import 'package:filmania/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart';
import 'package:filmania/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_episode.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_series.dart';
import 'package:filmania/features/tv_series/domain/repositories/i_tv_series_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tv_series_repository_impl.g.dart';

class TVSeriesRepositoryImpl implements ITVSeriesRepository {
  final ITVSeriesRemoteDataSource _remoteDataSource;

  const TVSeriesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<TVSeries>> getTrendingTVSeries({int page = 1}) async {
    final dtos = await _remoteDataSource.getTrendingTVSeries(page: page);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<TVSeries>> discoverTVSeries({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  }) async {
    final dtos = await _remoteDataSource.discoverTVSeries(
      page: page,
      genreIds: genreIds,
      yearFrom: yearFrom,
      yearTo: yearTo,
    );
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<TVSeries> getTVSeriesDetails(int tvId) async {
    final dto = await _remoteDataSource.getTVSeriesDetails(tvId);
    return dto.toEntity();
  }

  @override
  Future<List<TVSeries>> searchTVSeries(String query, {int page = 1}) async {
    final dtos = await _remoteDataSource.searchTVSeries(query, page: page);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<TVEpisode>> getSeasonEpisodes(int tvId, int seasonNumber) async {
    final dtos = await _remoteDataSource.getSeasonEpisodes(tvId, seasonNumber);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<TVEpisode> getTVEpisodeDetails(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    final dto =
        await _remoteDataSource.getTVEpisodeDetails(tvId, seasonNumber, episodeNumber);
    return dto.toEntity();
  }

  @override
  Future<List<CastMember>> getTVSeriesCredits(int tvId) async {
    final dtos = await _remoteDataSource.getTVSeriesCredits(tvId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<CastMember>> getTVEpisodeCredits(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    final dtos =
        await _remoteDataSource.getTVEpisodeCredits(tvId, seasonNumber, episodeNumber);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Genre>> getGenres() async {
    final dtos = await _remoteDataSource.getGenres();
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}

@riverpod
ITVSeriesRemoteDataSource tvSeriesRemoteDataSource(Ref ref) {
  return TVSeriesRemoteDataSourceImpl(ref.watch(tmdbClientProvider));
}

@riverpod
ITVSeriesRepository tvSeriesRepository(Ref ref) {
  return TVSeriesRepositoryImpl(ref.watch(tvSeriesRemoteDataSourceProvider));
}
```

- [ ] **Step 3: Run build_runner**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes with no errors.

- [ ] **Step 4: Verify analyze is clean**

Run: `dart analyze lib/features/tv_series`
Expected: "No issues found!" (Task 7 resolves any remaining provider-file errors).

- [ ] **Step 5: Commit**

```bash
git add lib/features/tv_series/domain/repositories/i_tv_series_repository.dart lib/features/tv_series/data/repositories/tv_series_repository_impl.dart
git commit -m "feat: wire genre/year filters through tv series repository"
```

---

### Task 7: TV provider — tvGenres + DiscoverTVSeries filter params

**Files:**
- Modify: `lib/features/tv_series/ui/providers/tv_series_provider.dart`

**Interfaces:**
- Consumes: `ITVSeriesRepository.discoverTVSeries({page, genreIds, yearFrom, yearTo})` and `.getGenres()` from Task 6.
- Produces: `discoverTVSeriesProvider({int page = 1, String genreIds = '', int? yearFrom, int? yearTo})` (family, `AsyncValue<List<TVSeries>>`); `tvGenresProvider` (`@Riverpod(keepAlive: true)`, `AsyncValue<List<Genre>>`).

- [ ] **Step 1: Update tv_series_provider.dart**

```dart
// lib/features/tv_series/ui/providers/tv_series_provider.dart
import 'package:filmania/core/domain/entities/cast_member.dart';
import 'package:filmania/core/domain/entities/genre.dart';
import 'package:filmania/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_episode.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_series.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tv_series_provider.g.dart';

@riverpod
class TrendingTVSeries extends _$TrendingTVSeries {
  @override
  FutureOr<List<TVSeries>> build({int page = 1}) async {
    final repository = ref.watch(tvSeriesRepositoryProvider);
    return repository.getTrendingTVSeries(page: page);
  }
}

@riverpod
class DiscoverTVSeries extends _$DiscoverTVSeries {
  @override
  FutureOr<List<TVSeries>> build({
    int page = 1,
    String genreIds = '',
    int? yearFrom,
    int? yearTo,
  }) async {
    final repository = ref.watch(tvSeriesRepositoryProvider);
    return repository.discoverTVSeries(
      page: page,
      genreIds: genreIds.isEmpty
          ? const []
          : genreIds.split(',').map(int.parse).toList(),
      yearFrom: yearFrom,
      yearTo: yearTo,
    );
  }
}

@Riverpod(keepAlive: true)
Future<TVSeries> tvSeriesDetails(Ref ref, int tvId) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVSeriesDetails(tvId);
}

@riverpod
Future<List<TVSeries>> searchTVSeries(Ref ref, String query, {int page = 1}) {
  if (query.isEmpty) return Future.value([]);
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.searchTVSeries(query, page: page);
}

@Riverpod(keepAlive: true)
Future<List<TVEpisode>> seasonEpisodes(Ref ref, int tvId, int seasonNumber) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getSeasonEpisodes(tvId, seasonNumber);
}

@Riverpod(keepAlive: true)
Future<TVEpisode> tvEpisodeDetails(
  Ref ref, {
  required int tvId,
  required int seasonNumber,
  required int episodeNumber,
}) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVEpisodeDetails(tvId, seasonNumber, episodeNumber);
}

@Riverpod(keepAlive: true)
class SelectedSeason extends _$SelectedSeason {
  @override
  int build(int tvId) => 1;

  void select(int seasonNumber) => state = seasonNumber;
}

@Riverpod(keepAlive: true)
Future<List<CastMember>> tvSeriesCredits(Ref ref, int tvId) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVSeriesCredits(tvId);
}

@Riverpod(keepAlive: true)
Future<List<CastMember>> tvEpisodeCredits(
  Ref ref, {
  required int tvId,
  required int seasonNumber,
  required int episodeNumber,
}) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVEpisodeCredits(tvId, seasonNumber, episodeNumber);
}

@Riverpod(keepAlive: true)
Future<List<Genre>> tvGenres(Ref ref) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getGenres();
}
```

(Removed the two commented-out "Persistence" dead-code blocks on `TrendingTVSeries`/`DiscoverTVSeries`, same as Task 4.)

- [ ] **Step 2: Run build_runner**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes with no errors; `tv_series_provider.g.dart` regenerated with `DiscoverTVSeries`'s new params and `tvGenresProvider`.

- [ ] **Step 3: Verify analyze is clean**

Run: `dart analyze lib/features/tv_series`
Expected: "No issues found!"

- [ ] **Step 4: Commit**

```bash
git add lib/features/tv_series/ui/providers/tv_series_provider.dart lib/features/tv_series/ui/providers/tv_series_provider.g.dart
git commit -m "feat: add tvGenres provider and filter params to DiscoverTVSeries"
```

---

### Task 8: Discover filters state (DiscoverFilters + notifiers)

**Files:**
- Modify: `lib/features/discover/ui/providers/discover_providers.dart`
- Test: `test/features/discover/ui/providers/discover_filters_test.dart`

**Interfaces:**
- Produces: `DiscoverFilters({Set<int> genreIds = const {}, int? yearFrom, int? yearTo})` (freezed) with `bool get isActive` and `String get genreIdsKey`; `movieDiscoverFiltersProvider` / `tvDiscoverFiltersProvider` (notifiers, state = `DiscoverFilters`) each exposing `toggleGenre(int id)`, `setYearRange(int? from, int? to)`, `clear()`.

Same "implement → generate → test" pattern as Task 1 (freezed class can't compile without generated code, so a true red-first test isn't possible for the data class itself). The notifier mutation methods (`toggleGenre`/`setYearRange`/`clear`) are tested via `ProviderContainer` (part of `flutter_riverpod`, no new dependency).

- [ ] **Step 1: Add DiscoverFilters and the two notifiers**

```dart
// lib/features/discover/ui/providers/discover_providers.dart
import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/core/domain/enums/media_type.dart';

part 'discover_providers.freezed.dart';
part 'discover_providers.g.dart';

/// Alias for backward compatibility within the discover UI layer.
typedef DiscoverMediaType = MediaType;

@riverpod
class SelectedMediaType extends _$SelectedMediaType {
  @override
  DiscoverMediaType build() => DiscoverMediaType.movie;

  void set(DiscoverMediaType type) => state = type;
}

@riverpod
class MovieSearchQuery extends _$MovieSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
class DebouncedSearchQuery extends _$DebouncedSearchQuery {
  Timer? _timer;

  @override
  String build() {
    ref.onDispose(() => _timer?.cancel());
    return '';
  }

  void update(String query) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 400), () {
      if (ref.mounted) state = query;
    });
  }
}

@freezed
abstract class DiscoverFilters with _$DiscoverFilters {
  const factory DiscoverFilters({
    @Default(<int>{}) Set<int> genreIds,
    int? yearFrom,
    int? yearTo,
  }) = _DiscoverFilters;

  const DiscoverFilters._();

  bool get isActive =>
      genreIds.isNotEmpty || yearFrom != null || yearTo != null;

  String get genreIdsKey {
    if (genreIds.isEmpty) return '';
    final sorted = genreIds.toList()..sort();
    return sorted.join(',');
  }
}

@riverpod
class MovieDiscoverFilters extends _$MovieDiscoverFilters {
  @override
  DiscoverFilters build() => const DiscoverFilters();

  void toggleGenre(int id) {
    final updated = Set<int>.from(state.genreIds);
    if (!updated.remove(id)) updated.add(id);
    state = state.copyWith(genreIds: updated);
  }

  void setYearRange(int? from, int? to) {
    state = state.copyWith(yearFrom: from, yearTo: to);
  }

  void clear() => state = const DiscoverFilters();
}

@riverpod
class TvDiscoverFilters extends _$TvDiscoverFilters {
  @override
  DiscoverFilters build() => const DiscoverFilters();

  void toggleGenre(int id) {
    final updated = Set<int>.from(state.genreIds);
    if (!updated.remove(id)) updated.add(id);
    state = state.copyWith(genreIds: updated);
  }

  void setYearRange(int? from, int? to) {
    state = state.copyWith(yearFrom: from, yearTo: to);
  }

  void clear() => state = const DiscoverFilters();
}
```

- [ ] **Step 2: Run build_runner**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes with no errors; `discover_providers.freezed.dart` created, `discover_providers.g.dart` regenerated with `movieDiscoverFiltersProvider` and `tvDiscoverFiltersProvider`.

- [ ] **Step 3: Write the verification tests**

```dart
// test/features/discover/ui/providers/discover_filters_test.dart
import 'package:filmania/features/discover/ui/providers/discover_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DiscoverFilters', () {
    test('isActive is false with no filters', () {
      const filters = DiscoverFilters();
      expect(filters.isActive, isFalse);
    });

    test('isActive is true when a genre is selected', () {
      const filters = DiscoverFilters(genreIds: {28});
      expect(filters.isActive, isTrue);
    });

    test('isActive is true when a year bound is set', () {
      const filters = DiscoverFilters(yearFrom: 2000);
      expect(filters.isActive, isTrue);
    });

    test('genreIdsKey sorts ids and joins with a comma', () {
      const filters = DiscoverFilters(genreIds: {28, 12, 16});
      expect(filters.genreIdsKey, '12,16,28');
    });

    test('genreIdsKey is empty when no genres are selected', () {
      const filters = DiscoverFilters();
      expect(filters.genreIdsKey, '');
    });
  });

  group('MovieDiscoverFilters', () {
    test('toggleGenre adds an id that is not yet selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(movieDiscoverFiltersProvider.notifier).toggleGenre(28);

      expect(container.read(movieDiscoverFiltersProvider).genreIds, {28});
    });

    test('toggleGenre removes an id that is already selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(movieDiscoverFiltersProvider.notifier);

      notifier.toggleGenre(28);
      notifier.toggleGenre(28);

      expect(container.read(movieDiscoverFiltersProvider).genreIds, isEmpty);
    });

    test('clear resets genres and year range to defaults', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(movieDiscoverFiltersProvider.notifier);
      notifier.toggleGenre(28);
      notifier.setYearRange(2000, 2020);

      notifier.clear();

      expect(container.read(movieDiscoverFiltersProvider), const DiscoverFilters());
    });
  });

  group('TvDiscoverFilters', () {
    test('is independent from MovieDiscoverFilters', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(movieDiscoverFiltersProvider.notifier).toggleGenre(28);

      expect(container.read(tvDiscoverFiltersProvider).genreIds, isEmpty);
    });
  });
}
```

- [ ] **Step 4: Run the tests**

Run: `flutter test test/features/discover/ui/providers/discover_filters_test.dart`
Expected: `00:0X +9: All tests passed!`

- [ ] **Step 5: Verify analyze is clean**

Run: `dart analyze lib/features/discover`
Expected: "No issues found!"

- [ ] **Step 6: Commit**

```bash
git add lib/features/discover/ui/providers/discover_providers.dart lib/features/discover/ui/providers/discover_providers.freezed.dart lib/features/discover/ui/providers/discover_providers.g.dart test/features/discover/ui/providers/discover_filters_test.dart
git commit -m "feat: add DiscoverFilters state with per-media-type notifiers"
```

---

### Task 9: Discover page UI — filters button, badge, and bottom sheet

**Files:**
- Modify: `lib/features/discover/ui/pages/discover_page.dart`

**Interfaces:**
- Consumes: `movieGenresProvider`/`tvGenresProvider` (Tasks 4, 7); `movieDiscoverFiltersProvider`/`tvDiscoverFiltersProvider` (Task 8); `discoverMoviesProvider`/`discoverTVSeriesProvider` with the new filter params (Tasks 4, 7).
- Produces: no new public interfaces — this is the leaf UI task.

- [ ] **Step 1: Replace the whole file with the wired version**

```dart
// lib/features/discover/ui/pages/discover_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../../../movies/ui/providers/movies_provider.dart';
import '../../../tv_series/ui/providers/tv_series_provider.dart';
import '../widgets/discover_widgets.dart';
import '../providers/discover_providers.dart';
import '../../../../core/widgets/error_view.dart';

class DiscoverPage extends ConsumerWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typingQuery = ref.watch(movieSearchQueryProvider);
    final query = ref.watch(debouncedSearchQueryProvider);
    final selectedMediaType = ref.watch(selectedMediaTypeProvider);
    final movieFilters = ref.watch(movieDiscoverFiltersProvider);
    final tvFilters = ref.watch(tvDiscoverFiltersProvider);
    final activeFilters =
        selectedMediaType == DiscoverMediaType.movie ? movieFilters : tvFilters;
    final isDebouncing = typingQuery != query && typingQuery.isNotEmpty;
    final discoverAsync =
        _buildDiscoverAsync(ref, query, selectedMediaType, activeFilters);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight + AppSpacing.xl,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DiscoverHeader(
                    selectedMediaType: selectedMediaType,
                    onMovieSelected: () => ref
                        .read(selectedMediaTypeProvider.notifier)
                        .set(DiscoverMediaType.movie),
                    onTvSelected: () => ref
                        .read(selectedMediaTypeProvider.notifier)
                        .set(DiscoverMediaType.tv),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _DiscoverSearchBar(
                    selectedMediaType: selectedMediaType,
                    isDebouncing: isDebouncing,
                    isFiltersActive: activeFilters.isActive,
                    onFiltersTap: () =>
                        _showFiltersSheet(context, selectedMediaType),
                    onChanged: (value) {
                      ref.read(movieSearchQueryProvider.notifier).update(value);
                      ref
                          .read(debouncedSearchQueryProvider.notifier)
                          .update(value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          _DiscoverResultsSliver(
            discoverAsync: discoverAsync,
            selectedMediaType: selectedMediaType,
            query: query,
            filters: activeFilters,
            ref: ref,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  AsyncValue<List<dynamic>> _buildDiscoverAsync(
    WidgetRef ref,
    String query,
    DiscoverMediaType selectedMediaType,
    DiscoverFilters filters,
  ) {
    if (query.isEmpty) {
      return selectedMediaType == DiscoverMediaType.movie
          ? ref.watch(discoverMoviesProvider(
              genreIds: filters.genreIdsKey,
              yearFrom: filters.yearFrom,
              yearTo: filters.yearTo,
            ))
          : ref
              .watch(discoverTVSeriesProvider(
                genreIds: filters.genreIdsKey,
                yearFrom: filters.yearFrom,
                yearTo: filters.yearTo,
              ))
              .whenData((l) => l);
    }
    return selectedMediaType == DiscoverMediaType.movie
        ? ref.watch(searchMoviesProvider(query))
        : ref.watch(searchTVSeriesProvider(query)).whenData((l) => l);
  }
}

void _showFiltersSheet(BuildContext context, DiscoverMediaType selectedMediaType) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) =>
        _FiltersSheetContent(selectedMediaType: selectedMediaType),
  );
}

class _DiscoverHeader extends StatelessWidget {
  const _DiscoverHeader({
    required this.selectedMediaType,
    required this.onMovieSelected,
    required this.onTvSelected,
  });

  final DiscoverMediaType selectedMediaType;
  final VoidCallback onMovieSelected;
  final VoidCallback onTvSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Discover',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            color: colors.onSurfacePrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
                ? colors.surface.withValues(alpha: 0.5) 
                : colors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            boxShadow: Theme.of(context).brightness == Brightness.dark ? null : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MediaTypeButton(
                label: 'Film',
                isSelected: selectedMediaType == DiscoverMediaType.movie,
                onTap: onMovieSelected,
              ),
              _MediaTypeButton(
                label: 'Serie TV',
                isSelected: selectedMediaType == DiscoverMediaType.tv,
                onTap: onTvSelected,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DiscoverSearchBar extends StatelessWidget {
  const _DiscoverSearchBar({
    required this.selectedMediaType,
    required this.onChanged,
    required this.isDebouncing,
    required this.isFiltersActive,
    required this.onFiltersTap,
  });

  final DiscoverMediaType selectedMediaType;
  final ValueChanged<String> onChanged;
  final bool isDebouncing;
  final bool isFiltersActive;
  final VoidCallback onFiltersTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassOverlay(
          sigma: 12,
          color: colors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppSpacing.xl),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: colors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfacePrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: selectedMediaType == DiscoverMediaType.movie
                          ? 'Cerca film, attori, registi...'
                          : 'Cerca serie TV...',
                      hintStyle: textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceSecondary,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _FiltersButton(isActive: isFiltersActive, onTap: onFiltersTap),
              ],
            ),
          ),
        ),
        if (isDebouncing) ...[
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              backgroundColor: colors.primary.withValues(alpha: 0.1),
              color: colors.primary,
              minHeight: 2,
            ),
          ),
        ],
      ],
    );
  }
}

class _FiltersButton extends StatelessWidget {
  const _FiltersButton({required this.isActive, required this.onTap});

  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Semantics(
      label: 'Filtri',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.tune_rounded, color: colors.onSurfaceSecondary),
            if (isActive)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FiltersSheetContent extends StatelessWidget {
  const _FiltersSheetContent({required this.selectedMediaType});

  final DiscoverMediaType selectedMediaType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.of(context).background,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(AppSpacing.radius)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FiltersSheetHeader(selectedMediaType: selectedMediaType),
            const SizedBox(height: AppSpacing.lg),
            _GenreFilterSection(selectedMediaType: selectedMediaType),
            const SizedBox(height: AppSpacing.xl),
            _YearRangeFilterSection(selectedMediaType: selectedMediaType),
          ],
        ),
      ),
    );
  }
}

class _FiltersSheetHeader extends ConsumerWidget {
  const _FiltersSheetHeader({required this.selectedMediaType});

  final DiscoverMediaType selectedMediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final isMovie = selectedMediaType == DiscoverMediaType.movie;
    final filters = isMovie
        ? ref.watch(movieDiscoverFiltersProvider)
        : ref.watch(tvDiscoverFiltersProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filtri',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (filters.isActive)
          TextButton(
            onPressed: () => isMovie
                ? ref.read(movieDiscoverFiltersProvider.notifier).clear()
                : ref.read(tvDiscoverFiltersProvider.notifier).clear(),
            child: Text('Cancella filtri', style: TextStyle(color: colors.error)),
          ),
      ],
    );
  }
}

class _GenreFilterSection extends ConsumerWidget {
  const _GenreFilterSection({required this.selectedMediaType});

  final DiscoverMediaType selectedMediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final isMovie = selectedMediaType == DiscoverMediaType.movie;
    final genresAsync =
        isMovie ? ref.watch(movieGenresProvider) : ref.watch(tvGenresProvider);
    final filters = isMovie
        ? ref.watch(movieDiscoverFiltersProvider)
        : ref.watch(tvDiscoverFiltersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GENERE',
          style: textTheme.labelSmall?.copyWith(
            color: colors.onSurfaceSecondary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        genresAsync.when(
          data: (genres) => Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: genres
                .map((genre) => _GenreChip(
                      label: genre.name,
                      isSelected: filters.genreIds.contains(genre.id),
                      onTap: () => isMovie
                          ? ref
                              .read(movieDiscoverFiltersProvider.notifier)
                              .toggleGenre(genre.id)
                          : ref
                              .read(tvDiscoverFiltersProvider.notifier)
                              .toggleGenre(genre.id),
                    ))
                .toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Text(
            'Impossibile caricare i generi.',
            style: TextStyle(color: colors.error),
          ),
        ),
      ],
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected ? Colors.white : colors.onSurfaceSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _YearRangeFilterSection extends ConsumerStatefulWidget {
  const _YearRangeFilterSection({required this.selectedMediaType});

  final DiscoverMediaType selectedMediaType;

  @override
  ConsumerState<_YearRangeFilterSection> createState() =>
      _YearRangeFilterSectionState();
}

class _YearRangeFilterSectionState extends ConsumerState<_YearRangeFilterSection> {
  static const int _minYear = 1950;
  static final int _maxYear = DateTime.now().year;

  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    final filters = widget.selectedMediaType == DiscoverMediaType.movie
        ? ref.read(movieDiscoverFiltersProvider)
        : ref.read(tvDiscoverFiltersProvider);
    _values = RangeValues(
      (filters.yearFrom ?? _minYear).toDouble(),
      (filters.yearTo ?? _maxYear).toDouble(),
    );
  }

  void _commit(RangeValues values) {
    final from = values.start.round();
    final to = values.end.round();
    final notifier = widget.selectedMediaType == DiscoverMediaType.movie
        ? ref.read(movieDiscoverFiltersProvider.notifier)
        : ref.read(tvDiscoverFiltersProvider.notifier);
    notifier.setYearRange(
      from == _minYear ? null : from,
      to == _maxYear ? null : to,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final isDefaultRange =
        _values.start.round() == _minYear && _values.end.round() == _maxYear;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ANNO DI USCITA',
          style: textTheme.labelSmall?.copyWith(
            color: colors.onSurfaceSecondary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          isDefaultRange
              ? 'Qualsiasi periodo'
              : '${_values.start.round()} – ${_values.end.round()}',
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfacePrimary),
        ),
        RangeSlider(
          min: _minYear.toDouble(),
          max: _maxYear.toDouble(),
          divisions: _maxYear - _minYear,
          values: _values,
          activeColor: colors.primary,
          onChanged: (values) => setState(() => _values = values),
          onChangeEnd: _commit,
        ),
      ],
    );
  }
}

class _DiscoverResultsSliver extends StatelessWidget {
  const _DiscoverResultsSliver({
    required this.discoverAsync,
    required this.selectedMediaType,
    required this.query,
    required this.filters,
    required this.ref,
  });

  final AsyncValue<List<dynamic>> discoverAsync;
  final DiscoverMediaType selectedMediaType;
  final String query;
  final DiscoverFilters filters;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return discoverAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Nessun risultato trovato',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSurfacePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Prova con parole chiave diverse.',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              if (selectedMediaType == DiscoverMediaType.movie) {
                return MediaGridCard.movie(
                  movie: item,
                  onTap: () {
                    context.push(
                      AppRoutes.movieDetails.replaceFirst(
                        ':id',
                        item.id.toString(),
                      ),
                    );
                  },
                );
              } else {
                return MediaGridCard.tv(
                  tv: item,
                  onTap: () {
                    context.push(
                      AppRoutes.tvDetails.replaceFirst(
                        ':id',
                        item.id.toString(),
                      ),
                    );
                  },
                );
              }
            }, childCount: items.length),
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SliverFillRemaining(
        hasScrollBody: false,
        child: AppErrorView(
          error: err,
          onRetry: () => query.isEmpty
              ? (selectedMediaType == DiscoverMediaType.movie
                    ? ref.invalidate(discoverMoviesProvider(
                        genreIds: filters.genreIdsKey,
                        yearFrom: filters.yearFrom,
                        yearTo: filters.yearTo,
                      ))
                    : ref.invalidate(discoverTVSeriesProvider(
                        genreIds: filters.genreIdsKey,
                        yearFrom: filters.yearFrom,
                        yearTo: filters.yearTo,
                      )))
              : (selectedMediaType == DiscoverMediaType.movie
                    ? ref.invalidate(searchMoviesProvider(query))
                    : ref.invalidate(searchTVSeriesProvider(query))),
        ),
      ),
    );
  }
}

class _MediaTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MediaTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected ? Colors.white : colors.onSurfaceSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Verify analyze is clean**

Run: `dart analyze lib/features/discover`
Expected: "No issues found!"

- [ ] **Step 3: Format check**

Run: `dart format --set-exit-if-changed lib/features/discover/ui/pages/discover_page.dart`
Expected: exit code 0, no files listed as needing formatting. If it fails, run `dart format lib/features/discover/ui/pages/discover_page.dart` and re-check.

- [ ] **Step 4: Commit**

```bash
git add lib/features/discover/ui/pages/discover_page.dart
git commit -m "feat: wire genre/year filters bottom sheet into Discover page"
```

---

### Task 10: Full verification

**Files:** none (verification only).

- [ ] **Step 1: Full static analysis**

Run: `dart analyze`
Expected: "No issues found!"

- [ ] **Step 2: Full format check**

Run: `dart format --set-exit-if-changed .`
Expected: exit code 0.

- [ ] **Step 3: Full test suite**

Run: `flutter test`
Expected: all tests pass, including the pre-existing suite (`glassmorphic_app_bar_test.dart`, `media_grid_card_test.dart`, `settings_page_test.dart`, `episode_card_test.dart`, `watched_episode_button_icon_test.dart`) plus the new tests from Tasks 1, 2, 5, 8.

- [ ] **Step 4: Manual smoke test**

Run: `flutter run` (or `flutter run --profile`), then on-device/emulator:
1. Open Discover tab, Film sub-tab. Tap the tune icon — bottom sheet opens with genre chips and a year range slider.
2. Select 1-2 genres and drag the year slider. Sheet stays open, results update live behind it (dismiss sheet to confirm the grid changed).
3. Tune icon shows a small dot badge while any filter is active.
4. Tap "Cancella filtri" — chips deselect, slider resets to "Qualsiasi periodo", badge disappears.
5. Switch to Serie TV sub-tab — its filters are independent (previously-set Film filters do not carry over, badge state reflects the Serie TV tab's own filters).
6. Repeat genre + year selection on Serie TV, confirm results update and badge shows.

Expected: no crashes, no dead taps, grid updates reflect the selected filters (spot-check by knowing e.g. that selecting "Animazione" should visibly shift the result set).

- [ ] **Step 5: Commit (only if smoke test uncovered fixes)**

If Step 4 required code changes, stage and commit them with a message describing the fix. If Step 4 passed clean, there is nothing to commit for this task.

---

## Post-Plan

Update `docs/superpowers/specs/2026-07-02-discover-filters-design.md` status line from "Approved" to "Implemented" once Task 10 passes, and commit that single-line change.
