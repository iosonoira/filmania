import '../entities/favorite_item.dart';
import '../../../../core/domain/enums/media_type.dart';

abstract class IFavoritesRepository {
  Future<void> addFavorite(FavoriteItem item);
  Future<void> removeFavorite({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
  Stream<List<FavoriteItem>> watchUserFavorites(String userId);
  Future<bool> isFavorite({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
}
