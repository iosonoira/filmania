import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/utils/concurrency.dart';
import 'package:filmania/ui/core/ui/selection/episode_selection_item.dart';
import 'package:filmania/ui/core/ui/selection/media_selection_item.dart';
import 'package:filmania/data/repositories/watched/watched_repository_impl.dart';
import 'package:filmania/domain/models/watched_item.dart';
import 'package:filmania/features/watched/ui/providers/categorized_tv_series_provider.dart';
import 'package:filmania/data/repositories/watched/watched_providers.dart';
import 'package:filmania/data/repositories/auth/auth_providers.dart';
import 'package:filmania/features/watched/ui/providers/is_media_watched.dart';

/// Bulk actions apply to at most a screenful of selected items, but run
/// against Supabase over the network — bounded concurrency (matching the
/// concurrency already used for TMDB/Supabase batch fetches in
/// `categorized_tv_series_provider.dart`) is faster than a sequential loop
/// without risking a `Future.wait`-everything-at-once burst against
/// Supabase's rate limits.
const _bulkActionConcurrency = 5;

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

  final affectedMediaTypes = <MediaType>{};
  final results = await mapWithConcurrency<MediaSelectionItem, bool>(
    items,
    _bulkActionConcurrency,
    (item) async {
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

        affectedMediaTypes.add(item.mediaType);
        ref.invalidate(
          isMediaWatchedProvider(
            mediaId: item.mediaId,
            mediaType: item.mediaType,
          ),
        );
        return true;
      } catch (_) {
        return false;
      }
    },
  );
  // Invalidated once per distinct media type after the whole batch settles,
  // not per item: `watchedItemsProvider` wraps a Supabase Realtime stream,
  // and invalidating it N times in a tight loop tears down and recreates
  // the channel subscription N times back-to-back — a race that can render
  // a transient duplicate/stale item list before the final subscription
  // catches up (most visible when a second bulk call, e.g. undo, follows
  // the first one within a couple of seconds).
  for (final mediaType in affectedMediaTypes) {
    ref.invalidate(watchedItemsProvider(mediaType));
  }
  return results.where((succeeded) => !succeeded).length;
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

  final results = await mapWithConcurrency<MediaSelectionItem, bool>(
    items,
    _bulkActionConcurrency,
    (item) async {
      try {
        await repo.markSeriesAsDropped(
          userId: user.id,
          seriesId: item.mediaId,
          isDropped: isDropped,
        );
        return true;
      } catch (_) {
        return false;
      }
    },
  );
  ref.invalidate(categorizedTvSeriesProvider);
  return results.where((succeeded) => !succeeded).length;
}

/// Marks every TV series in [items] as "watch later" ("Guarda più tardi"),
/// moving them out of the "watching"/"up to date"/"completed" tabs the same
/// way [markSeriesDroppedBulk] does for dropped series — see
/// [TvSeriesWatchStatus.watchLater] and its priority handling in
/// `categorizedTvSeries`.
///
/// Each item is applied independently: a failure on one item is caught so
/// it doesn't abort the rest of the batch. Returns the number of items
/// that failed, so the caller can surface an error toast.
Future<int> markSeriesWatchLaterBulk(
  WidgetRef ref, {
  required List<MediaSelectionItem> items,
  required bool isWatchLater,
}) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) return items.length;
  final repo = ref.read(watchedRepositoryProvider);

  final results = await mapWithConcurrency<MediaSelectionItem, bool>(
    items,
    _bulkActionConcurrency,
    (item) async {
      try {
        await repo.markSeriesAsWatchLater(
          userId: user.id,
          seriesId: item.mediaId,
          isWatchLater: isWatchLater,
        );
        return true;
      } catch (_) {
        return false;
      }
    },
  );
  ref.invalidate(categorizedTvSeriesProvider);
  return results.where((succeeded) => !succeeded).length;
}

/// Marks every episode in [items] as watched, mirroring the per-episode
/// logic in `WatchedEpisodeButton.toggleWatched`'s watched branch. Used by
/// the episode list's multi-select action bar (Task 12) so bulk marking
/// reuses the same repository call and invalidation set as the single-item
/// button instead of duplicating them.
///
/// Each item is applied independently: a failure on one item is caught so
/// it doesn't abort the rest of the batch. Returns the number of items that
/// failed, so the caller can surface an error toast.
Future<int> markEpisodesWatchedBulk(
  WidgetRef ref, {
  required List<EpisodeSelectionItem> items,
}) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) return items.length;
  final repo = ref.read(watchedRepositoryProvider);

  final affectedSeriesIds = <int>{};
  final results = await mapWithConcurrency<EpisodeSelectionItem, bool>(
    items,
    _bulkActionConcurrency,
    (item) async {
      try {
        await repo.markEpisodeAsWatched(
          userId: user.id,
          seriesId: item.seriesId,
          seasonNumber: item.seasonNumber,
          episodeNumber: item.episodeNumber,
          seriesTitle: item.seriesTitle,
          seriesPosterPath: item.seriesPosterPath,
          runtimeMinutes: item.runtimeMinutes,
        );
        affectedSeriesIds.add(item.seriesId);

        ref.invalidate(
          isEpisodeWatchedProvider(
            seriesId: item.seriesId,
            seasonNumber: item.seasonNumber,
            episodeNumber: item.episodeNumber,
          ),
        );
        return true;
      } catch (_) {
        return false;
      }
    },
  );

  for (final seriesId in affectedSeriesIds) {
    ref.invalidate(watchedEpisodesProvider(seriesId));
    ref.invalidate(
      isMediaWatchedProvider(mediaId: seriesId, mediaType: MediaType.tv),
    );
  }
  ref.invalidate(watchedItemsProvider(MediaType.tv));
  return results.where((succeeded) => !succeeded).length;
}
