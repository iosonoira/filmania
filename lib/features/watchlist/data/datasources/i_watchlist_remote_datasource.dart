import 'package:filmania/core/domain/enums/media_type.dart';
import '../models/watchlist_item_dto.dart';
import '../models/watchlist_dto.dart';

abstract interface class IWatchlistRemoteDataSource {
  // ── Watchlist CRUD ──────────────────────────────────────────────────────────
  Future<WatchlistDto> createWatchlist({
    required String userId,
    required String name,
  });

  Future<void> deleteWatchlist(String watchlistId);

  Stream<List<WatchlistDto>> watchUserWatchlists(String userId);

  // ── Item CRUD ───────────────────────────────────────────────────────────────
  Future<void> addToWatchlist(WatchlistItemDto item);

  Future<void> removeFromWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
    required String watchlistId,
  });

  Stream<List<WatchlistItemDto>> watchWatchlistItems(String watchlistId);

  Future<List<WatchlistDto>> getWatchlistsContainingMedia({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });

  /// Legacy: returns all items globally (used for migration / backward compat)
  Stream<List<WatchlistItemDto>> watchWatchlist(String userId);

  Future<bool> isInWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
}
