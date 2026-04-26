import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import '../../domain/failures/watchlist_failure.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../tv_series/domain/entities/tv_series.dart';
import '../../data/repositories/watchlist_repository_impl.dart';
import '../../domain/entities/watchlist.dart';
import '../../domain/entities/watchlist_item.dart';

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
    Ref ref, int mediaId, MediaType type) async {
  final repo = ref.watch(watchlistRepositoryProvider);
  if (repo == null) return {};
  return repo.getWatchlistIdsContaining(mediaId: mediaId, mediaType: type);
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
      final repo = ref.read(watchlistRepositoryProvider);
      if (repo == null) throw const WatchlistGenericFailure('Utente non autenticato.');
      created = await repo.createWatchlist(name: name);
      ref.invalidate(userWatchlistsProvider);
    });
    return created;
  }

  Future<void> deleteWatchlist(String watchlistId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(watchlistRepositoryProvider);
      if (repo == null) throw const WatchlistGenericFailure('Utente non autenticato.');
      await repo.deleteWatchlist(watchlistId);
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
      final repo = ref.read(watchlistRepositoryProvider);
      if (repo == null) throw const WatchlistGenericFailure('Utente non autenticato.');
      await repo.removeItemFromWatchlist(
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
      final repo = ref.read(watchlistRepositoryProvider);
      if (repo == null) throw const WatchlistGenericFailure('Utente non autenticato.');
      await repo.addItemToWatchlist(
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
  final repo = ref.watch(watchlistRepositoryProvider);
  if (repo == null) return Stream.value([]);
  return repo.watchAllItems();
}

// ── Legacy watchlistProvider alias ────────────────────────────────────────
// The movie/tv detail pages still use `watchlistProvider` — kept for compat.
// They will be updated to use WatchlistNotifier directly.
