import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../domain/entities/watched_item.dart';
import '../../data/repositories/watched_repository_impl.dart';
import '../../../tv_series/ui/providers/tv_series_provider.dart';

part 'watched_providers.g.dart';

@riverpod
Stream<List<WatchedItem>> watchedItems(Ref ref, MediaType mediaType) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  final repo = ref.watch(watchedRepositoryProvider);
  return repo.watchUserWatchedItems(user.id, mediaType);
}

@riverpod
Future<bool> isMediaWatched(
  Ref ref, {
  required int mediaId,
  required MediaType mediaType,
}) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;

  final repo = ref.watch(watchedRepositoryProvider);
  final isWatched = await repo.isWatched(
    userId: user.id,
    mediaId: mediaId,
    mediaType: mediaType,
  );

  // If not even in the watched list, it's definitely not watched/completed
  if (!isWatched) return false;
  
  // For movies, presence in the list is enough
  if (mediaType == MediaType.movie) return true;

  // For TV series, it must be COMPLETED (all episodes seen) to color the icon
  try {
    final watchedCount = await repo.getWatchedEpisodesCount(
      userId: user.id,
      seriesId: mediaId,
    );
    
    // Fetch series details to know the total episode count
    // Note: This relies on the provider cache if already fetched
    final series = await ref.watch(tvSeriesDetailsProvider(mediaId).future);
    final totalEpisodes = series.seasons
        .where((s) => s.seasonNumber > 0)
        .fold(0, (sum, s) => sum + s.episodeCount);

    return watchedCount >= totalEpisodes;
  } catch (_) {
    // Fallback: if we can't determine completion, show as watched since it's in the list
    return true;
  }
}

@riverpod
Future<bool> isEpisodeWatched(
  Ref ref, {
  required int seriesId,
  required int seasonNumber,
  required int episodeNumber,
}) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;

  final repo = ref.watch(watchedRepositoryProvider);
  return repo.isEpisodeWatched(
    userId: user.id,
    seriesId: seriesId,
    seasonNumber: seasonNumber,
    episodeNumber: episodeNumber,
  );
}

@riverpod
Stream<List<String>> watchedEpisodes(Ref ref, int seriesId) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  final repo = ref.watch(watchedRepositoryProvider);
  return repo.watchWatchedEpisodes(user.id, seriesId);
}
