import 'package:filmania/core/data/models/cast_member_dto.dart';
import '../models/tv_episode_dto.dart';
import '../models/tv_series_dto.dart';

abstract class ITVSeriesRemoteDataSource {
  Future<List<TVSeriesDto>> getTrendingTVSeries({int page = 1});
  Future<List<TVSeriesDto>> discoverTVSeries({int page = 1});
  Future<TVSeriesDto> getTVSeriesDetails(int tvId);
  Future<List<TVSeriesDto>> searchTVSeries(String query, {int page = 1});
  Future<List<TVEpisodeDto>> getSeasonEpisodes(int tvId, int seasonNumber);
  Future<TVEpisodeDto> getTVEpisodeDetails(int tvId, int seasonNumber, int episodeNumber);
  Future<List<CastMemberDto>> getTVSeriesCredits(int tvId);
  Future<List<CastMemberDto>> getTVEpisodeCredits(int tvId, int seasonNumber, int episodeNumber);
}
