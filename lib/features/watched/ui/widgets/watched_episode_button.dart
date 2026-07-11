import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations_provider.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/utils/logger.dart';
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

  void _refreshEpisodeState(WidgetRef ref) {
    // Invalidate both the episode status AND the series watched status
    // since marking an episode might trigger marking the series as watched
    ref.invalidate(
      isEpisodeWatchedProvider(
        seriesId: seriesId,
        seasonNumber: seasonNumber,
        episodeNumber: episodeNumber,
      ),
    );
    // Also refresh the series progress stream if anyone is watching it
    ref.invalidate(watchedEpisodesProvider(seriesId));
    // Refreshes the eye icon on the series poster
    ref.invalidate(
      isMediaWatchedProvider(mediaId: seriesId, mediaType: MediaType.tv),
    );
    // Refreshes the list in the "Watched" page
    ref.invalidate(watchedItemsProvider(MediaType.tv));
  }

  Future<void> _markEpisodeWatched(WidgetRef ref) async {
    final user = ref.read(authStateProvider).value;
    if (user == null) return;
    final repo = ref.read(watchedRepositoryProvider);
    await repo.markEpisodeAsWatched(
      userId: user.id,
      seriesId: seriesId,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
      seriesTitle: seriesTitle,
      seriesPosterPath: seriesPosterPath,
      runtimeMinutes: runtimeMinutes,
    );
    _refreshEpisodeState(ref);
  }

  Future<void> _undoUnwatch(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    try {
      await _markEpisodeWatched(ref);
    } catch (e, stack) {
      AppLogger.error(
        'undoUnwatch failed',
        tag: 'WatchedEpisodeButton',
        exception: e,
        stackTrace: stack,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errorUpdating)));
      }
    }
  }

  Future<void> _toggleWatched(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    bool isWatched,
  ) async {
    final user = ref.read(authStateProvider).value;
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
        _refreshEpisodeState(ref);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.unwatchedSnackbarMessage),
              action: SnackBarAction(
                label: l10n.undoAction,
                onPressed: () => _undoUnwatch(context, ref, l10n),
              ),
            ),
          );
        }
      } else {
        await _markEpisodeWatched(ref);
      }
    } catch (e, stack) {
      AppLogger.error(
        'toggleWatched failed',
        tag: 'WatchedEpisodeButton',
        exception: e,
        stackTrace: stack,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errorUpdating)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(appLocalizationsProvider);
    final isWatchedAsync = ref.watch(
      isEpisodeWatchedProvider(
        seriesId: seriesId,
        seasonNumber: seasonNumber,
        episodeNumber: episodeNumber,
      ),
    );
    final isWatched = isWatchedAsync.value ?? false;
    final label = isWatched
        ? l10n.watchedButtonLabelWatched
        : l10n.watchedButtonLabelUnwatched;
    void onPressed() => _toggleWatched(context, ref, l10n, isWatched);

    if (isIconOnly) {
      return _WatchedEpisodeIconBadge(
        isWatched: isWatched,
        label: label,
        onPressed: onPressed,
      );
    }

    return _WatchedEpisodeFilledButton(
      isWatched: isWatched,
      label: label,
      onPressed: onPressed,
    );
  }
}

class _WatchedEpisodeIconBadge extends StatelessWidget {
  final bool isWatched;
  final String label;
  final VoidCallback onPressed;

  const _WatchedEpisodeIconBadge({
    required this.isWatched,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return IconButton(
      tooltip: label,
      style: IconButton.styleFrom(
        backgroundColor: isWatched
            ? colors.primary.withValues(alpha: 0.14)
            : Colors.transparent,
      ),
      icon: Icon(
        isWatched
            ? Icons.check_circle_rounded
            : Icons.check_circle_outline_rounded,
        color: isWatched ? colors.primary : colors.onSurfaceSecondary,
      ),
      onPressed: onPressed,
    );
  }
}

class _WatchedEpisodeFilledButton extends StatelessWidget {
  final bool isWatched;
  final String label;
  final VoidCallback onPressed;

  const _WatchedEpisodeFilledButton({
    required this.isWatched,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        foregroundColor: isWatched ? colors.primary : colors.onSurfacePrimary,
        backgroundColor: isWatched
            ? colors.primary.withValues(alpha: 0.14)
            : colors.onSurfaceSecondary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      icon: Icon(
        isWatched ? Icons.check_circle : Icons.visibility_outlined,
        size: 18,
      ),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
