import 'package:dio/dio.dart';
import 'package:filmania/core/network/tmdb_client.dart';
import 'package:filmania/features/movies/data/models/movie_dto.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/features/movies/domain/repositories/i_movies_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_repository_impl.g.dart';

class MoviesRepositoryImpl implements IMoviesRepository {
  final Dio _client;

  MoviesRepositoryImpl(this._client);

  @override
  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    try {
      final response = await _client.get(
        'trending/movie/day',
        queryParameters: {'page': page},
      );

      final List<dynamic> results = response.data['results'];
      return results
          .map((json) => MovieDto.fromJson(json).toEntity())
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to load trending movies: ${e.message}');
    }
  }

  @override
  Future<List<Movie>> discoverMovies({int page = 1}) async {
    try {
      final response = await _client.get(
        'discover/movie',
        queryParameters: {
          'page': page,
          'sort_by': 'popularity.desc', // Standard sorting for discovery
        },
      );

      final List<dynamic> results = response.data['results'];
      return results
          .map((json) => MovieDto.fromJson(json).toEntity())
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to discover movies: ${e.message}');
    }
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await _client.get('movie/$movieId');
      return MovieDto.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw Exception('Failed to load movie details: ${e.message}');
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _client.get(
        'search/movie',
        queryParameters: {
          'query': query,
          'page': page,
        },
      );

      final List<dynamic> results = response.data['results'];
      return results
          .map((json) => MovieDto.fromJson(json).toEntity())
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to search movies: ${e.message}');
    }
  }
}

@riverpod
IMoviesRepository moviesRepository(Ref ref) {
  final client = ref.watch(tmdbClientProvider);
  return MoviesRepositoryImpl(client);
}
