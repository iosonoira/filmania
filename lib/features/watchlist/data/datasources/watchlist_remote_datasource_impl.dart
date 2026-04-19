import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/core/utils/logger.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../models/watchlist_item_dto.dart';
import '../models/watchlist_dto.dart';
import '../../domain/failures/watchlist_failure.dart';
import 'i_watchlist_remote_datasource.dart';

part 'watchlist_remote_datasource_impl.g.dart';

/*
SQL SCHEMA:
──────────────────────────────────────────────────────

Table: watchlists
  - id:         uuid, primary key, default gen_random_uuid()
  - user_id:    uuid, not null, references auth.users(id) on delete cascade
  - name:       text, not null
  - created_at: timestamptz, default now()

RLS Policies for watchlists:
  - SELECT:  auth.uid() = user_id
  - INSERT:  auth.uid() = user_id
  - DELETE:  auth.uid() = user_id

──────────────────────────────────────────────────────

Table: watchlist_items   (renamed from 'watchlist')
  - id:           uuid, primary key, default gen_random_uuid()
  - watchlist_id: uuid, not null, references watchlists(id) on delete cascade
  - media_id:     integer, not null
  - media_title:  text, not null
  - media_type:   text, not null   ('movie' | 'tv')
  - poster_path:  text, nullable
  - added_at:     timestamptz, default now()
  - UNIQUE(watchlist_id, media_id, media_type)

RLS Policies for watchlist_items:
  - SELECT:  auth.uid() = user_id
  - INSERT:  auth.uid() = user_id
  - DELETE:  auth.uid() = user_id
*/

class WatchlistRemoteDataSourceImpl implements IWatchlistRemoteDataSource {
  final SupabaseClient _supabase;

  WatchlistRemoteDataSourceImpl(this._supabase);

  // ── Watchlist CRUD ──────────────────────────────────────────────────────────

  @override
  Future<WatchlistDto> createWatchlist({
    required String userId,
    required String name,
  }) async {
    try {
      final response = await _supabase
          .from('watchlists')
          .insert({'user_id': userId, 'name': name})
          .select()
          .single();
      return WatchlistDto.fromJson(response);
    } on PostgrestException catch (e) {
      AppLogger.error('createWatchlist failed', tag: 'WatchlistDS', exception: e);
      throw SupabaseFailure(e.message);
    } catch (e) {
      AppLogger.error('createWatchlist unexpected', tag: 'WatchlistDS', exception: e);
      throw const WatchlistGenericFailure();
    }
  }

  @override
  Future<void> deleteWatchlist(String watchlistId) async {
    try {
      await _supabase.from('watchlists').delete().eq('id', watchlistId);
    } on PostgrestException catch (e) {
      AppLogger.error('deleteWatchlist failed', tag: 'WatchlistDS', exception: e);
      throw SupabaseFailure(e.message);
    } catch (e) {
      AppLogger.error('deleteWatchlist unexpected', tag: 'WatchlistDS', exception: e);
      throw const WatchlistGenericFailure();
    }
  }

  @override
  Stream<List<WatchlistDto>> watchUserWatchlists(String userId) {
    return _supabase
        .from('watchlists')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => WatchlistDto.fromJson(json)).toList());
  }

  // ── Item CRUD ───────────────────────────────────────────────────────────────

  @override
  Future<void> addToWatchlist(WatchlistItemDto item) async {
    try {
      final json = item.toJson();
      if (item.id.isEmpty) json.remove('id');
      await _supabase.from('watchlist_items').insert(json);
    } on PostgrestException catch (e) {
      AppLogger.error('addToWatchlist failed', tag: 'WatchlistDS', exception: e);
      throw SupabaseFailure(e.message);
    } catch (e) {
      AppLogger.error('addToWatchlist unexpected', tag: 'WatchlistDS', exception: e);
      throw const WatchlistGenericFailure();
    }
  }

  @override
  Future<void> removeFromWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
    required String watchlistId,
  }) async {
    try {
      await _supabase
          .from('watchlist_items')
          .delete()
          .eq('media_id', mediaId)
          .eq('media_type', mediaType.name)
          .eq('watchlist_id', watchlistId);
    } on PostgrestException catch (e) {
      AppLogger.error('removeFromWatchlist failed', tag: 'WatchlistDS', exception: e);
      throw SupabaseFailure(e.message);
    } catch (e) {
      AppLogger.error('removeFromWatchlist unexpected', tag: 'WatchlistDS', exception: e);
      throw const WatchlistGenericFailure();
    }
  }

  @override
  Stream<List<WatchlistItemDto>> watchWatchlistItems(String watchlistId) {
    return _supabase
        .from('watchlist_items')
        .stream(primaryKey: ['id'])
        .eq('watchlist_id', watchlistId)
        .order('added_at', ascending: false)
        .map((data) => data.map((json) => WatchlistItemDto.fromJson(json)).toList());
  }

  @override
  Future<List<String>> getWatchlistIdsContainingMedia({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    try {
      final response = await _supabase
          .from('watchlist_items')
          .select('watchlist_id')
          .eq('media_id', mediaId)
          .eq('media_type', mediaType.name);

      return (response as List)
          .map((e) => e['watchlist_id'] as String)
          .toList();
    } on PostgrestException catch (e) {
      AppLogger.error(
        'getWatchlistIdsContainingMedia failed',
        tag: 'WatchlistDS',
        exception: e,
      );
      throw SupabaseFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'getWatchlistIdsContainingMedia unexpected',
        tag: 'WatchlistDS',
        exception: e,
      );
      throw const WatchlistGenericFailure();
    }
  }

  @override
  Stream<List<WatchlistItemDto>> watchWatchlist(String userId) {
    return _supabase
        .from('watchlist_items')
        .stream(primaryKey: ['id'])
        .order('added_at', ascending: false)
        .map((data) => data.map((json) => WatchlistItemDto.fromJson(json)).toList());
  }

  @override
  Future<bool> isInWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    try {
      final response = await _supabase
          .from('watchlist_items')
          .select()
          .eq('media_id', mediaId)
          .eq('media_type', mediaType.name)
          .maybeSingle();
      return response != null;
    } on PostgrestException catch (e) {
      AppLogger.error('isInWatchlist failed', tag: 'WatchlistDS', exception: e);
      throw SupabaseFailure(e.message);
    } catch (e) {
      AppLogger.error('isInWatchlist unexpected', tag: 'WatchlistDS', exception: e);
      throw const WatchlistGenericFailure();
    }
  }
}

@riverpod
IWatchlistRemoteDataSource watchlistRemoteDataSource(Ref ref) {
  return WatchlistRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
}
