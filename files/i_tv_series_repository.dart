import '../entities/tv_episode.dart';
import '../entities/tv_series.dart';

abstract class ITVSeriesRepository {
  Future<List<TVSeries>> getTrendingTVSeries({int page = 1});
  Future<List<TVSeries>> discoverTVSeries({int page = 1});
  Future<TVSeries> getTVSeriesDetails(int tvId);
  Future<List<TVSeries>> searchTVSeries(String query, {int page = 1});
  Future<List<TVEpisode>> getSeasonEpisodes(int tvId, int seasonNumber);
  Future<TVEpisode> getTVEpisodeDetails(int tvId, int seasonNumber, int episodeNumber);
}
