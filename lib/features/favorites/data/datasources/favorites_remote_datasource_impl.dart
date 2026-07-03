import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/core/utils/logger.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../models/favorite_item_dto.dart';
import '../../domain/failures/favorite_failure.dart';
import 'i_favorites_remote_datasource.dart';

part 'favorites_remote_datasource_impl.g.dart';

/*
SQL SCHEMA (already created in Supabase, see task notes):
──────────────────────────────────────────────────────
Table: favorites
  - id:          uuid, primary key, default gen_random_uuid()
  - user_id:     uuid, not null, references auth.users(id) on delete cascade
  - media_id:    integer, not null
  - media_title: text, not null
  - media_type:  text, not null   ('movie' | 'tv')
  - poster_path: text, nullable
  - created_at:  timestamptz, default now()
  - UNIQUE(user_id, media_id, media_type)

RLS Policies:
  - favorites_owner_select (SELECT), favorites_owner_insert (INSERT),
    favorites_owner_delete (DELETE): auth.uid() = user_id
──────────────────────────────────────────────────────
*/

class FavoritesRemoteDataSourceImpl implements IFavoritesRemoteDataSource {
  final SupabaseClient _supabase;

  FavoritesRemoteDataSourceImpl(this._supabase);

  @override
  Future<void> addFavorite(FavoriteItemDto item) async {
    try {
      final json = item.toJson();
      if (item.id.isEmpty) json.remove('id');
      if (item.createdAt == null) json.remove('created_at');

      await _supabase
          .from('favorites')
          .upsert(json, onConflict: 'user_id, media_id, media_type');
    } on PostgrestException catch (e) {
      AppLogger.error('addFavorite failed', tag: 'FavoritesDS', exception: e);
      throw SupabaseFavoriteFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'addFavorite unexpected',
        tag: 'FavoritesDS',
        exception: e,
      );
      throw const FavoriteGenericFailure();
    }
  }

  @override
  Future<void> removeFavorite({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    try {
      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType.name);
    } on PostgrestException catch (e) {
      AppLogger.error(
        'removeFavorite failed',
        tag: 'FavoritesDS',
        exception: e,
      );
      throw SupabaseFavoriteFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'removeFavorite unexpected',
        tag: 'FavoritesDS',
        exception: e,
      );
      throw const FavoriteGenericFailure();
    }
  }

  @override
  Stream<List<FavoriteItemDto>> watchUserFavorites(String userId) {
    return _supabase
        .from('favorites')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map(
          (data) => data.map((json) => FavoriteItemDto.fromJson(json)).toList(),
        );
  }

  @override
  Future<bool> isFavorite({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    try {
      final response = await _supabase
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('media_id', mediaId)
          .eq('media_type', mediaType.name)
          .maybeSingle();
      return response != null;
    } on PostgrestException catch (e) {
      AppLogger.error('isFavorite failed', tag: 'FavoritesDS', exception: e);
      throw SupabaseFavoriteFailure(e.message);
    } catch (e) {
      AppLogger.error(
        'isFavorite unexpected',
        tag: 'FavoritesDS',
        exception: e,
      );
      throw const FavoriteGenericFailure();
    }
  }
}

@riverpod
IFavoritesRemoteDataSource favoritesRemoteDataSource(Ref ref) {
  return FavoritesRemoteDataSourceImpl(ref.watch(supabaseClientProvider));
}
