import 'package:filmania/core/domain/entities/genre.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/core/domain/entities/credits.dart';

abstract class IMoviesRepository {
  Future<List<Movie>> getTrendingMovies({int page = 1});
  Future<List<Movie>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<Movie> getMovieDetails(int movieId);
  Future<List<Movie>> searchMovies(String query, {int page = 1});
  Future<Credits> getMovieCredits(int movieId);
  Future<List<Genre>> getGenres();
}
