import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/repositories/i_favorites_repository.dart';
import '../datasources/i_favorites_remote_datasource.dart';
import '../datasources/favorites_remote_datasource_impl.dart';
import '../models/favorite_item_dto.dart';

part 'favorites_repository_impl.g.dart';

class FavoritesRepositoryImpl implements IFavoritesRepository {
  final IFavoritesRemoteDataSource _remoteDS;

  FavoritesRepositoryImpl(this._remoteDS);

  @override
  Future<void> addFavorite(FavoriteItem item) {
    return _remoteDS.addFavorite(FavoriteItemDto.fromEntity(item));
  }

  @override
  Future<void> removeFavorite({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) {
    return _remoteDS.removeFavorite(
      userId: userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
  }

  @override
  Stream<List<FavoriteItem>> watchUserFavorites(String userId) {
    return _remoteDS
        .watchUserFavorites(userId)
        .map((dtos) => dtos.map((dto) => dto.toEntity()).toList());
  }

  @override
  Future<bool> isFavorite({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) {
    return _remoteDS.isFavorite(
      userId: userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
  }
}

@riverpod
IFavoritesRepository favoritesRepository(Ref ref) {
  return FavoritesRepositoryImpl(ref.watch(favoritesRemoteDataSourceProvider));
}
