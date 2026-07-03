import '../models/favorite_item_dto.dart';
import '../../../../core/domain/enums/media_type.dart';

abstract class IFavoritesRemoteDataSource {
  Future<void> addFavorite(FavoriteItemDto item);
  Future<void> removeFavorite({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
  Stream<List<FavoriteItemDto>> watchUserFavorites(String userId);
  Future<bool> isFavorite({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
}
