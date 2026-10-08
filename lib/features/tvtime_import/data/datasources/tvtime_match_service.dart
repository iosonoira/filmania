import 'dart:async';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/utils/concurrency.dart';
import 'package:filmania/domain/models/tvtime_raw_export.dart';
import 'package:filmania/domain/models/tvtime_matched_data.dart';
import 'package:filmania/domain/models/tvtime_import_progress.dart';
import 'package:filmania/domain/models/tvtime_import_phase.dart';
import 'package:filmania/features/tvtime_import/data/datasources/tmdb_find_datasource.dart';

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
        await mapWithConcurrency<dynamic, TvTimeMatchedMovie?>(
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
    // come "Interrotta" in Filmania. "watch_later" è mappato allo stesso
    // modo su isWatchLater — vedi ADR 0002 nel vault second-brain: le serie
    // watch_later hanno sempre già ≥1 episodio visto (a differenza di
    // not_started_yet, sempre 0), sono un concetto distinto da "mai iniziata"
    // e vanno preservate, non scartate.
    final droppedTvdbIds = raw.series
        .where((s) => s.status == 'stopped')
        .map((s) => s.tvdbId)
        .toSet();
    final watchLaterTvdbIds = raw.series
        .where((s) => s.status == 'watch_later')
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
    await mapWithConcurrency<String, void>(
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
        final isWatchLater = watchLaterTvdbIds.contains(seriesTvdbId);
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
              isWatchLater: isWatchLater,
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
