import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/core/utils/logger.dart';
import '../../../../core/supabase/supabase_client.dart';
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
  - UNIQUE(user_id, media_id, media_type)

RLS Policies:
  - SELECT, INSERT, DELETE: auth.uid() = user_id
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
      
      await _supabase.from('watched_items').upsert(
        json,
        onConflict: 'user_id, media_id, media_type',
      );
    } on PostgrestException catch (e) {
      AppLogger.error('markAsWatched failed', tag: 'WatchedDS', exception: e);
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error('markAsWatched unexpected', tag: 'WatchedDS', exception: e);
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
      AppLogger.error('removeFromWatched failed', tag: 'WatchedDS', exception: e);
      throw SupabaseWatchedFailure(e.message);
    } catch (e) {
      AppLogger.error('removeFromWatched unexpected', tag: 'WatchedDS', exception: e);
      throw const WatchedGenericFailure();
    }
  }

  @override
  Stream<List<WatchedItemDto>> watchUserWatchedItems(String userId, MediaType mediaType) {
    return _supabase
        .from('watched_items')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('watched_at', ascending: false)
        .map((data) => data
            .where((json) => json['media_type'] == mediaType.name)
            .map((json) => WatchedItemDto.fromJson(json))
            .toList());
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
}

@riverpod
IWatchedRemoteDataSource watchedRemoteDataSource(Ref ref) {
  return WatchedRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
}
