import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../tv_series/domain/entities/tv_series.dart';
import '../../../discover/ui/providers/discover_providers.dart';
import '../../data/repositories/watchlist_repository_impl.dart';
import '../../domain/entities/watchlist_item.dart';

part 'watchlist_providers.g.dart';

@riverpod
Stream<List<WatchlistItem>> userWatchlist(Ref ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(watchlistRepositoryProvider).watchWatchlist(user.id);
}

@riverpod
Future<bool> isMediaInWatchlist(Ref ref, int mediaId, DiscoverMediaType type) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;
  return ref.watch(watchlistRepositoryProvider)
      .isInWatchlist(userId: user.id, mediaId: mediaId, mediaType: type);
}

@riverpod
class WatchlistNotifier extends _$WatchlistNotifier {
  @override
  FutureOr<void> build() => null;

  Future<void> toggleMovie(Movie movie) async {
    await _toggle(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      type: DiscoverMediaType.movie,
    );
  }

  Future<void> toggleTVSeries(TVSeries series) async {
    await _toggle(
      id: series.id,
      title: series.name,
      posterPath: series.posterPath,
      type: DiscoverMediaType.tv,
    );
  }

  Future<void> _toggle({
    required int id,
    required String title,
    required String? posterPath,
    required DiscoverMediaType type,
  }) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    
    final isIn = await ref.read(watchlistRepositoryProvider)
        .isInWatchlist(userId: user.id, mediaId: id, mediaType: type);
        
    state = await AsyncValue.guard(() async {
      if (isIn) {
        await ref.read(watchlistRepositoryProvider)
            .removeFromWatchlist(userId: user.id, mediaId: id, mediaType: type);
      } else {
        await ref.read(watchlistRepositoryProvider).addToWatchlist(
          WatchlistItem(
            id: '', 
            userId: user.id,
            mediaId: id,
            title: title,
            mediaType: type,
            posterPath: posterPath,
            addedAt: DateTime.now(),
          ),
        );
      }
      ref.invalidate(userWatchlistProvider);
      ref.invalidate(isMediaInWatchlistProvider(id, type));
    });
  }

  Future<void> remove(int mediaId, DiscoverMediaType type) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(watchlistRepositoryProvider)
          .removeFromWatchlist(userId: user.id, mediaId: mediaId, mediaType: type);
      ref.invalidate(userWatchlistProvider);
      ref.invalidate(isMediaInWatchlistProvider(mediaId, type));
    });
  }
}
