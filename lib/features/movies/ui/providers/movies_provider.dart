import 'package:filmania/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/features/movies/domain/entities/movie_credits.dart';
import 'package:filmania/features/movies/domain/entities/movie_trailer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_provider.g.dart';

@riverpod
Future<List<Movie>> trendingMovies(Ref ref, {int page = 1}) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getTrendingMovies(page: page);
}

@riverpod
Future<List<Movie>> discoverMovies(Ref ref, {int page = 1}) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.discoverMovies(page: page);
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

@riverpod
Future<List<MovieTrailer>> movieTrailers(Ref ref, int movieId) {
  final repository = ref.watch(moviesRepositoryProvider);
  return repository.getMovieTrailers(movieId);
}
