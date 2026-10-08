import 'package:filmania/domain/models/genre.dart';
import 'package:filmania/data/services/tmdb/tmdb_client.dart';
import 'package:filmania/data/services/tmdb/i_movies_remote_datasource.dart';
import 'package:filmania/data/services/tmdb/movies_remote_datasource_impl.dart';
import 'package:filmania/domain/models/movie.dart';
import 'package:filmania/domain/models/credits.dart';

import 'package:filmania/data/repositories/movies/i_movies_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movies_repository_impl.g.dart';

class MoviesRepositoryImpl implements IMoviesRepository {
  final IMoviesRemoteDataSource _remoteDataSource;

  const MoviesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    final dtos = await _remoteDataSource.getTrendingMovies(page: page);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Movie>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  }) async {
    final dtos = await _remoteDataSource.discoverMovies(
      page: page,
      genreIds: genreIds,
      yearFrom: yearFrom,
      yearTo: yearTo,
    );
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    final dto = await _remoteDataSource.getMovieDetails(movieId);
    return dto.toEntity();
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final dtos = await _remoteDataSource.searchMovies(query, page: page);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Credits> getMovieCredits(int movieId) async {
    final dto = await _remoteDataSource.getMovieCredits(movieId);
    return dto.toEntity();
  }

  @override
  Future<List<Movie>> getMovieRecommendations(int movieId) async {
    final dtos = await _remoteDataSource.getMovieRecommendations(movieId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Genre>> getGenres() async {
    final dtos = await _remoteDataSource.getGenres();
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}

@riverpod
IMoviesRemoteDataSource moviesRemoteDataSource(Ref ref) {
  return MoviesRemoteDataSourceImpl(ref.watch(tmdbClientProvider));
}

@riverpod
IMoviesRepository moviesRepository(Ref ref) {
  return MoviesRepositoryImpl(ref.watch(moviesRemoteDataSourceProvider));
}
