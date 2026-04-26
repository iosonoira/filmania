import 'package:filmania/core/network/tmdb_client.dart';
import 'package:filmania/features/movies/data/datasources/i_movies_remote_datasource.dart';
import 'package:filmania/features/movies/data/datasources/movies_remote_datasource_impl.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/features/movies/domain/entities/movie_credits.dart';

import 'package:filmania/features/movies/domain/repositories/i_movies_repository.dart';
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
  Future<List<Movie>> discoverMovies({int page = 1}) async {
    final dtos = await _remoteDataSource.discoverMovies(page: page);
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
  Future<List<CastMember>> getMovieCredits(int movieId) async {
    final dtos = await _remoteDataSource.getMovieCredits(movieId);
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
