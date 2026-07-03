import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/selection/media_selection_item.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../data/repositories/watched_repository_impl.dart';
import '../../domain/entities/watched_item.dart';
import '../providers/watched_providers.dart';

/// Toggles watched status for every item in [items], one at a time,
/// mirroring the per-item logic in `WatchedButton`. An already-watched
/// item is removed from watched; an unwatched item is marked watched.
/// Used by every multi-select action bar's "mark watched/unwatched" action
/// so the toggle-and-invalidate logic exists in exactly one place.
Future<void> toggleWatchedBulk(
  WidgetRef ref, {
  required List<MediaSelectionItem> items,
}) async {
  final user = ref.read(authStateProvider).value;
  if (user == null) return;
  final repo = ref.read(watchedRepositoryProvider);

  for (final item in items) {
    final isWatched = await ref.read(
      isMediaWatchedProvider(
        mediaId: item.mediaId,
        mediaType: item.mediaType,
      ).future,
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
      isMediaWatchedProvider(mediaId: item.mediaId, mediaType: item.mediaType),
    );
    ref.invalidate(watchedItemsProvider(item.mediaType));
  }
}
