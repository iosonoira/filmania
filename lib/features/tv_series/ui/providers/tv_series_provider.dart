import 'package:filmania/features/tv_series/data/repositories/tv_series_repository_impl.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_series.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tv_series_provider.g.dart';

@riverpod
Future<List<TVSeries>> trendingTVSeries(Ref ref, {int page = 1}) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.getTrendingTVSeries(page: page);
}

@riverpod
Future<List<TVSeries>> discoverTVSeries(Ref ref, {int page = 1}) {
  final repository = ref.watch(tvSeriesRepositoryProvider);
  return repository.discoverTVSeries(page: page);
}

@riverpod
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
