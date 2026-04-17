import 'package:filmania/core/domain/enums/media_type.dart';
import '../entities/watchlist_item.dart';

abstract interface class IWatchlistRepository {
  /// Adds a media item to the user's watchlist.
  ///
  /// The [item] contains all metadata needed to persist the watchlist entry.
  /// Throws [WatchlistFailure] on database errors.
  Future<void> addToWatchlist(WatchlistItem item);

  /// Removes a media item from the user's watchlist.
  ///
  /// Identifies the item by [userId], [mediaId], and [mediaType].
  /// Throws [WatchlistFailure] on database errors.
  Future<void> removeFromWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });

  /// Emits the user's watchlist whenever it changes (realtime).
  ///
  /// Returns a stream that updates whenever items are added or removed.
  Stream<List<WatchlistItem>> watchWatchlist(String userId);

  /// Checks whether a specific media item is in the user's watchlist.
  ///
  /// Used to determine the UI state of the watchlist toggle button.
  Future<bool> isInWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
}
