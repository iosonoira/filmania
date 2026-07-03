import 'package:filmania/core/data/models/credits_dto.dart';
import 'package:filmania/core/data/models/genre_dto.dart';
import 'package:filmania/features/movies/data/models/movie_dto.dart';

abstract interface class IMoviesRemoteDataSource {
  Future<List<MovieDto>> getTrendingMovies({int page = 1});
  Future<List<MovieDto>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<MovieDto> getMovieDetails(int movieId);
  Future<List<MovieDto>> searchMovies(String query, {int page = 1});
  Future<CreditsDto> getMovieCredits(int movieId);
  Future<List<MovieDto>> getMovieRecommendations(int movieId);
  Future<List<GenreDto>> getGenres();
}
