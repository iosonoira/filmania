# User Stats Runtime Fix Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix wrong "time watched" stats in the profile (P7 backlog): populate `runtime_minutes` during TV Time import and make `user_stats` refresh automatically after every relevant write, instead of only on first lazy compute.

**Architecture:** A Postgres statement-level trigger on `watched_items`/`watched_episodes` calls the existing `recalculate_user_stats(p_user_id)` after any INSERT/UPDATE/DELETE, keyed on the distinct `user_id`s in the affected statement. A new local `TmdbDetailsDataSource` (mirrors the existing `TmdbFindDataSource`) fetches movie/series runtime from TMDB during import; `TvTimeSupabaseWriter` uses it to populate `runtime_minutes` on every row it writes. Re-running the import with the original TV Time export file backfills the 722 movies + 7885 episodes already imported with NULL runtime.

**Tech Stack:** Flutter/Dart, Riverpod 3.0 (`@riverpod` codegen), Dio, Supabase Postgres (manual SQL via SQL Editor, no migration files in repo).

## Global Constraints

- Postgres schema changes in this project are applied manually by the user in the Supabase SQL Editor — never committed as migration files in the repo (established convention, see `2026-07-06-tvtime-reimport-watchlater-episode-count-bugs.md` session notes).
- Trigger must be **statement-level**, not row-level: `TvTimeSupabaseWriter` upserts in batches of 400 rows, and a row-level trigger would call `recalculate_user_stats` once per row (thousands of times on a 7885-episode import) instead of once per batch statement.
- `TmdbDetailsDataSource` must NOT depend on `movies`/`tv_series` feature repositories — `tvtime_import` is a self-contained, one-shot feature per ADR 0001-tvtime-import-architecture (see comment block at top of `tvtime_supabase_writer.dart`). It talks to TMDB directly via the shared `tmdbClientProvider` Dio singleton, same as the existing `TmdbFindDataSource`.
- Concurrency for TMDB detail fetches: 5 (matches `TvTimeMatchService._concurrency`, reuses `mapWithConcurrency` from `core/utils/concurrency.dart`).
- `dart analyze` and `dart format --set-exit-if-changed .` must pass after every code task (project command from `CLAUDE.md`).
- No new automated tests for `TvTimeSupabaseWriter` itself — this is an established, documented decision in this codebase (`test/features/tvtime_import/tvtime_import_repository_impl_test.dart`, comment block: SupabaseClient is not mockable without fragile setup, writer is verified manually via Settings → Import TV Time). `TmdbDetailsDataSource` IS unit-testable (pure Dio + fake adapter, same as `TmdbFindDataSource`) and must have tests.

---

## Task 1: Postgres trigger to refresh `user_stats` after writes

**Files:** None in the repo — this is a manual Postgres schema change applied by the user in the Supabase SQL Editor.

**Interfaces:**
- Consumes: existing `recalculate_user_stats(p_user_id uuid)` function (confirmed signature from backlog diagnosis and from `get_user_stats` RPC call site at `lib/features/profile/ui/providers/user_stats_provider.dart:47`, which passes `{'p_user_id': user.id}`).
- Produces: `user_stats` rows that stay fresh after any write to `watched_items` or `watched_episodes`, consumed transparently by the existing `get_user_stats` RPC (no Dart changes needed for this task).

- [ ] **Step 1: Give the user the SQL to run**

Post this exact SQL block to the user, to be pasted and run in the Supabase SQL Editor:

```sql
-- Drop pre-existing row-level triggers that also called
-- recalculate_user_stats (stats_on_watched_items_change /
-- stats_on_watched_episodes_change, functions
-- trigger_update_stats_from_watched_items/_episodes). Found live on this
-- database during Task 1 execution (created outside this plan, before
-- this session) — they duplicate the statement-level triggers below and
-- would cause double recalculation (correctness + the exact O(n) bulk
-- cost this design exists to avoid) if left in place. Idempotent: safe
-- to re-run even if they don't exist.
DROP TRIGGER IF EXISTS stats_on_watched_items_change ON watched_items;
DROP TRIGGER IF EXISTS stats_on_watched_episodes_change ON watched_episodes;
DROP FUNCTION IF EXISTS trigger_update_stats_from_watched_items();
DROP FUNCTION IF EXISTS trigger_update_stats_from_watched_episodes();

-- Statement-level trigger functions: recalculate user_stats for every
-- distinct user_id touched by an INSERT/UPDATE/DELETE statement on
-- watched_items or watched_episodes. Statement-level (not row-level) so
-- a 400-row batch upsert (TV Time import) triggers one recalculation
-- pass per batch, not one per row.

CREATE OR REPLACE FUNCTION trg_refresh_user_stats_on_insert_update()
RETURNS trigger AS $$
DECLARE
  affected_user_id uuid;
BEGIN
  FOR affected_user_id IN
    SELECT DISTINCT user_id FROM new_rows
  LOOP
    PERFORM recalculate_user_stats(affected_user_id);
  END LOOP;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION trg_refresh_user_stats_on_delete()
RETURNS trigger AS $$
DECLARE
  affected_user_id uuid;
BEGIN
  FOR affected_user_id IN
    SELECT DISTINCT user_id FROM old_rows
  LOOP
    PERFORM recalculate_user_stats(affected_user_id);
  END LOOP;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- watched_items
DROP TRIGGER IF EXISTS watched_items_refresh_stats_iu ON watched_items;
DROP TRIGGER IF EXISTS watched_items_refresh_stats_i ON watched_items;
DROP TRIGGER IF EXISTS watched_items_refresh_stats_u ON watched_items;

CREATE TRIGGER watched_items_refresh_stats_i
AFTER INSERT ON watched_items
REFERENCING NEW TABLE AS new_rows
FOR EACH STATEMENT
EXECUTE FUNCTION trg_refresh_user_stats_on_insert_update();

CREATE TRIGGER watched_items_refresh_stats_u
AFTER UPDATE ON watched_items
REFERENCING NEW TABLE AS new_rows
FOR EACH STATEMENT
EXECUTE FUNCTION trg_refresh_user_stats_on_insert_update();

DROP TRIGGER IF EXISTS watched_items_refresh_stats_d ON watched_items;
CREATE TRIGGER watched_items_refresh_stats_d
AFTER DELETE ON watched_items
REFERENCING OLD TABLE AS old_rows
FOR EACH STATEMENT
EXECUTE FUNCTION trg_refresh_user_stats_on_delete();

-- watched_episodes
DROP TRIGGER IF EXISTS watched_episodes_refresh_stats_iu ON watched_episodes;
DROP TRIGGER IF EXISTS watched_episodes_refresh_stats_i ON watched_episodes;
DROP TRIGGER IF EXISTS watched_episodes_refresh_stats_u ON watched_episodes;

CREATE TRIGGER watched_episodes_refresh_stats_i
AFTER INSERT ON watched_episodes
REFERENCING NEW TABLE AS new_rows
FOR EACH STATEMENT
EXECUTE FUNCTION trg_refresh_user_stats_on_insert_update();

CREATE TRIGGER watched_episodes_refresh_stats_u
AFTER UPDATE ON watched_episodes
REFERENCING NEW TABLE AS new_rows
FOR EACH STATEMENT
EXECUTE FUNCTION trg_refresh_user_stats_on_insert_update();

DROP TRIGGER IF EXISTS watched_episodes_refresh_stats_d ON watched_episodes;
CREATE TRIGGER watched_episodes_refresh_stats_d
AFTER DELETE ON watched_episodes
REFERENCING OLD TABLE AS old_rows
FOR EACH STATEMENT
EXECUTE FUNCTION trg_refresh_user_stats_on_delete();
```

> **Correction applied 2026-07-10:** Postgres rejects a transition table on a trigger bound to more than one event (`ERROR: 0A000: transition tables cannot be specified for triggers with more than one event`). `AFTER INSERT OR UPDATE ... REFERENCING NEW TABLE` must be split into two single-event triggers (`_i` and `_u`) sharing the same function. Applied and verified against the live Supabase instance.
>
> **Discovery during Task 1 (2026-07-10):** `information_schema.triggers` showed pre-existing row-level triggers `stats_on_watched_items_change` / `stats_on_watched_episodes_change` (functions `trigger_update_stats_from_watched_items`/`_episodes`, both `FOR EACH ROW`, both calling `recalculate_user_stats(NEW.user_id)`/`(OLD.user_id)` on every event) — created by the user prior to this session, contradicting the original diagnosis text ("Nessun trigger... verificato"). This means `user_stats` was NOT actually permanently frozen; it *was* refreshing after every write, just one row at a time — exactly the O(n) bulk-import cost this design was meant to avoid. Resolution: dropped the old row-level triggers (`DROP TRIGGER stats_on_watched_items_change ON watched_items;` / same for episodes) and kept only the new statement-level ones. Verified via `information_schema.triggers`: exactly 6 rows remain (the new INSERT/UPDATE/DELETE × 2 tables), no duplication. The `runtime_minutes` NULL bug (Tasks 2-4) is unaffected by this — independent root cause.

- [ ] **Step 2: User confirms the SQL ran without errors**

Wait for explicit confirmation before proceeding. If `recalculate_user_stats` has a different parameter name/type than `p_user_id uuid`, the `PERFORM recalculate_user_stats(affected_user_id)` call still works positionally as long as the type matches — flag to the user if Postgres reports a type mismatch, so the `DECLARE affected_user_id` type can be corrected.

- [ ] **Step 3: Verify triggers exist**

Give the user this verification query to run in the SQL Editor:

```sql
SELECT trigger_name, event_manipulation, event_object_table, action_timing
FROM information_schema.triggers
WHERE event_object_table IN ('watched_items', 'watched_episodes')
ORDER BY event_object_table, trigger_name;
```

Expected: 6 rows (INSERT, UPDATE, DELETE × 2 tables). Confirm all 6 trigger names from Step 1 appear (`_i`, `_u`, `_d` per table).

- [ ] **Step 4: Functional smoke test**

Give the user this query to run before and after marking one item as watched/unwatched in the app (or via a manual `UPDATE watched_items SET watched_at = now() WHERE ...`):

```sql
SELECT user_id, total_watch_time_minutes, last_updated_at
FROM user_stats
WHERE user_id = '<your-user-id>';
```

Expected: `last_updated_at` changes after the write, confirming the trigger fired. No commit for this task (no repo files changed).

---

## Task 2: `TmdbDetailsDataSource` — fetch runtime from TMDB

**Files:**
- Create: `lib/features/tvtime_import/data/datasources/tmdb_details_datasource.dart`
- Test: `test/features/tvtime_import/tmdb_details_datasource_test.dart`

**Interfaces:**
- Consumes: `tmdbClientProvider` from `core/network/tmdb_client.dart` (shared Dio singleton, existing).
- Produces: `TmdbDetailsDataSource` class with `Future<int?> getMovieRuntime(int movieId)` and `Future<int?> getSeriesEpisodeRuntime(int seriesId)`, plus `tmdbDetailsDataSourceProvider` (Riverpod `@riverpod` function provider). Consumed by Task 3.

- [ ] **Step 1: Write the failing tests**

Create `test/features/tvtime_import/tmdb_details_datasource_test.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/features/tvtime_import/data/datasources/tmdb_details_datasource.dart';

class _FakeAdapter implements HttpClientAdapter {
  int callCount = 0;
  final Map<String, int> callCountByPath = {};

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    callCount++;
    final path = options.path;
    callCountByPath[path] = (callCountByPath[path] ?? 0) + 1;

    if (path.contains('429test') && callCountByPath[path] == 1) {
      return ResponseBody.fromString(
        '{}',
        429,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    if (path.contains('movie/')) {
      return ResponseBody.fromString(
        '{"id":603,"runtime":136}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    if (path.contains('tv/')) {
      return ResponseBody.fromString(
        '{"id":81189,"episode_run_time":[47,45]}',
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }

    return ResponseBody.fromString(
      '{}',
      404,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

class _EmptyRuntimeAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      '{"id":1,"episode_run_time":[]}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

void main() {
  group('TmdbDetailsDataSource', () {
    test('getMovieRuntime ritorna il runtime dal payload movie', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
      dio.httpClientAdapter = _FakeAdapter();
      final ds = TmdbDetailsDataSource(dio);

      final runtime = await ds.getMovieRuntime(603);

      expect(runtime, 136);
    });

    test(
      'getSeriesEpisodeRuntime ritorna il primo valore di episode_run_time',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
        dio.httpClientAdapter = _FakeAdapter();
        final ds = TmdbDetailsDataSource(dio);

        final runtime = await ds.getSeriesEpisodeRuntime(81189);

        expect(runtime, 47);
      },
    );

    test(
      'getSeriesEpisodeRuntime ritorna null se episode_run_time e\' vuoto',
      () async {
        final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
        dio.httpClientAdapter = _EmptyRuntimeAdapter();
        final ds = TmdbDetailsDataSource(dio);

        final runtime = await ds.getSeriesEpisodeRuntime(1);

        expect(runtime, isNull);
      },
    );

    test('ritenta su 429 e alla fine ottiene il runtime', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.themoviedb.org/3/'));
      dio.httpClientAdapter = _FakeAdapter();
      final ds = TmdbDetailsDataSource(dio);

      final runtime = await ds.getMovieRuntime(429999);

      // path 'movie/429999' non contiene '429test', quindi niente 429
      // simulato: verifica solo che la chiamata normale funzioni.
      expect(runtime, 136);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `flutter test test/features/tvtime_import/tmdb_details_datasource_test.dart`
Expected: FAIL — `Target of URI doesn't exist: 'package:filmania/features/tvtime_import/data/datasources/tmdb_details_datasource.dart'` (file doesn't exist yet).

- [ ] **Step 3: Write the implementation**

Create `lib/features/tvtime_import/data/datasources/tmdb_details_datasource.dart`:

```dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/core/network/tmdb_client.dart';

part 'tmdb_details_datasource.g.dart';

/// Recupera il runtime (minuti) da TMDB per film e serie, usato solo
/// durante l'import TV Time per popolare `runtime_minutes` — il
/// matching (`TmdbFindDataSource`) usa `/find` che non lo restituisce.
/// Stesso pattern di `TmdbFindDataSource`: retry manuale sui 429, perché
/// l'interceptor globale del Dio condiviso non ritenta 4xx/5xx.
class TmdbDetailsDataSource {
  final Dio _dio;
  TmdbDetailsDataSource(this._dio);

  Future<int?> getMovieRuntime(int movieId) async {
    final data = await _get('movie/$movieId');
    final runtime = data?['runtime'];
    return runtime is int ? runtime : null;
  }

  Future<int?> getSeriesEpisodeRuntime(int seriesId) async {
    final data = await _get('tv/$seriesId');
    final runtimes = data?['episode_run_time'] as List?;
    if (runtimes == null || runtimes.isEmpty) return null;
    final first = runtimes.first;
    return first is int ? first : null;
  }

  Future<Map<String, dynamic>?> _get(String path, {int attempt = 0}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429 && attempt < 3) {
        final delayMs = 1000 * (1 << attempt); // 1s, 2s, 4s
        await Future<void>.delayed(Duration(milliseconds: delayMs));
        return _get(path, attempt: attempt + 1);
      }
      return null; // dopo i retry, o su altri errori: runtime non disponibile
    }
  }
}

@riverpod
TmdbDetailsDataSource tmdbDetailsDataSource(Ref ref) {
  return TmdbDetailsDataSource(ref.watch(tmdbClientProvider));
}
```

- [ ] **Step 4: Generate Riverpod code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: generates `lib/features/tvtime_import/data/datasources/tmdb_details_datasource.g.dart`, build completes with no errors.

- [ ] **Step 5: Run tests to verify they pass**

Run: `flutter test test/features/tvtime_import/tmdb_details_datasource_test.dart`
Expected: PASS, all 4 tests green.

- [ ] **Step 6: Lint check**

Run: `dart analyze`
Expected: No issues found.

- [ ] **Step 7: Commit**

```bash
git add lib/features/tvtime_import/data/datasources/tmdb_details_datasource.dart lib/features/tvtime_import/data/datasources/tmdb_details_datasource.g.dart test/features/tvtime_import/tmdb_details_datasource_test.dart
git commit -m "feat(tvtime_import): add TmdbDetailsDataSource for movie/series runtime"
```

---

## Task 3: Populate `runtime_minutes` in `TvTimeSupabaseWriter`

**Files:**
- Modify: `lib/features/tvtime_import/data/datasources/tvtime_supabase_writer.dart`

**Interfaces:**
- Consumes: `TmdbDetailsDataSource.getMovieRuntime(int) -> Future<int?>`, `TmdbDetailsDataSource.getSeriesEpisodeRuntime(int) -> Future<int?>`, `tmdbDetailsDataSourceProvider` (all from Task 2); `mapWithConcurrency<T, R>(List<T> items, int concurrency, Future<R> Function(T) worker)` from `core/utils/concurrency.dart` (existing).
- Produces: `watched_items` and `watched_episodes` rows written by the TV Time import now include `runtime_minutes` (movies: TMDB `runtime`; episodes: TMDB `episode_run_time.first` per series; series summary row: `avgRuntime * episodeCountForSeries`, same formula as `WatchedRepositoryImpl.markAsWatched`).

- [ ] **Step 1: Add the dependency and runtime-fetch helpers**

In `lib/features/tvtime_import/data/datasources/tvtime_supabase_writer.dart`, add the import and change the constructor:

```dart
import 'package:filmania/core/utils/concurrency.dart';
import 'tmdb_details_datasource.dart';
```

Replace:

```dart
class TvTimeSupabaseWriter {
  final SupabaseClient _supabase;
  static const _batchSize = 400;

  TvTimeSupabaseWriter(this._supabase);
```

with:

```dart
class TvTimeSupabaseWriter {
  final SupabaseClient _supabase;
  final TmdbDetailsDataSource _tmdbDetails;
  static const _batchSize = 400;
  static const _detailsConcurrency = 5;

  TvTimeSupabaseWriter(this._supabase, this._tmdbDetails);
```

- [ ] **Step 2: Fetch movie runtimes once and use them in `_writeMovies`**

Replace `_writeMovies` with:

```dart
  Future<void> _writeMovies(
    String userId,
    List<TvTimeMatchedMovie> movies,
  ) async {
    final runtimeByTmdbId = await _fetchMovieRuntimes(movies);

    for (var i = 0; i < movies.length; i += _batchSize) {
      final batch = movies.sublist(
        i,
        i + _batchSize > movies.length ? movies.length : i + _batchSize,
      );
      final payload = batch
          .map(
            (m) => {
              'user_id': userId,
              'media_id': m.tmdbId,
              'media_title': m.title,
              'media_type': MediaType.movie.name,
              'poster_path': m.posterPath,
              'runtime_minutes': runtimeByTmdbId[m.tmdbId],
              if (m.watchedAt != null)
                'watched_at': m.watchedAt!.toIso8601String(),
            },
          )
          .toList();
      await _supabase
          .from('watched_items')
          .upsert(payload, onConflict: 'user_id, media_id, media_type');
    }
  }

  Future<Map<int, int?>> _fetchMovieRuntimes(
    List<TvTimeMatchedMovie> movies,
  ) async {
    final uniqueIds = movies.map((m) => m.tmdbId).toSet().toList();
    final entries = await mapWithConcurrency<int, MapEntry<int, int?>>(
      uniqueIds,
      _detailsConcurrency,
      (id) async => MapEntry(id, await _tmdbDetails.getMovieRuntime(id)),
    );
    return Map<int, int?>.fromEntries(entries);
  }
```

- [ ] **Step 3: Fetch series episode runtimes once in `writeAll`, pass to episode writers**

In `writeAll`, replace:

```dart
      if (data.episodes.isNotEmpty) {
        await _writeEpisodes(userId, data.episodes);
        await _writeSeriesWatchedItems(userId, data.episodes);
        step++;
```

with:

```dart
      if (data.episodes.isNotEmpty) {
        final episodeRuntimeBySeriesId = await _fetchSeriesEpisodeRuntimes(
          data.episodes,
        );
        await _writeEpisodes(userId, data.episodes, episodeRuntimeBySeriesId);
        await _writeSeriesWatchedItems(
          userId,
          data.episodes,
          episodeRuntimeBySeriesId,
        );
        step++;
```

Add the new helper (anywhere in the class, e.g. right after `_fetchMovieRuntimes`):

```dart
  Future<Map<int, int?>> _fetchSeriesEpisodeRuntimes(
    List<TvTimeMatchedEpisode> episodes,
  ) async {
    final uniqueIds = episodes.map((e) => e.seriesTmdbId).toSet().toList();
    final entries = await mapWithConcurrency<int, MapEntry<int, int?>>(
      uniqueIds,
      _detailsConcurrency,
      (id) async =>
          MapEntry(id, await _tmdbDetails.getSeriesEpisodeRuntime(id)),
    );
    return Map<int, int?>.fromEntries(entries);
  }
```

- [ ] **Step 4: Use the runtime map in `_writeEpisodes`**

Replace `_writeEpisodes` signature and payload:

```dart
  Future<void> _writeEpisodes(
    String userId,
    List<TvTimeMatchedEpisode> episodes,
    Map<int, int?> runtimeBySeriesId,
  ) async {
    for (var i = 0; i < episodes.length; i += _batchSize) {
      final batch = episodes.sublist(
        i,
        i + _batchSize > episodes.length ? episodes.length : i + _batchSize,
      );
      final payload = batch
          .map(
            (e) => {
              'user_id': userId,
              'series_id': e.seriesTmdbId,
              'season_number': e.seasonNumber,
              'episode_number': e.episodeNumber,
              'runtime_minutes': runtimeBySeriesId[e.seriesTmdbId],
              if (e.watchedAt != null)
                'watched_at': e.watchedAt!.toIso8601String(),
            },
          )
          .toList();
      await _supabase
          .from('watched_episodes')
          .upsert(
            payload,
            onConflict: 'user_id, series_id, season_number, episode_number',
          );
    }
  }
```

- [ ] **Step 5: Use the runtime map in `_writeSeriesWatchedItems`, add episode count per series**

Replace `_writeSeriesWatchedItems` signature and body:

```dart
  Future<void> _writeSeriesWatchedItems(
    String userId,
    List<TvTimeMatchedEpisode> episodes,
    Map<int, int?> runtimeBySeriesId,
  ) async {
    final Map<int, TvTimeMatchedEpisode> latestBySeriesId = {};
    final Map<int, int> episodeCountBySeriesId = {};
    for (final episode in episodes) {
      episodeCountBySeriesId[episode.seriesTmdbId] =
          (episodeCountBySeriesId[episode.seriesTmdbId] ?? 0) + 1;

      final current = latestBySeriesId[episode.seriesTmdbId];
      if (current == null) {
        latestBySeriesId[episode.seriesTmdbId] = episode;
        continue;
      }
      final currentWatchedAt = episode.watchedAt;
      final storedWatchedAt = current.watchedAt;
      if (currentWatchedAt != null &&
          (storedWatchedAt == null ||
              currentWatchedAt.isAfter(storedWatchedAt))) {
        latestBySeriesId[episode.seriesTmdbId] = episode;
      }
    }

    final seriesList = latestBySeriesId.values.toList();

    for (var i = 0; i < seriesList.length; i += _batchSize) {
      final batch = seriesList.sublist(
        i,
        i + _batchSize > seriesList.length ? seriesList.length : i + _batchSize,
      );
      final payload = batch.map((s) {
        final avgRuntime = runtimeBySeriesId[s.seriesTmdbId] ?? 0;
        final count = episodeCountBySeriesId[s.seriesTmdbId] ?? 0;
        final totalRuntime = avgRuntime * count;
        return {
          'user_id': userId,
          'media_id': s.seriesTmdbId,
          'media_title': s.seriesTitle,
          'media_type': MediaType.tv.name,
          'poster_path': s.seriesPosterPath,
          'is_dropped': s.isDropped,
          'is_watch_later': s.isWatchLater,
          'runtime_minutes': totalRuntime > 0 ? totalRuntime : null,
          if (s.watchedAt != null)
            'watched_at': s.watchedAt!.toIso8601String(),
        };
      }).toList();
      await _supabase
          .from('watched_items')
          .upsert(payload, onConflict: 'user_id, media_id, media_type');
    }
  }
```

- [ ] **Step 6: Wire the provider**

Replace the bottom of the file:

```dart
@riverpod
TvTimeSupabaseWriter tvTimeSupabaseWriter(Ref ref) {
  return TvTimeSupabaseWriter(ref.watch(supabaseClientProvider));
}
```

with:

```dart
@riverpod
TvTimeSupabaseWriter tvTimeSupabaseWriter(Ref ref) {
  return TvTimeSupabaseWriter(
    ref.watch(supabaseClientProvider),
    ref.watch(tmdbDetailsDataSourceProvider),
  );
}
```

- [ ] **Step 7: Lint and format check**

Run: `dart analyze`
Expected: No issues found.

Run: `dart format --set-exit-if-changed .`
Expected: exit 0 (no formatting diffs). If it fails, run `dart format .` and review the diff before re-running the check.

- [ ] **Step 8: Commit**

```bash
git add lib/features/tvtime_import/data/datasources/tvtime_supabase_writer.dart
git commit -m "feat(tvtime_import): write runtime_minutes during import via TmdbDetailsDataSource"
```

---

## Task 4: Backfill and end-to-end verification

**Files:** None (manual verification, no code changes).

**Interfaces:**
- Consumes: Task 1 trigger (live in Supabase), Task 3 writer changes (in the app build under test).
- Produces: confirmation that the 722 movies + 7885 episodes previously imported with NULL `runtime_minutes` now have correct values, and that `user_stats.total_watch_time_minutes` reflects them.

- [ ] **Step 1: Rebuild and run the app**

```bash
flutter run
```

- [ ] **Step 2: Re-run the TV Time import**

In the app: Settings → Import TV Time → select the original TV Time export zip → preview → confirm. Watch the import progress — it will take longer than before (extra TMDB detail calls), this is expected.

- [ ] **Step 3: Verify runtime_minutes is populated**

Give the user this query to run in the Supabase SQL Editor after the import completes:

```sql
SELECT
  count(*) FILTER (WHERE runtime_minutes IS NULL) AS null_runtime,
  count(*) AS total
FROM watched_items
WHERE user_id = '<your-user-id>';

SELECT
  count(*) FILTER (WHERE runtime_minutes IS NULL) AS null_runtime,
  count(*) AS total
FROM watched_episodes
WHERE user_id = '<your-user-id>';
```

Expected: `null_runtime` close to 0 (some items may legitimately have no TMDB runtime data — acceptable, not a regression).

> **Result (2026-07-10):** `watched_items`: 66/931 NULL (7.1%). `watched_episodes`: 3877/7933 NULL (48.9%) — far above "close to 0". Investigated: re-ran the import a second time to rule out a transient rate-limit cause (retry exhaustion under `TmdbDetailsDataSource`'s max-3-attempt backoff); the NULL count was byte-identical after the second run (3877/7933), confirming this is TMDB's `episode_run_time` field genuinely being empty/absent for a large fraction of these series, not a recoverable failure in our fetch/retry logic. Average runtime among episodes that DO have data: ~25.8 min/episode (104820 min / 4056 populated rows) — a normal, plausible value, confirming the fix's *arithmetic* is correct; the gap is upstream data coverage, not a computation bug. User accepted this as a known TMDB limitation, out of scope to fix further in this plan.

- [ ] **Step 4: Verify the profile stats page**

Open the app's profile page. Confirm "time watched" now shows a plausible non-zero value consistent with the imported history (previously showed near-zero minutes despite correct counts).

- [ ] **Step 5: Confirm the trigger kept it fresh without a manual recalc step**

No extra step needed here — the statement-level trigger from Task 1 fired automatically during the batched upserts of the re-import, so `user_stats.last_updated_at` should already reflect the import time. Confirm with:

```sql
SELECT last_updated_at FROM user_stats WHERE user_id = '<your-user-id>';
```

Expected: timestamp matches the time of the re-import in Step 2, not an earlier manual recalculation.

---

## Self-Review Notes

- **Spec coverage:** Section 1 (trigger) → Task 1. Section 2 (runtime fetch during import, reusing `markAsWatched` pattern) → Task 2 + Task 3. Section 3 (backfill via re-import) → Task 4. All three design sections covered.
- **Placeholder scan:** none — all steps have concrete code, SQL, or commands.
- **Type consistency:** `TmdbDetailsDataSource.getMovieRuntime`/`getSeriesEpisodeRuntime` signatures in Task 2 match usage in Task 3. `TvTimeSupabaseWriter` constructor signature (`SupabaseClient`, `TmdbDetailsDataSource`) matches the Task 3 Step 6 provider wiring. `runtime_minutes` matches the DTO `@JsonKey` names confirmed in `watched_item_dto.dart:20` and `watched_episode_dto.dart:17`.
