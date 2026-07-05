import 'dart:async';
import 'package:filmania/core/domain/enums/media_type.dart';
import '../../domain/entities/tvtime_raw_export.dart';
import '../../domain/entities/tvtime_matched_data.dart';
import '../../domain/entities/tvtime_import_progress.dart';
import '../../domain/enums/tvtime_import_phase.dart';
import 'tmdb_find_datasource.dart';

/// Esegue N task con al massimo [concurrency] in volo contemporaneamente.
/// Implementazione manuale (niente package esterni): non serve altro che
/// una coda di Future limitata per il volume atteso (centinaia di item, non milioni).
Future<List<R>> _mapWithConcurrency<T, R>(
  List<T> items,
  int concurrency,
  Future<R> Function(T item) worker, {
  void Function()? onEach,
}) async {
  final results = List<R?>.filled(items.length, null);
  var nextIndex = 0;

  Future<void> runWorker() async {
    while (true) {
      final i = nextIndex;
      if (i >= items.length) return;
      nextIndex++;
      results[i] = await worker(items[i]);
      onEach?.call();
    }
  }

  await Future.wait(List.generate(concurrency, (_) => runWorker()));
  return results.cast<R>();
}

class TvTimeMatchService {
  final TmdbFindDataSource _tmdb;
  static const _concurrency = 5;

  TvTimeMatchService(this._tmdb);

  Future<TvTimeMatchResult> matchAll(
    TvTimeRawExport raw, {
    required void Function(TvTimeImportProgress progress) onProgress,
  }) async {
    final unmatched = <UnmatchedTvTimeItem>[];

    // --- Film: solo quelli watched (import di quelli visti, coerente con lo script Python) ---
    final watchedMovies = raw.movies.where((m) => m.isWatched).toList();
    var moviesDone = 0;
    final matchedMoviesNullable =
        await _mapWithConcurrency<dynamic, TvTimeMatchedMovie?>(
          watchedMovies,
          _concurrency,
          (m) async {
            final found = await _tmdb.findMovie(
              imdbId: m.imdbId,
              tvdbId: m.tvdbId,
            );
            if (found == null) {
              unmatched.add(
                UnmatchedTvTimeItem(
                  type: 'movie',
                  title: m.title,
                  reason: 'Nessun match TMDB per imdb_id/tvdb_id',
                ),
              );
              return null;
            }
            return TvTimeMatchedMovie(
              tmdbId: found.tmdbId,
              title: found.title.isEmpty ? m.title : found.title,
              posterPath: found.posterPath,
              watchedAt: _parseDate(m.watchedAt),
            );
          },
          onEach: () {
            moviesDone++;
            onProgress(
              TvTimeImportProgress(
                phase: TvTimeImportPhase.matchingMovies,
                current: moviesDone,
                total: watchedMovies.length,
              ),
            );
          },
        );
    final matchedMovies = matchedMoviesNullable
        .whereType<TvTimeMatchedMovie>()
        .toList();

    // --- Episodi: raggruppa per series_tvdb_id PRIMA di chiamare TMDB (una chiamata per serie, non per episodio) ---
    // Set dei tvdb_id con status "stopped" in tvtime-series-*.csv (se il file
    // era presente nello zip — è opzionale): usato per marcare la serie
    // come "Interrotta" in Filmania.
    final droppedTvdbIds = raw.series
        .where((s) => s.status == 'stopped')
        .map((s) => s.tvdbId)
        .toSet();

    final watchedEpisodes = raw.episodes.where((e) => e.isWatched).toList();
    final episodesBySeries = <String, List<dynamic>>{};
    for (final e in watchedEpisodes) {
      episodesBySeries.putIfAbsent(e.seriesTvdbId, () => []).add(e);
    }
    final seriesIds = episodesBySeries.keys.toList();
    var seriesDone = 0;
    final matchedEpisodes = <TvTimeMatchedEpisode>[];
    await _mapWithConcurrency<String, void>(
      seriesIds,
      _concurrency,
      (seriesTvdbId) async {
        final episodesForSeries = episodesBySeries[seriesTvdbId]!;
        final titleHint =
            (episodesForSeries.first as dynamic).seriesTitleHint as String;
        final found = await _tmdb.findSeries(tvdbId: seriesTvdbId);
        if (found == null) {
          unmatched.add(
            UnmatchedTvTimeItem(
              type: 'series',
              title: titleHint,
              reason: 'Nessun match TMDB per tvdb_id',
            ),
          );
          return;
        }
        final isDropped = droppedTvdbIds.contains(seriesTvdbId);
        for (final e in episodesForSeries) {
          matchedEpisodes.add(
            TvTimeMatchedEpisode(
              seriesTmdbId: found.tmdbId,
              seriesTitle: found.title.isEmpty ? titleHint : found.title,
              seriesPosterPath: found.posterPath,
              seasonNumber: e.season as int,
              episodeNumber: e.episode as int,
              watchedAt: _parseDate(e.watchedAt as String?),
              isDropped: isDropped,
            ),
          );
        }
      },
      onEach: () {
        seriesDone++;
        onProgress(
          TvTimeImportProgress(
            phase: TvTimeImportPhase.matchingSeries,
            current: seriesDone,
            total: seriesIds.length,
          ),
        );
      },
    );

    // --- Liste: raggruppa per list_name, matcha ogni item come film o serie ---
    final listsByName = <String, List<TvTimeMatchedListItem>>{};
    for (final row in raw.lists) {
      if (row.itemType == 'series') {
        final found = await _tmdb.findSeries(tvdbId: row.tvdbId);
        if (found == null) {
          unmatched.add(
            UnmatchedTvTimeItem(
              type: 'series',
              title: row.nameHint,
              reason: 'Nessun match TMDB per tvdb_id (lista)',
            ),
          );
          continue;
        }
        listsByName
            .putIfAbsent(row.listName, () => [])
            .add(
              TvTimeMatchedListItem(
                tmdbId: found.tmdbId,
                title: found.title.isEmpty ? row.nameHint : found.title,
                mediaType: MediaType.tv,
                posterPath: found.posterPath,
              ),
            );
      } else if (row.itemType == 'movie') {
        final movieRow = raw.movies
            .where((m) => m.uuid == row.uuid)
            .firstOrNull;
        final found = await _tmdb.findMovie(
          imdbId: movieRow?.imdbId ?? '',
          tvdbId: movieRow?.tvdbId ?? row.tvdbId,
        );
        if (found == null) {
          unmatched.add(
            UnmatchedTvTimeItem(
              type: 'movie',
              title: row.nameHint,
              reason: 'Nessun match TMDB per imdb_id/tvdb_id (lista)',
            ),
          );
          continue;
        }
        listsByName
            .putIfAbsent(row.listName, () => [])
            .add(
              TvTimeMatchedListItem(
                tmdbId: found.tmdbId,
                title: found.title.isEmpty ? row.nameHint : found.title,
                mediaType: MediaType.movie,
                posterPath: found.posterPath,
              ),
            );
      }
    }
    final matchedLists = listsByName.entries
        .map((e) => TvTimeMatchedList(name: e.key, items: e.value))
        .toList();

    return TvTimeMatchResult(
      movies: matchedMovies,
      episodes: matchedEpisodes,
      lists: matchedLists,
      unmatched: unmatched,
    );
  }

  DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateTime.parse(raw).toUtc();
    } catch (_) {
      return null;
    }
  }
}
