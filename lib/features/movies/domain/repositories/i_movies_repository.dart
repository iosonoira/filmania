import 'package:filmania/features/movies/domain/entities/movie.dart';

abstract class IMoviesRepository {
  Future<List<Movie>> getTrendingMovies({int page = 1});
  Future<List<Movie>> discoverMovies({int page = 1});
  Future<Movie> getMovieDetails(int movieId);
  Future<List<Movie>> searchMovies(String query, {int page = 1});
}
