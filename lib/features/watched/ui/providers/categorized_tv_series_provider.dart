import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../domain/entities/watched_item.dart';
import '../../data/repositories/watched_repository_impl.dart';
import '../../../tv_series/ui/providers/tv_series_provider.dart';
import 'watched_providers.dart';

part 'categorized_tv_series_provider.g.dart';

enum TvSeriesWatchStatus {
  watching, // "In visione"
  upToDate, // "In pari"
  completed // "Terminate"
}

class CategorizedTvSeries {
  final WatchedItem series;
  final TvSeriesWatchStatus status;

  CategorizedTvSeries({required this.series, required this.status});
}

@riverpod
Future<List<CategorizedTvSeries>> categorizedTvSeries(Ref ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return [];

  final watchedItemsAsync = ref.watch(watchedItemsProvider(MediaType.tv));
  
  if (watchedItemsAsync.isLoading || !watchedItemsAsync.hasValue) {
    return []; 
  }
  
  final watchedItems = watchedItemsAsync.value!;
  final repo = ref.watch(watchedRepositoryProvider);

  final List<CategorizedTvSeries> result = [];

  for (final item in watchedItems) {
    try {
      final watchedCount = await repo.getWatchedEpisodesCount(
        userId: user.id,
        seriesId: item.mediaId,
      );

      final seriesDetails = await ref.watch(tvSeriesDetailsProvider(item.mediaId).future);
      final totalEpisodes = seriesDetails.seasons
          .where((s) => s.seasonNumber > 0)
          .fold(0, (sum, s) => sum + s.episodeCount);

      TvSeriesWatchStatus status;

      if (watchedCount < totalEpisodes) {
        status = TvSeriesWatchStatus.watching;
      } else {
        if (seriesDetails.status.toLowerCase() == 'ended' || seriesDetails.status.toLowerCase() == 'canceled') {
          status = TvSeriesWatchStatus.completed;
        } else {
          status = TvSeriesWatchStatus.upToDate;
        }
      }

      result.add(CategorizedTvSeries(series: item, status: status));
    } catch (e) {
      result.add(CategorizedTvSeries(series: item, status: TvSeriesWatchStatus.watching));
    }
  }

  return result;
}
