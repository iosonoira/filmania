import 'package:filmania/core/domain/entities/cast_member.dart';
import 'package:filmania/core/domain/entities/credits.dart';
import 'package:filmania/core/domain/entities/genre.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_episode.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_series.dart';

abstract class ITVSeriesRepository {
  Future<List<TVSeries>> getTrendingTVSeries({int page = 1});
  Future<List<TVSeries>> discoverTVSeries({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  });
  Future<TVSeries> getTVSeriesDetails(int tvId);
  Future<List<TVSeries>> searchTVSeries(String query, {int page = 1});
  Future<List<TVEpisode>> getSeasonEpisodes(int tvId, int seasonNumber);
  Future<TVEpisode> getTVEpisodeDetails(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  );
  Future<Credits> getTVSeriesCredits(int tvId);
  Future<List<CastMember>> getTVEpisodeCredits(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  );
  Future<List<TVSeries>> getTVSeriesRecommendations(int tvId);
  Future<List<Genre>> getGenres();
}
