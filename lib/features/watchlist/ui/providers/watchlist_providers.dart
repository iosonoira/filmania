import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../../movies/domain/entities/movie.dart';
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
Future<bool> isMovieInWatchlist(Ref ref, int movieId) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;
  return ref.watch(watchlistRepositoryProvider)
      .isInWatchlist(userId: user.id, movieId: movieId);
}

@riverpod
class WatchlistNotifier extends _$WatchlistNotifier {
  @override
  FutureOr<void> build() => null;

  Future<void> toggle(Movie movie) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    
    final isIn = await ref.read(watchlistRepositoryProvider)
        .isInWatchlist(userId: user.id, movieId: movie.id);
        
    state = await AsyncValue.guard(() async {
      if (isIn) {
        await ref.read(watchlistRepositoryProvider)
            .removeFromWatchlist(userId: user.id, movieId: movie.id);
      } else {
        await ref.read(watchlistRepositoryProvider).addToWatchlist(
          WatchlistItem(
            id: '', // Supabase will generate this
            userId: user.id,
            movieId: movie.id,
            movieTitle: movie.title,
            posterPath: movie.posterPath,
            addedAt: DateTime.now(),
          ),
        );
      }
      // Manual invalidation to ensure UI updates immediately
      ref.invalidate(isMovieInWatchlistProvider(movie.id));
    });
  }
}
