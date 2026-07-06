import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/core/utils/logger.dart';
import 'package:filmania/core/supabase/supabase_client.dart';
import '../../domain/entities/tvtime_matched_data.dart';
import '../../domain/entities/tvtime_import_progress.dart';
import '../../domain/enums/tvtime_import_phase.dart';
import '../../domain/failures/tvtime_import_failure.dart';

part 'tvtime_supabase_writer.g.dart';

/*
Scrive direttamente sulle tabelle già esistenti e già usate da altre feature.
Schema di riferimento (NON creare nuove tabelle, sono già presenti):
  watched_items(user_id, media_id, media_title, media_type, poster_path, watched_at)
    UNIQUE(user_id, media_id, media_type)
  watched_episodes(user_id, series_id, season_number, episode_number, watched_at)
    UNIQUE(user_id, series_id, season_number, episode_number)
  watchlists(user_id, name)
  watchlist_items(watchlist_id, media_id, media_title, media_type, poster_path)
    UNIQUE(watchlist_id, media_id, media_type)

Questa feature ha il proprio datasource per non dipendere da
WatchedRemoteDataSourceImpl/WatchlistRemoteDataSourceImpl (vedi ADR
0001-tvtime-import-architecture nel vault second-brain: scelta esplicita di
NON introdurre dipendenze cross-feature per un'operazione usa-e-getta).
*/
class TvTimeSupabaseWriter {
  final SupabaseClient _supabase;
  static const _batchSize = 400;

  TvTimeSupabaseWriter(this._supabase);

  String get _userId {
    final id = _supabase.auth.currentUser?.id;
    if (id == null) {
      throw const TvTimeSupabaseWriteFailure(
        'Utente non autenticato: impossibile scrivere i dati importati.',
      );
    }
    return id;
  }

  Future<void> writeAll(
    TvTimeMatchResult data, {
    required void Function(TvTimeImportProgress progress) onProgress,
  }) async {
    try {
      final userId = _userId;
      final totalSteps =
          (data.movies.isNotEmpty ? 1 : 0) +
          (data.episodes.isNotEmpty ? 1 : 0) +
          data.lists.length;
      var step = 0;

      if (data.movies.isNotEmpty) {
        await _writeMovies(userId, data.movies);
        step++;
        onProgress(
          TvTimeImportProgress(
            phase: TvTimeImportPhase.writingData,
            current: step,
            total: totalSteps == 0 ? 1 : totalSteps,
          ),
        );
      }

      if (data.episodes.isNotEmpty) {
        await _writeEpisodes(userId, data.episodes);
        await _writeSeriesWatchedItems(userId, data.episodes);
        step++;
        onProgress(
          TvTimeImportProgress(
            phase: TvTimeImportPhase.writingData,
            current: step,
            total: totalSteps == 0 ? 1 : totalSteps,
          ),
        );
      }

      for (final list in data.lists) {
        await _writeList(userId, list);
        step++;
        onProgress(
          TvTimeImportProgress(
            phase: TvTimeImportPhase.writingData,
            current: step,
            total: totalSteps == 0 ? 1 : totalSteps,
          ),
        );
      }
    } on PostgrestException catch (e) {
      AppLogger.error(
        'TvTime writeAll failed',
        tag: 'TvTimeWriter',
        exception: e,
      );
      throw TvTimeSupabaseWriteFailure(e.message);
    } on TvTimeImportFailure {
      rethrow;
    } catch (e) {
      AppLogger.error(
        'TvTime writeAll unexpected',
        tag: 'TvTimeWriter',
        exception: e,
      );
      throw const TvTimeGenericImportFailure();
    }
  }

  Future<void> _writeMovies(
    String userId,
    List<TvTimeMatchedMovie> movies,
  ) async {
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

  Future<void> _writeEpisodes(
    String userId,
    List<TvTimeMatchedEpisode> episodes,
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

  /// Scrive una riga di riepilogo per serie su `watched_items` (media_type='tv'),
  /// mancante rispetto a `_writeEpisodes` che scrive solo su `watched_episodes`.
  /// Senza questa riga, `categorizedTvSeries` (features/watched) non trova mai
  /// le serie importate e le 4 categorie del profilo restano vuote, anche se
  /// gli episodi risultano correttamente visti in `watched_episodes`.
  ///
  /// Raggruppa gli episodi per serie e usa, come rappresentante della serie,
  /// l'episodio con `watchedAt` più recente (titolo/poster/data da quello).
  /// Se nessun episodio della serie ha `watchedAt`, usa il primo episodio
  /// incontrato e omette `watched_at` (stesso pattern di `_writeMovies`).
  Future<void> _writeSeriesWatchedItems(
    String userId,
    List<TvTimeMatchedEpisode> episodes,
  ) async {
    final Map<int, TvTimeMatchedEpisode> latestBySeriesId = {};
    for (final episode in episodes) {
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
      final payload = batch
          .map(
            (s) => {
              'user_id': userId,
              'media_id': s.seriesTmdbId,
              'media_title': s.seriesTitle,
              'media_type': MediaType.tv.name,
              'poster_path': s.seriesPosterPath,
              'is_dropped': s.isDropped,
              'is_watch_later': s.isWatchLater,
              if (s.watchedAt != null)
                'watched_at': s.watchedAt!.toIso8601String(),
            },
          )
          .toList();
      await _supabase
          .from('watched_items')
          .upsert(payload, onConflict: 'user_id, media_id, media_type');
    }
  }

  Future<void> _writeList(String userId, TvTimeMatchedList list) async {
    final watchlistId = await _getOrCreateWatchlist(userId, list.name);
    for (var i = 0; i < list.items.length; i += _batchSize) {
      final batch = list.items.sublist(
        i,
        i + _batchSize > list.items.length ? list.items.length : i + _batchSize,
      );
      final payload = batch
          .map(
            (item) => {
              'watchlist_id': watchlistId,
              'media_id': item.tmdbId,
              'media_title': item.title,
              'media_type': item.mediaType.name,
              'poster_path': item.posterPath,
            },
          )
          .toList();
      await _supabase
          .from('watchlist_items')
          .upsert(payload, onConflict: 'watchlist_id, media_id, media_type');
    }
  }

  Future<String> _getOrCreateWatchlist(String userId, String name) async {
    final existing = await _supabase
        .from('watchlists')
        .select('id')
        .eq('user_id', userId)
        .eq('name', name)
        .limit(1)
        .maybeSingle();
    if (existing != null) return existing['id'] as String;
    final created = await _supabase
        .from('watchlists')
        .insert({'user_id': userId, 'name': name})
        .select()
        .single();
    return created['id'] as String;
  }
}

@riverpod
TvTimeSupabaseWriter tvTimeSupabaseWriter(Ref ref) {
  return TvTimeSupabaseWriter(ref.watch(supabaseClientProvider));
}
