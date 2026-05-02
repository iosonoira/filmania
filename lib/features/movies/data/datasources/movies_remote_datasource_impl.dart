import 'package:dio/dio.dart';
import 'package:filmania/core/network/network_failure.dart';
import 'package:filmania/features/movies/data/datasources/i_movies_remote_datasource.dart';
import 'package:filmania/core/data/models/cast_member_dto.dart';
import 'package:filmania/features/movies/data/models/movie_dto.dart';

class MoviesRemoteDataSourceImpl implements IMoviesRemoteDataSource {
  final Dio _client;

  const MoviesRemoteDataSourceImpl(this._client);

  @override
  Future<List<MovieDto>> getTrendingMovies({int page = 1}) async {
    try {
      final response = await _client.get(
        'trending/movie/day',
        queryParameters: {'page': page},
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => MovieDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<MovieDto>> discoverMovies({int page = 1}) async {
    try {
      final response = await _client.get(
        'discover/movie',
        queryParameters: {'page': page, 'sort_by': 'popularity.desc'},
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => MovieDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<MovieDto> getMovieDetails(int movieId) async {
    try {
      final response = await _client.get('movie/$movieId');
      return MovieDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<MovieDto>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _client.get(
        'search/movie',
        queryParameters: {'query': query, 'page': page},
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => MovieDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<CastMemberDto>> getMovieCredits(int movieId) async {
    try {
      final response = await _client.get('movie/$movieId/credits');
      final List<dynamic> cast = response.data['cast'];
      return cast.map((json) => CastMemberDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
}
