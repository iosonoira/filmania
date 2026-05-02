import 'package:filmania/core/domain/entities/cast_member.dart';
import 'package:filmania/core/network/tmdb_client.dart';
import 'package:filmania/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart';
import 'package:filmania/features/tv_series/data/datasources/tv_series_remote_datasource_impl.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_episode.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_series.dart';
import 'package:filmania/features/tv_series/domain/repositories/i_tv_series_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tv_series_repository_impl.g.dart';

class TVSeriesRepositoryImpl implements ITVSeriesRepository {
  final ITVSeriesRemoteDataSource _remoteDataSource;

  const TVSeriesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<TVSeries>> getTrendingTVSeries({int page = 1}) async {
    final dtos = await _remoteDataSource.getTrendingTVSeries(page: page);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<TVSeries>> discoverTVSeries({int page = 1}) async {
    final dtos = await _remoteDataSource.discoverTVSeries(page: page);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<TVSeries> getTVSeriesDetails(int tvId) async {
    final dto = await _remoteDataSource.getTVSeriesDetails(tvId);
    return dto.toEntity();
  }

  @override
  Future<List<TVSeries>> searchTVSeries(String query, {int page = 1}) async {
    final dtos = await _remoteDataSource.searchTVSeries(query, page: page);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<TVEpisode>> getSeasonEpisodes(int tvId, int seasonNumber) async {
    final dtos = await _remoteDataSource.getSeasonEpisodes(tvId, seasonNumber);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<TVEpisode> getTVEpisodeDetails(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    final dto =
        await _remoteDataSource.getTVEpisodeDetails(tvId, seasonNumber, episodeNumber);
    return dto.toEntity();
  }

  @override
  Future<List<CastMember>> getTVSeriesCredits(int tvId) async {
    final dtos = await _remoteDataSource.getTVSeriesCredits(tvId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<CastMember>> getTVEpisodeCredits(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    final dtos =
        await _remoteDataSource.getTVEpisodeCredits(tvId, seasonNumber, episodeNumber);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}

@riverpod
ITVSeriesRemoteDataSource tvSeriesRemoteDataSource(Ref ref) {
  return TVSeriesRemoteDataSourceImpl(ref.watch(tmdbClientProvider));
}

@riverpod
ITVSeriesRepository tvSeriesRepository(Ref ref) {
  return TVSeriesRepositoryImpl(ref.watch(tvSeriesRemoteDataSourceProvider));
}
