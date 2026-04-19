import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../tv_series/domain/entities/tv_series.dart';
import '../../data/repositories/watchlist_repository_impl.dart';
import '../../domain/entities/watchlist.dart';
import '../../domain/entities/watchlist_item.dart';

part 'watchlist_providers.g.dart';

// ── User Watchlists (stream of lists) ──────────────────────────────────────

@riverpod
Stream<List<Watchlist>> userWatchlists(Ref ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(watchlistRepositoryProvider).watchUserWatchlists();
}

// ── Items in a specific watchlist ──────────────────────────────────────────

@riverpod
Stream<List<WatchlistItem>> watchlistItems(Ref ref, String watchlistId) {
  return ref.watch(watchlistRepositoryProvider).watchWatchlistItems(watchlistId);
}

// ── Is media in ANY watchlist? (button state) ──────────────────────────────

@riverpod
Future<bool> isMediaInWatchlist(Ref ref, int mediaId, MediaType type) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;
  return ref
      .watch(watchlistRepositoryProvider)
      .isInAnyWatchlist(mediaId: mediaId, mediaType: type);
}

// ── Watchlist IDs containing a media (for sheet state) ────────────────────

@riverpod
Future<Set<String>> watchlistIdsContainingMedia(
    Ref ref, int mediaId, MediaType type) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return {};
  return ref
      .watch(watchlistRepositoryProvider)
      .getWatchlistIdsContaining(mediaId: mediaId, mediaType: type);
}

// ── Watchlist Notifier ────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class WatchlistNotifier extends _$WatchlistNotifier {
  @override
  FutureOr<void> build() => null;

  /// Creates a new named watchlist and returns it.
  Future<Watchlist?> createWatchlist(String name) async {
    state = const AsyncLoading();
    Watchlist? created;
    state = await AsyncValue.guard(() async {
      created = await ref
          .read(watchlistRepositoryProvider)
          .createWatchlist(name: name);
      ref.invalidate(userWatchlistsProvider);
    });
    return created;
  }

  Future<void> deleteWatchlist(String watchlistId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(watchlistRepositoryProvider).deleteWatchlist(watchlistId);
      ref.invalidate(userWatchlistsProvider);
    });
  }

  /// Adds media to an existing watchlist.
  Future<void> addMovieToWatchlist(Movie movie, String watchlistId) async {
    await addItem(
      watchlistId: watchlistId,
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      type: MediaType.movie,
    );
  }

  Future<void> addTVSeriesToWatchlist(TVSeries series, String watchlistId) async {
    await addItem(
      watchlistId: watchlistId,
      id: series.id,
      title: series.name,
      posterPath: series.posterPath,
      type: MediaType.tv,
    );
  }

  Future<void> removeItemFromWatchlist({
    required String watchlistId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(watchlistRepositoryProvider).removeItemFromWatchlist(
            watchlistId: watchlistId,
            mediaId: mediaId,
            mediaType: mediaType,
          );
      ref.invalidate(isMediaInWatchlistProvider(mediaId, mediaType));
      ref.invalidate(watchlistIdsContainingMediaProvider(mediaId, mediaType));
      ref.invalidate(watchlistItemsProvider(watchlistId));
    });
  }

  Future<void> addItem({
    required String watchlistId,
    required int id,
    required String title,
    required String? posterPath,
    required MediaType type,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(watchlistRepositoryProvider).addItemToWatchlist(
            watchlistId: watchlistId,
            mediaId: id,
            title: title,
            mediaType: type,
            posterPath: posterPath,
          );
      ref.invalidate(isMediaInWatchlistProvider(id, type));
      ref.invalidate(watchlistIdsContainingMediaProvider(id, type));
      ref.invalidate(watchlistItemsProvider(watchlistId));
    });
  }
}

// ── Legacy alias kept for watchlist page (all items) ─────────────────────

@riverpod
Stream<List<WatchlistItem>> userWatchlist(Ref ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(watchlistRepositoryProvider).watchAllItems();
}

// ── Legacy watchlistProvider alias ────────────────────────────────────────
// The movie/tv detail pages still use `watchlistProvider` — kept for compat.
// They will be updated to use WatchlistNotifier directly.
