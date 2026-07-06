import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/core/utils/logger.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../models/watched_episode_dto.dart';
import '../models/watched_item_dto.dart';
import '../../domain/failures/watched_failure.dart';
import 'i_watched_remote_datasource.dart';

part 'watched_remote_datasource_impl.g.dart';

/*
SQL SCHEMA REQUIRED IN SUPABASE:
──────────────────────────────────────────────────────
Table: watched_items
  - id:          uuid, primary key, default gen_random_uuid()
  - user_id:     uuid, not null, references auth.users(id) on delete cascade
  - media_id:    integer, not null
  - media_title: text, not null
  - media_type:  text, not null   ('movie' | 'tv')
  - poster_path: text, nullable
  - watched_at:  timestamptz, default now()
  - is_dropped:  boolean, not null, default false
  - is_watch_later: boolean, not null, default false
  - UNIQUE(user_id, media_id, media_type)

Table: watched_episodes
  - id:             uuid, primary key, default gen_random_uuid()
  - user_id:        uuid, not null, references auth.users(id) on delete cascade
  - series_id:      integer, not null
  - season_number:  integer, not null
  - episode_number: integer, not null
  - watched_at:     timestamptz, default now()
  - UNIQUE(user_id, series_id, season_number, episode_number)

RLS Policies:
  - SELECT, INSERT, DELETE (to both tables): auth.uid() = user_id
──────────────────────────────────────────────────────
*/

class WatchedRemoteDataSourceImpl implements IWatchedRemoteDataSource {
  final SupabaseClient _supabase;

  WatchedRemoteDataSourceImpl(this._supabase);

  @override
  Future<void> markAsWatched(WatchedItemDto item) async {
    try {
      final json = item.toJson();
      if (item.id.isEmpty) json.remove('id');
      if (item.watchedAt == null) json.remove('watched_at');

      await _supabase
          .from('watched_items')
          .upsert(json, onConflict: 'user_id, media_id, media_type');
    } on PostgrestException catch (e) {
      AppLogger.error('markAsWatched failed', tag: 'WatchedDS', exception: e);
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'markAsWatched unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }

  @override
  Future<void> markTVSeriesAsWatchedBatchRPC({
    required int seriesId,
    required String seriesTitle,
    required String? posterPath,
    required List<Map<String, int>> episodes,
  }) async {
    try {
      await _supabase.rpc(
        'mark_tv_series_full_watched_rpc',
        params: {
          'p_series_id': seriesId,
          'p_series_title': seriesTitle,
          'p_poster_path': posterPath,
          'p_episodes': episodes,
        },
      );
    } on PostgrestException catch (e) {
      AppLogger.error(
        'markTVSeriesAsWatchedBatchRPC failed',
        tag: 'WatchedDS',
        exception: e,
      );
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'markTVSeriesAsWatchedBatchRPC unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }

  @override
  Future<void> removeFromWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    try {
      await _supabase
          .from('watched_items')
          .delete()
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType.name);
    } on PostgrestException catch (e) {
      AppLogger.error(
        'removeFromWatched failed',
        tag: 'WatchedDS',
        exception: e,
      );
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'removeFromWatched unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }

  @override
  Stream<List<WatchedItemDto>> watchUserWatchedItems(
    String userId,
    MediaType mediaType,
  ) {
    return _supabase
        .from('watched_items')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('watched_at', ascending: false)
        .map((data) {
          AppLogger.debug(
            '[DIAG] watchUserWatchedItems emission: ${data.length} total '
            'rows, mediaType=$mediaType, at ${DateTime.now()}',
            tag: 'WatchedDS',
          );
          return data
              .where((json) => json['media_type'] == mediaType.name)
              .map((json) => WatchedItemDto.fromJson(json))
              .toList();
        });
  }

  @override
  Future<bool> isWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    try {
      final response = await _supabase
          .from('watched_items')
          .select('id')
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType.name)
          .maybeSingle();
      return response != null;
    } on PostgrestException catch (e) {
      AppLogger.error('isWatched failed', tag: 'WatchedDS', exception: e);
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error('isWatched unexpected', tag: 'WatchedDS', exception: e);
      throw const WatchedGenericFailure();
    }
  }

  @override
  Future<void> markEpisodeAsWatched(WatchedEpisodeDto episode) async {
    await markEpisodesAsWatched([episode]);
  }

  @override
  Future<void> markEpisodesAsWatched(List<WatchedEpisodeDto> episodes) async {
    if (episodes.isEmpty) return;
    try {
      final jsonList = episodes.map((e) {
        final json = e.toJson();
        if (e.id == null || e.id!.isEmpty) json.remove('id');
        if (e.watchedAt == null) json.remove('watched_at');
        return json;
      }).toList();

      await _supabase
          .from('watched_episodes')
          .upsert(
            jsonList,
            onConflict: 'user_id, series_id, season_number, episode_number',
          );
    } on PostgrestException catch (e) {
      AppLogger.error(
        'markEpisodesAsWatched failed',
        tag: 'WatchedDS',
        exception: e,
      );
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'markEpisodesAsWatched unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }

  @override
  Future<void> markEpisodeAsUnwatched({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
  }) async {
    try {
      await _supabase
          .from('watched_episodes')
          .delete()
          .eq('user_id', userId)
          .eq('series_id', seriesId)
          .eq('season_number', seasonNumber)
          .eq('episode_number', episodeNumber);
    } on PostgrestException catch (e) {
      AppLogger.error(
        'markEpisodeAsUnwatched failed',
        tag: 'WatchedDS',
        exception: e,
      );
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'markEpisodeAsUnwatched unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }

  @override
  Future<bool> isEpisodeWatched({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
  }) async {
    try {
      final response = await _supabase
          .from('watched_episodes')
          .select('id')
          .eq('user_id', userId)
          .eq('series_id', seriesId)
          .eq('season_number', seasonNumber)
          .eq('episode_number', episodeNumber)
          .maybeSingle();
      return response != null;
    } on PostgrestException catch (e) {
      AppLogger.error(
        'isEpisodeWatched failed',
        tag: 'WatchedDS',
        exception: e,
      );
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'isEpisodeWatched unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }

  @override
  Stream<List<WatchedEpisodeDto>> watchWatchedEpisodes(
    String userId,
    int seriesId,
  ) {
    return _supabase
        .from('watched_episodes')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map(
          (data) => data
              .where((json) => json['series_id'] == seriesId)
              .map((json) => WatchedEpisodeDto.fromJson(json))
              .toList(),
        );
  }

  @override
  Future<void> removeAllEpisodesFromWatched({
    required String userId,
    required int seriesId,
  }) async {
    try {
      await _supabase
          .from('watched_episodes')
          .delete()
          .eq('user_id', userId)
          .eq('series_id', seriesId);
    } on PostgrestException catch (e) {
      AppLogger.error(
        'removeAllEpisodesFromWatched failed',
        tag: 'WatchedDS',
        exception: e,
      );
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'removeAllEpisodesFromWatched unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }

  @override
  Future<int> getWatchedEpisodesCount({
    required String userId,
    required int seriesId,
  }) async {
    try {
      final response = await _supabase
          .from('watched_episodes')
          .select('id')
          .eq('user_id', userId)
          .eq('series_id', seriesId);
      return response.length;
    } on PostgrestException catch (e) {
      AppLogger.error(
        'getWatchedEpisodesCount failed',
        tag: 'WatchedDS',
        exception: e,
      );
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'getWatchedEpisodesCount unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }

  @override
  Future<Map<int, int>> getWatchedEpisodesCountsForSeries({
    required String userId,
    required List<int> seriesIds,
  }) async {
    if (seriesIds.isEmpty) return {};

    try {
      // NOTA: Supabase/PostgREST limita di default le risposte a 1000 righe
      // (non configurabile lato client, solo lato progetto). Con la
      // libreria attuale (~100 film/serie totali) non è un problema
      // osservabile. Se in futuro un utente avesse migliaia di episodi
      // visti distribuiti su molte serie, questa query potrebbe troncare
      // silenziosamente il risultato oltre le 1000 righe: in quel caso
      // paginare con `.range()` (già usato altrove nel progetto) finché
      // il numero di righe ricevute non è più uguale al totale atteso.
      // Non implementato preventivamente ora per non aggiungere complessità
      // non necessaria al volume attuale.
      final response = await _supabase
          .from('watched_episodes')
          .select('series_id')
          .eq('user_id', userId)
          .inFilter('series_id', seriesIds);

      final counts = <int, int>{};
      for (final row in response) {
        final seriesId = row['series_id'] as int;
        counts[seriesId] = (counts[seriesId] ?? 0) + 1;
      }
      return counts;
    } on PostgrestException catch (e) {
      AppLogger.error(
        'getWatchedEpisodesCountsForSeries failed',
        tag: 'WatchedDS',
        exception: e,
      );
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'getWatchedEpisodesCountsForSeries unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }

  @override
  Future<void> markSeriesAsDropped({
    required String userId,
    required int seriesId,
    required bool isDropped,
  }) async {
    try {
      await _supabase
          .from('watched_items')
          .update({'is_dropped': isDropped})
          .eq('user_id', userId)
          .eq('media_id', seriesId)
          .eq('media_type', MediaType.tv.name);
    } on PostgrestException catch (e) {
      AppLogger.error(
        'markSeriesAsDropped failed',
        tag: 'WatchedDS',
        exception: e,
      );
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'markSeriesAsDropped unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }

  @override
  Future<void> markSeriesAsWatchLater({
    required String userId,
    required int seriesId,
    required bool isWatchLater,
  }) async {
    try {
      await _supabase
          .from('watched_items')
          .update({'is_watch_later': isWatchLater})
          .eq('user_id', userId)
          .eq('media_id', seriesId)
          .eq('media_type', MediaType.tv.name);
    } on PostgrestException catch (e) {
      AppLogger.error(
        'markSeriesAsWatchLater failed',
        tag: 'WatchedDS',
        exception: e,
      );
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'markSeriesAsWatchLater unexpected',
        tag: 'WatchedDS',
        exception: e,
      );
      throw const WatchedGenericFailure();
    }
  }
}

@riverpod
IWatchedRemoteDataSource watchedRemoteDataSource(Ref ref) {
  return WatchedRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
}
