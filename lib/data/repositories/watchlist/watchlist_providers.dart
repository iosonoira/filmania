import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/data/repositories/watchlist/watchlist_repository_impl.dart';
import 'package:filmania/domain/models/watchlist.dart';
import 'package:filmania/domain/models/watchlist_item.dart';

part 'watchlist_providers.g.dart';

// ── User Watchlists (stream of lists) ──────────────────────────────────────

@riverpod
Stream<List<Watchlist>> userWatchlists(Ref ref) {
  final repo = ref.watch(watchlistRepositoryProvider);
  if (repo == null) return Stream.value([]);
  return repo.watchUserWatchlists();
}

// ── Items in a specific watchlist ──────────────────────────────────────────

@riverpod
Stream<List<WatchlistItem>> watchlistItems(Ref ref, String watchlistId) {
  final repo = ref.watch(watchlistRepositoryProvider);
  if (repo == null) return Stream.value([]);
  return repo.watchWatchlistItems(watchlistId);
}

// ── Is media in ANY watchlist? (button state) ──────────────────────────────

@riverpod
Future<bool> isMediaInWatchlist(Ref ref, int mediaId, MediaType type) async {
  final repo = ref.watch(watchlistRepositoryProvider);
  if (repo == null) return false;
  return repo.isInAnyWatchlist(mediaId: mediaId, mediaType: type);
}

// ── Watchlist IDs containing a media (for sheet state) ────────────────────

@riverpod
Future<Set<String>> watchlistIdsContainingMedia(
  Ref ref,
  int mediaId,
  MediaType type,
) async {
  final repo = ref.watch(watchlistRepositoryProvider);
  if (repo == null) return {};
  return repo.getWatchlistIdsContaining(mediaId: mediaId, mediaType: type);
}

// ── Legacy alias kept for watchlist page (all items) ─────────────────────

@riverpod
Stream<List<WatchlistItem>> userWatchlist(Ref ref) {
  final repo = ref.watch(watchlistRepositoryProvider);
  if (repo == null) return Stream.value([]);
  return repo.watchAllItems();
}
