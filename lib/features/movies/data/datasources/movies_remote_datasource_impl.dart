import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:filmania/data/services/network_failure.dart';
import 'package:filmania/features/movies/data/datasources/i_movies_remote_datasource.dart';
import 'package:filmania/core/data/models/credits_dto.dart';
import 'package:filmania/core/data/models/genre_dto.dart';
import 'package:filmania/features/movies/data/models/movie_dto.dart';

@visibleForTesting
Map<String, dynamic> buildMovieDiscoverQueryParams({
  required int page,
  List<int> genreIds = const [],
  int? yearFrom,
  int? yearTo,
}) {
  return {
    'page': page,
    'sort_by': 'popularity.desc',
    if (genreIds.isNotEmpty) 'with_genres': genreIds.join('|'),
    if (yearFrom != null) 'primary_release_date.gte': '$yearFrom-01-01',
    if (yearTo != null) 'primary_release_date.lte': '$yearTo-12-31',
  };
}

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
  Future<List<MovieDto>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  }) async {
    try {
      final response = await _client.get(
        'discover/movie',
        queryParameters: buildMovieDiscoverQueryParams(
          page: page,
          genreIds: genreIds,
          yearFrom: yearFrom,
          yearTo: yearTo,
        ),
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
  Future<CreditsDto> getMovieCredits(int movieId) async {
    try {
      final response = await _client.get('movie/$movieId/credits');
      return CreditsDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<MovieDto>> getMovieRecommendations(int movieId) async {
    try {
      final response = await _client.get('movie/$movieId/recommendations');
      final List<dynamic> results = response.data['results'];
      return results.map((json) => MovieDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<GenreDto>> getGenres() async {
    try {
      final response = await _client.get('genre/movie/list');
      final List<dynamic> genres = response.data['genres'];
      return genres.map((json) => GenreDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
}
