import '../models/watched_item_dto.dart';
import '../../../../core/domain/enums/media_type.dart';

abstract class IWatchedRemoteDataSource {
  Future<void> markAsWatched(WatchedItemDto item);
  Future<void> removeFromWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
  Stream<List<WatchedItemDto>> watchUserWatchedItems(String userId, MediaType mediaType);
  Future<bool> isWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
}
