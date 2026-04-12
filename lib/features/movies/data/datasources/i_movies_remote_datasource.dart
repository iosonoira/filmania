import 'package:filmania/features/movies/data/models/cast_member_dto.dart';
import 'package:filmania/features/movies/data/models/movie_dto.dart';
import 'package:filmania/features/movies/data/models/movie_trailer_dto.dart';

abstract interface class IMoviesRemoteDataSource {
  Future<List<MovieDto>> getTrendingMovies({int page = 1});
  Future<List<MovieDto>> discoverMovies({int page = 1});
  Future<MovieDto> getMovieDetails(int movieId);
  Future<List<MovieDto>> searchMovies(String query, {int page = 1});
  Future<List<CastMemberDto>> getMovieCredits(int movieId);
  Future<List<MovieTrailerDto>> getMovieTrailers(int movieId);
}
