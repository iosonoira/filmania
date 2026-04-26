import 'package:filmania/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_episode.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_series.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tv_series_provider.g.dart';

@riverpod
class TrendingTVSeries extends _$TrendingTVSeries {
  @override
  FutureOr<List<TVSeries>> build({int page = 1}) async {
    final repository = ref.watch(tvSeriesRepositoryProvider);
    return repository.getTrendingTVSeries(page: page);
  }

  // Riverpod 3.0 Persistence (Awaiting correct library implementation)
  // @override
  // PersistenceConfig get persistence => PersistenceConfig(key: 'trending_tv_p$page');
}

@riverpod
class DiscoverTVSeries extends _$DiscoverTVSeries {
  @override
  FutureOr<List<TVSeries>> build({int page = 1}) async {
    final repository = ref.watch(tvSeriesRepositoryProvider);
    return repository.discoverTVSeries(page: page);
  }

  // Riverpod 3.0 Persistence (Awaiting correct library implementation)
  // @override
  // PersistenceConfig get persistence => PersistenceConfig(key: 'discover_tv_p$page');
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
