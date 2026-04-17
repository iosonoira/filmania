import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/core/utils/logger.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../models/watchlist_item_dto.dart';
import '../../domain/failures/watchlist_failure.dart';
import 'i_watchlist_remote_datasource.dart';

part 'watchlist_remote_datasource_impl.g.dart';

/*
SQL SCHEMA:
Table: watchlist
  - id: uuid, primary key, default gen_random_uuid()
  - user_id: uuid, not null, references auth.users(id) on delete cascade
  - movie_id: integer, not null
  - movie_title: text, not null
  - poster_path: text, nullable
  - added_at: timestamptz, default now()
  - UNIQUE(user_id, movie_id)

RLS Policies:
  - watchlist_authenticated_select: auth.uid() = user_id (SELECT)
  - watchlist_authenticated_insert: auth.uid() = user_id (INSERT)
  - watchlist_authenticated_delete: auth.uid() = user_id (DELETE)
*/

class WatchlistRemoteDataSourceImpl implements IWatchlistRemoteDataSource {
  final SupabaseClient _supabase;

  WatchlistRemoteDataSourceImpl(this._supabase);

  @override
  Future<void> addToWatchlist(WatchlistItemDto item) async {
    try {
      final json = item.toJson();
      if (item.id.isEmpty) {
        json.remove('id');
      }
      await _supabase.from('watchlist').insert(json);
    } on PostgrestException catch (e) {
      AppLogger.error(
        'addToWatchlist failed',
        tag: 'WatchlistDS',
        exception: e,
      );
      throw SupabaseFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'addToWatchlist unexpected error',
        tag: 'WatchlistDS',
        exception: e,
      );
      throw const WatchlistGenericFailure();
    }
  }

  @override
  Future<void> removeFromWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    try {
      await _supabase
          .from('watchlist')
          .delete()
          .eq('user_id', userId)
          .eq('movie_id', mediaId)
          .eq('media_type', mediaType.name);
    } on PostgrestException catch (e) {
      AppLogger.error(
        'removeFromWatchlist failed',
        tag: 'WatchlistDS',
        exception: e,
      );
      throw SupabaseFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'removeFromWatchlist unexpected error',
        tag: 'WatchlistDS',
        exception: e,
      );
      throw const WatchlistGenericFailure();
    }
  }

  @override
  Stream<List<WatchlistItemDto>> watchWatchlist(String userId) {
    // Supabase .stream handles the Realtime subscribe/unsubscribe internally.
    // The channel is closed when the stream is no longer listened to.
    return _supabase
        .from('watchlist')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('added_at', ascending: false)
        .map(
          (data) =>
              data.map((json) => WatchlistItemDto.fromJson(json)).toList(),
        );
  }

  @override
  Future<bool> isInWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    try {
      final response = await _supabase
          .from('watchlist')
          .select()
          .eq('user_id', userId)
          .eq('movie_id', mediaId)
          .eq('media_type', mediaType.name)
          .maybeSingle();

      return response != null;
    } on PostgrestException catch (e) {
      AppLogger.error('isInWatchlist failed', tag: 'WatchlistDS', exception: e);
      throw SupabaseFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'isInWatchlist unexpected error',
        tag: 'WatchlistDS',
        exception: e,
      );
      throw const WatchlistGenericFailure();
    }
  }
}

@riverpod
IWatchlistRemoteDataSource watchlistRemoteDataSource(Ref ref) {
  return WatchlistRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
}
