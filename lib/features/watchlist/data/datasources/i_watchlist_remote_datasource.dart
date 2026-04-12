import '../models/watchlist_item_dto.dart';
import '../../../discover/ui/providers/discover_providers.dart';

abstract interface class IWatchlistRemoteDataSource {
  Future<void> addToWatchlist(WatchlistItemDto item);
  
  Future<void> removeFromWatchlist({
    required String userId,
    required int mediaId,
    required DiscoverMediaType mediaType,
  });
  
  Stream<List<WatchlistItemDto>> watchWatchlist(String userId);
  
  Future<bool> isInWatchlist({
    required String userId,
    required int mediaId,
    required DiscoverMediaType mediaType,
  });
}
