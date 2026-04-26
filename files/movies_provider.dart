import 'package:filmania/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/features/movies/domain/entities/movie_credits.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_provider.g.dart';

@riverpod
class TrendingMovies extends _$TrendingMovies {
  @override
  FutureOr<List<Movie>> build({int page = 1}) async {
    final repository = ref.watch(moviesRepositoryProvider);
    return repository.getTrendingMovies(page: page);
  }

  // Riverpod 3.0 Persistence (Awaiting correct library implementation)
  // @override
  // PersistenceConfig get persistence => PersistenceConfig(key: 'trending_movies_p$page');
}

@riverpod
class DiscoverMovies extends _$DiscoverMovies {
  @override
  FutureOr<List<Movie>> build({int page = 1}) async {
    final repository = ref.watch(moviesRepositoryProvider);
    return repository.discoverMovies(page: page);
  }

  // Riverpod 3.0 Persistence (Awaiting correct library implementation)
  // @override
  // PersistenceConfig get persistence => PersistenceConfig(key: 'discover_movies_p$page');
}

@riverpod
Future<Movie> movieDetails(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieDetails(movieId);
}

@riverpod
Future<List<Movie>> searchMovies(Ref ref, String query, {int page = 1}) {
  if (query.isEmpty) return Future.value([]);
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.searchMovies(query, page: page);
}

@riverpod
Future<List<CastMember>> movieCredits(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieCredits(movieId);
}
