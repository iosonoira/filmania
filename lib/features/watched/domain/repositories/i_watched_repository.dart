import '../entities/watched_item.dart';
import '../../../../core/domain/enums/media_type.dart';

abstract class IWatchedRepository {
  Future<void> markAsWatched(WatchedItem item);
  Future<void> removeFromWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
  Stream<List<WatchedItem>> watchUserWatchedItems(String userId, MediaType mediaType);
  Future<bool> isWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
}
