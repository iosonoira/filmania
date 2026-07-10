import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/l10n/app_localizations_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../domain/entities/watched_item.dart';
import '../providers/watched_providers.dart';
import '../../data/repositories/watched_repository_impl.dart';

class WatchedButton extends ConsumerWidget {
  final int mediaId;
  final String mediaTitle;
  final MediaType mediaType;
  final String? posterPath;
  final bool isIconOnly;
  final bool hasBackground;
  final int? runtimeMinutes;

  const WatchedButton({
    super.key,
    required this.mediaId,
    required this.mediaTitle,
    required this.mediaType,
    this.posterPath,
    this.isIconOnly = false,
    this.hasBackground = true,
    this.runtimeMinutes,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final l10n = ref.watch(appLocalizationsProvider);
    final user = ref.watch(authStateProvider).value;

    // FutureProvider for checking watched status
    final isWatchedAsync = ref.watch(
      isMediaWatchedProvider(mediaId: mediaId, mediaType: mediaType),
    );

    final isWatched = isWatchedAsync.value ?? false;

    void refreshWatchedState() {
      ref.invalidate(
        isMediaWatchedProvider(mediaId: mediaId, mediaType: mediaType),
      );
      ref.invalidate(watchedItemsProvider(mediaType));
      if (mediaType == MediaType.tv) {
        ref.invalidate(watchedEpisodesProvider(mediaId));
      }
    }

    Future<void> markWatched() async {
      if (user == null) return;
      final repo = ref.read(watchedRepositoryProvider);
      await repo.markAsWatched(
        WatchedItem(
          id: '',
          userId: user.id,
          mediaId: mediaId,
          mediaTitle: mediaTitle,
          mediaType: mediaType,
          posterPath: posterPath,
          watchedAt: DateTime.now(),
          runtimeMinutes: runtimeMinutes,
        ),
      );
      refreshWatchedState();
    }

    Future<void> undoUnwatch() async {
      try {
        await markWatched();
      } catch (e, stack) {
        AppLogger.error(
          'undoUnwatch failed',
          tag: 'WatchedButton',
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

    Future<void> toggleWatched() async {
      if (user == null) return;
      final repo = ref.read(watchedRepositoryProvider);

      try {
        if (isWatched) {
          await repo.removeFromWatched(
            userId: user.id,
            mediaId: mediaId,
            mediaType: mediaType,
          );
          refreshWatchedState();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.unwatchedSnackbarMessage),
                action: SnackBarAction(
                  label: l10n.undoAction,
                  onPressed: () => undoUnwatch(),
                ),
              ),
            );
          }
        } else {
          await markWatched();
        }
      } catch (e, stack) {
        AppLogger.error(
          'toggleWatched failed',
          tag: 'WatchedButton',
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

    if (isIconOnly) {
      // Visual badge stays 32x32 (unchanged look on poster overlays); the
      // IconButton's own hit area is left at the platform default (min
      // 48x48) so the tap target meets the project's accessibility rule
      // without growing the visible circle.
      return IconButton(
        tooltip: isWatched
            ? l10n.watchedButtonLabelWatched
            : l10n.watchedButtonLabelUnwatched,
        padding: EdgeInsets.zero,
        icon: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasBackground
                ? (isWatched
                      ? colors.primary.withValues(alpha: 0.8)
                      : Colors.black.withValues(alpha: 0.3))
                : Colors.transparent,
          ),
          child: Icon(
            isWatched ? Icons.visibility : Icons.visibility_outlined,
            size: 18,
            color: (hasBackground || !isWatched)
                ? Colors.white
                : colors.primary,
          ),
        ),
        onPressed: toggleWatched,
      );
    }

    return FilledButton.tonalIcon(
      onPressed: toggleWatched,
      style: FilledButton.styleFrom(
        foregroundColor: colors.primary,
        backgroundColor: isWatched
            ? colors.primary.withValues(alpha: 0.15)
            : colors.onSurfaceSecondary.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      icon: Icon(
        isWatched ? Icons.check_circle : Icons.visibility_outlined,
        size: 18,
      ),
      label: Text(
        isWatched
            ? l10n.watchedButtonLabelWatched
            : l10n.watchedButtonLabelUnwatched,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
