import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/selection/media_selection_item.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../data/repositories/watched_repository_impl.dart';
import '../../domain/entities/watched_item.dart';
import '../providers/categorized_tv_series_provider.dart';
import '../providers/watched_providers.dart';

/// Toggles watched status for every item in [items], one at a time,
/// mirroring the per-item logic in `WatchedButton`. An already-watched
/// item is removed from watched; an unwatched item is marked watched.
/// Used by every multi-select action bar's "mark watched/unwatched" action
/// so the toggle-and-invalidate logic exists in exactly one place.
///
/// The add-vs-remove decision is made from [IWatchedRepository.isWatched]
/// (raw presence in the watched table) rather than [isMediaWatchedProvider]
/// — the latter additionally requires ALL episodes of a TV series to be
/// watched before reporting `true`, so a series sitting in the "watching"
/// (incomplete) tab would otherwise be seen as "not watched" and get
/// re-added instead of removed when the user taps "mark unwatched".
///
/// Each item is applied independently: a failure on one item is caught so
/// it doesn't abort the rest of the batch. Returns the number of items
/// that failed, so the caller can surface an error toast.
Future<int> toggleWatchedBulk(
  WidgetRef ref, {
  required List<MediaSelectionItem> items,
}) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) return items.length;
  final repo = ref.read(watchedRepositoryProvider);

  var failureCount = 0;
  for (final item in items) {
    try {
      final isWatched = await repo.isWatched(
        userId: user.id,
        mediaId: item.mediaId,
        mediaType: item.mediaType,
      );

      if (isWatched) {
        await repo.removeFromWatched(
          userId: user.id,
          mediaId: item.mediaId,
          mediaType: item.mediaType,
        );
      } else {
        await repo.markAsWatched(
          WatchedItem(
            id: '',
            userId: user.id,
            mediaId: item.mediaId,
            mediaTitle: item.title,
            mediaType: item.mediaType,
            posterPath: item.posterPath,
            watchedAt: DateTime.now(),
          ),
        );
      }

      ref.invalidate(
        isMediaWatchedProvider(
          mediaId: item.mediaId,
          mediaType: item.mediaType,
        ),
      );
      ref.invalidate(watchedItemsProvider(item.mediaType));
    } catch (_) {
      failureCount++;
    }
  }
  return failureCount;
}

/// Marks every TV series in [items] as dropped ("Interrotta"), moving them
/// out of the "watching"/"up to date"/"completed" tabs regardless of their
/// episode-count-derived status — see [TvSeriesWatchStatus.dropped] and its
/// priority handling in `categorizedTvSeries`.
///
/// Each item is applied independently: a failure on one item is caught so
/// it doesn't abort the rest of the batch. Returns the number of items
/// that failed, so the caller can surface an error toast.
Future<int> markSeriesDroppedBulk(
  WidgetRef ref, {
  required List<MediaSelectionItem> items,
  required bool isDropped,
}) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) return items.length;
  final repo = ref.read(watchedRepositoryProvider);

  var failureCount = 0;
  for (final item in items) {
    try {
      await repo.markSeriesAsDropped(
        userId: user.id,
        seriesId: item.mediaId,
        isDropped: isDropped,
      );
    } catch (_) {
      failureCount++;
    }
  }
  ref.invalidate(categorizedTvSeriesProvider);
  return failureCount;
}
