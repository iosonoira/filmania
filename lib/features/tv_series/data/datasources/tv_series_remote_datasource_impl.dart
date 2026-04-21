import 'package:dio/dio.dart';
import 'package:filmania/core/network/network_failure.dart';
import 'package:filmania/features/tv_series/data/datasources/i_tv_series_remote_datasource.dart';
import 'package:filmania/features/tv_series/data/models/tv_episode_dto.dart';
import 'package:filmania/features/tv_series/data/models/tv_series_dto.dart';

class TVSeriesRemoteDataSourceImpl implements ITVSeriesRemoteDataSource {
  final Dio _client;

  const TVSeriesRemoteDataSourceImpl(this._client);

  @override
  Future<List<TVSeriesDto>> getTrendingTVSeries({int page = 1}) async {
    try {
      final response = await _client.get(
        'trending/tv/day',
        queryParameters: {'page': page},
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => TVSeriesDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<TVSeriesDto>> discoverTVSeries({int page = 1}) async {
    try {
      final response = await _client.get(
        'discover/tv',
        queryParameters: {'page': page, 'sort_by': 'popularity.desc'},
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => TVSeriesDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<TVSeriesDto> getTVSeriesDetails(int tvId) async {
    try {
      final response = await _client.get('tv/$tvId');
      return TVSeriesDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<TVSeriesDto>> searchTVSeries(String query, {int page = 1}) async {
    try {
      final response = await _client.get(
        'search/tv',
        queryParameters: {'query': query, 'page': page},
      );

      final List<dynamic> results = response.data['results'];
      return results.map((json) => TVSeriesDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<TVEpisodeDto>> getSeasonEpisodes(
    int tvId,
    int seasonNumber,
  ) async {
    try {
      final response = await _client.get('tv/$tvId/season/$seasonNumber');
      final List<dynamic> episodes = response.data['episodes'];
      return episodes.map((json) => TVEpisodeDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<TVEpisodeDto> getTVEpisodeDetails(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    try {
      final response =
          await _client.get('tv/$tvId/season/$seasonNumber/episode/$episodeNumber');
      return TVEpisodeDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
}
