import 'package:filmania/core/domain/enums/media_type.dart';
import '../entities/watchlist_item.dart';

abstract interface class IWatchlistRepository {
  Future<void> addToWatchlist(WatchlistItem item);

  Future<void> removeFromWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });

  Stream<List<WatchlistItem>> watchWatchlist(String userId);

  Future<bool> isInWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
}
