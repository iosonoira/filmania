import 'package:filmania/domain/models/cast_member.dart';
import 'package:filmania/domain/models/credits.dart';
import 'package:filmania/domain/models/genre.dart';
import 'package:filmania/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:filmania/domain/models/tv_episode.dart';
import 'package:filmania/domain/models/tv_series.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tv_series_provider.g.dart';

@riverpod
class TrendingTVSeries extends _$TrendingTVSeries {
  @override
  FutureOr<List<TVSeries>> build({int page = 1}) async {
    final repository = ref.watch(tvSeriesRepositoryProvider);
    return repository.getTrendingTVSeries(page: page);
  }
}

@riverpod
class DiscoverTVSeries extends _$DiscoverTVSeries {
  @override
  FutureOr<List<TVSeries>> build({
    int page = 1,
    String genreIds = '',
    int? yearFrom,
    int? yearTo,
  }) async {
    final repository = ref.watch(tvSeriesRepositoryProvider);
    return repository.discoverTVSeries(
      page: page,
      genreIds: genreIds.isEmpty
          ? const []
          : genreIds.split(',').map(int.parse).toList(),
      yearFrom: yearFrom,
      yearTo: yearTo,
    );
  }
}

@Riverpod(keepAlive: true)
Future<TVSeries> tvSeriesDetails(Ref ref, int tvId) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVSeriesDetails(tvId);
}

@riverpod
Future<List<TVSeries>> searchTVSeries(Ref ref, String query, {int page = 1}) {
  if (query.isEmpty) return Future.value([]);
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.searchTVSeries(query, page: page);
}

@Riverpod(keepAlive: true)
Future<List<TVEpisode>> seasonEpisodes(Ref ref, int tvId, int seasonNumber) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getSeasonEpisodes(tvId, seasonNumber);
}

@Riverpod(keepAlive: true)
Future<TVEpisode> tvEpisodeDetails(
  Ref ref, {
  required int tvId,
  required int seasonNumber,
  required int episodeNumber,
}) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVEpisodeDetails(tvId, seasonNumber, episodeNumber);
}

@Riverpod(keepAlive: true)
class SelectedSeason extends _$SelectedSeason {
  @override
  int build(int tvId) => 1;

  void select(int seasonNumber) => state = seasonNumber;
}

@Riverpod(keepAlive: true)
Future<Credits> tvSeriesCredits(Ref ref, int tvId) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVSeriesCredits(tvId);
}

@Riverpod(keepAlive: true)
Future<List<CastMember>> tvEpisodeCredits(
  Ref ref, {
  required int tvId,
  required int seasonNumber,
  required int episodeNumber,
}) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVEpisodeCredits(tvId, seasonNumber, episodeNumber);
}

@riverpod
Future<List<TVSeries>> tvSeriesRecommendations(Ref ref, int tvId) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTVSeriesRecommendations(tvId);
}

@Riverpod(keepAlive: true)
Future<List<Genre>> tvGenres(Ref ref) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getGenres();
}
