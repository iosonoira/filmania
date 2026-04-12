import '../entities/watchlist_item.dart';

abstract interface class IWatchlistRepository {
  Future<void> addToWatchlist(WatchlistItem item);
  
  Future<void> removeFromWatchlist({
    required String userId,
    required int movieId,
  });
  
  Stream<List<WatchlistItem>> watchWatchlist(String userId);
  
  Future<bool> isInWatchlist({
    required String userId,
    required int movieId,
  });
}
