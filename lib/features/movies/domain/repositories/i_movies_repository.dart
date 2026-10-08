import 'package:filmania/domain/models/genre.dart';
import 'package:filmania/domain/models/movie.dart';
import 'package:filmania/domain/models/credits.dart';

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
  Future<List<Movie>> getMovieRecommendations(int movieId);
  Future<List<Genre>> getGenres();
}
