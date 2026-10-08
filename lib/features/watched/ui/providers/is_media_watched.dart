import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/data/repositories/auth/auth_providers.dart';
import 'package:filmania/data/repositories/watched/watched_repository_impl.dart';
import 'package:filmania/data/repositories/tv_series/tv_series_providers.dart';

part 'is_media_watched.g.dart';

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
