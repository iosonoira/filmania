import 'package:filmania/domain/models/genre.dart';
import 'package:filmania/data/repositories/movies/movies_repository_impl.dart';
import 'package:filmania/domain/models/movie.dart';
import 'package:filmania/domain/models/credits.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_providers.g.dart';

@riverpod
class TrendingMovies extends _$TrendingMovies {
  @override
  FutureOr<List<Movie>> build({int page = 1}) async {
    final repository = ref.watch(moviesRepositoryProvider);
    return repository.getTrendingMovies(page: page);
  }
}

@riverpod
class DiscoverMovies extends _$DiscoverMovies {
  @override
  FutureOr<List<Movie>> build({
    int page = 1,
    String genreIds = '',
    int? yearFrom,
    int? yearTo,
  }) async {
    final repository = ref.watch(moviesRepositoryProvider);
    return repository.discoverMovies(
      page: page,
      genreIds: genreIds.isEmpty
          ? const []
          : genreIds.split(',').map(int.parse).toList(),
      yearFrom: yearFrom,
      yearTo: yearTo,
    );
  }
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
Future<Credits> movieCredits(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieCredits(movieId);
}

@riverpod
Future<List<Movie>> movieRecommendations(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieRecommendations(movieId);
}

@Riverpod(keepAlive: true)
Future<List<Genre>> movieGenres(Ref ref) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getGenres();
}
