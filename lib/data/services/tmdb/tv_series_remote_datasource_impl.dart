import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:filmania/data/services/network_failure.dart';
import 'package:filmania/data/models/cast_member_dto.dart';
import 'package:filmania/data/models/credits_dto.dart';
import 'package:filmania/data/models/genre_dto.dart';
import 'package:filmania/data/services/tmdb/i_tv_series_remote_datasource.dart';
import 'package:filmania/data/models/tv_episode_dto.dart';
import 'package:filmania/data/models/tv_series_dto.dart';

@visibleForTesting
Map<String, dynamic> buildTVDiscoverQueryParams({
  required int page,
  List<int> genreIds = const [],
  int? yearFrom,
  int? yearTo,
}) {
  return {
    'page': page,
    'sort_by': 'popularity.desc',
    if (genreIds.isNotEmpty) 'with_genres': genreIds.join('|'),
    if (yearFrom != null) 'first_air_date.gte': '$yearFrom-01-01',
    if (yearTo != null) 'first_air_date.lte': '$yearTo-12-31',
  };
}

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
  Future<List<TVSeriesDto>> discoverTVSeries({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  }) async {
    try {
      final response = await _client.get(
        'discover/tv',
        queryParameters: buildTVDiscoverQueryParams(
          page: page,
          genreIds: genreIds,
          yearFrom: yearFrom,
          yearTo: yearTo,
        ),
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
      final response = await _client.get(
        'tv/$tvId/season/$seasonNumber/episode/$episodeNumber',
      );
      return TVEpisodeDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<CreditsDto> getTVSeriesCredits(int tvId) async {
    try {
      final response = await _client.get('tv/$tvId/credits');
      return CreditsDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<CastMemberDto>> getTVEpisodeCredits(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    try {
      final response = await _client.get(
        'tv/$tvId/season/$seasonNumber/episode/$episodeNumber/credits',
      );
      final List<dynamic> cast = response.data['cast'];
      return cast.map((json) => CastMemberDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<TVSeriesDto>> getTVSeriesRecommendations(int tvId) async {
    try {
      final response = await _client.get('tv/$tvId/recommendations');
      final List<dynamic> results = response.data['results'];
      return results.map((json) => TVSeriesDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<List<GenreDto>> getGenres() async {
    try {
      final response = await _client.get('genre/tv/list');
      final List<dynamic> genres = response.data['genres'];
      return genres.map((json) => GenreDto.fromJson(json)).toList();
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
}
