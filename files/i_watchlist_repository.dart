import 'package:filmania/core/domain/enums/media_type.dart';
import '../entities/watchlist.dart';
import '../entities/watchlist_item.dart';

abstract interface class IWatchlistRepository {
  // ── Watchlist CRUD ──────────────────────────────────────────────────────────
  Future<Watchlist> createWatchlist({required String name});
  Future<void> deleteWatchlist(String watchlistId);
  Stream<List<Watchlist>> watchUserWatchlists();

  // ── Item CRUD ───────────────────────────────────────────────────────────────
  Future<void> addItemToWatchlist({
    required String watchlistId,
    required int mediaId,
    required String title,
    required MediaType mediaType,
    required String? posterPath,
  });

  Future<void> removeItemFromWatchlist({
    required String watchlistId,
    required int mediaId,
    required MediaType mediaType,
  });

  Stream<List<WatchlistItem>> watchWatchlistItems(String watchlistId);

  /// Returns IDs of watchlists that already contain this media.
  Future<Set<String>> getWatchlistIdsContaining({
    required int mediaId,
    required MediaType mediaType,
  });

  /// True if media appears in ANY watchlist of the user.
  Future<bool> isInAnyWatchlist({
    required int mediaId,
    required MediaType mediaType,
  });

  // Legacy full stream (used by watchlist page overview)
  Stream<List<WatchlistItem>> watchAllItems();
}
