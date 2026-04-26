import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../data/repositories/watched_repository_impl.dart';
import '../providers/watched_providers.dart';

class WatchedEpisodeButton extends ConsumerWidget {
  final int seriesId;
  final int seasonNumber;
  final int episodeNumber;
  final String seriesTitle;
  final String? seriesPosterPath;
  final bool isIconOnly;
  final int? runtimeMinutes;

  const WatchedEpisodeButton({
    super.key,
    required this.seriesId,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.seriesTitle,
    this.seriesPosterPath,
    this.isIconOnly = false,
    this.runtimeMinutes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final user = ref.watch(authStateProvider).value;

    final isWatchedAsync = ref.watch(isEpisodeWatchedProvider(
      seriesId: seriesId,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
    ));

    final isWatched = isWatchedAsync.value ?? false;

    Future<void> toggleWatched() async {
      if (user == null) return;
      final repo = ref.read(watchedRepositoryProvider);

      try {
        if (isWatched) {
          await repo.markEpisodeAsUnwatched(
            userId: user.id,
            seriesId: seriesId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
          );
        } else {
          await repo.markEpisodeAsWatched(
            userId: user.id,
            seriesId: seriesId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            seriesTitle: seriesTitle,
            seriesPosterPath: seriesPosterPath,
            runtimeMinutes: runtimeMinutes,
          );
        }
        
        // Invalidate both the episode status AND the series watched status
        // since marking an episode might trigger marking the series as watched
        ref.invalidate(isEpisodeWatchedProvider(
          seriesId: seriesId,
          seasonNumber: seasonNumber,
          episodeNumber: episodeNumber,
        ));
        
        // Also refresh the series progress stream if anyone is watching it
        ref.invalidate(watchedEpisodesProvider(seriesId));

        // Refreshes the eye icon on the series poster
        ref.invalidate(isMediaWatchedProvider(
          mediaId: seriesId,
          mediaType: MediaType.tv,
        ));

        // Refreshes the list in the "Watched" page
        ref.invalidate(watchedItemsProvider(MediaType.tv));
        
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Errore durante l\'aggiornamento.')),
          );
        }
      }
    }

    if (isIconOnly) {
      return IconButton(
        icon: Icon(
          isWatched ? Icons.visibility : Icons.visibility_outlined,
          color: isWatched ? colors.primary : colors.onSurfaceSecondary,
        ),
        onPressed: toggleWatched,
      );
    }

    return OutlinedButton.icon(
      onPressed: toggleWatched,
      style: OutlinedButton.styleFrom(
        foregroundColor: isWatched ? colors.primary : colors.onSurfacePrimary,
        backgroundColor: isWatched ? colors.primary.withValues(alpha: 0.1) : Colors.transparent,
        side: BorderSide(
          color: isWatched ? colors.primary.withValues(alpha: 0.5) : colors.onSurfaceSecondary.withValues(alpha: 0.3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
      icon: Icon(
        isWatched ? Icons.check_circle : Icons.visibility_outlined,
        size: 18,
      ),
      label: Text(
        isWatched ? 'Visto' : 'Segna come Visto',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
