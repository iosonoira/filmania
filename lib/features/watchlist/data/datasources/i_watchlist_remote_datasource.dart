import '../models/watchlist_item_dto.dart';

abstract interface class IWatchlistRemoteDataSource {
  Future<void> addToWatchlist(WatchlistItemDto item);
  
  Future<void> removeFromWatchlist({
    required String userId,
    required int movieId,
  });
  
  Stream<List<WatchlistItemDto>> watchWatchlist(String userId);
  
  Future<bool> isInWatchlist({
    required String userId,
    required int movieId,
  });
}
