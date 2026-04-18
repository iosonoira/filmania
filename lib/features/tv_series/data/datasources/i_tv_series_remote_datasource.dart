import '../models/tv_episode_dto.dart';
import '../models/tv_series_dto.dart';

abstract class ITVSeriesRemoteDataSource {
  Future<List<TVSeriesDto>> getTrendingTVSeries({int page = 1});
  Future<List<TVSeriesDto>> discoverTVSeries({int page = 1});
  Future<TVSeriesDto> getTVSeriesDetails(int tvId);
  Future<List<TVSeriesDto>> searchTVSeries(String query, {int page = 1});
  Future<List<TVEpisodeDto>> getSeasonEpisodes(int tvId, int seasonNumber);
}
