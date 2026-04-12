import '../entities/watchlist_item.dart';
import '../../../discover/ui/providers/discover_providers.dart';

abstract interface class IWatchlistRepository {
  Future<void> addToWatchlist(WatchlistItem item);
  
  Future<void> removeFromWatchlist({
    required String userId,
    required int mediaId,
    required DiscoverMediaType mediaType,
  });
  
  Stream<List<WatchlistItem>> watchWatchlist(String userId);
  
  Future<bool> isInWatchlist({
    required String userId,
    required int mediaId,
    required DiscoverMediaType mediaType,
  });
}
