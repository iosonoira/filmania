import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/core/l10n/app_localizations_provider.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/utils/logger.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/watched/domain/entities/watched_item.dart';
import 'package:filmania/features/watched/ui/providers/watched_providers.dart';
import 'package:filmania/features/watched/data/repositories/watched_repository_impl.dart';

class WatchedButton extends ConsumerWidget {
  final int mediaId;
  final String mediaTitle;
  final MediaType mediaType;
  final String? posterPath;
  final bool isIconOnly;
  final bool hasBackground;
  final int? runtimeMinutes;

  /// Icon color for the unwatched state when [hasBackground] is false.
  /// Defaults to white because most icon-only uses sit on top of a poster
  /// or a tinted glass badge; pass a theme color when the button sits on a
  /// plain surface, where white would be invisible in light mode.
  final Color? unwatchedIconColor;

  const WatchedButton({
    super.key,
    required this.mediaId,
    required this.mediaTitle,
    required this.mediaType,
    this.posterPath,
    this.isIconOnly = false,
    this.hasBackground = true,
    this.runtimeMinutes,
    this.unwatchedIconColor,
  });

  void _refreshWatchedState(WidgetRef ref) {
    ref.invalidate(
      isMediaWatchedProvider(mediaId: mediaId, mediaType: mediaType),
    );
    ref.invalidate(watchedItemsProvider(mediaType));
    if (mediaType == MediaType.tv) {
      ref.invalidate(watchedEpisodesProvider(mediaId));
    }
  }

  Future<void> _markWatched(WidgetRef ref) async {
    final user = ref.read(authStateProvider).value;
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
    _refreshWatchedState(ref);
  }

  Future<void> _undoUnwatch(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    try {
      await _markWatched(ref);
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
        await repo.removeFromWatched(
          userId: user.id,
          mediaId: mediaId,
          mediaType: mediaType,
        );
        _refreshWatchedState(ref);
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
        await _markWatched(ref);
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(appLocalizationsProvider);
    final isWatchedAsync = ref.watch(
      isMediaWatchedProvider(mediaId: mediaId, mediaType: mediaType),
    );
    final isWatched = isWatchedAsync.value ?? false;
    final label = isWatched
        ? l10n.watchedButtonLabelWatched
        : l10n.watchedButtonLabelUnwatched;
    void onPressed() => _toggleWatched(context, ref, l10n, isWatched);

    if (isIconOnly) {
      return _WatchedIconBadge(
        isWatched: isWatched,
        hasBackground: hasBackground,
        unwatchedIconColor: unwatchedIconColor,
        label: label,
        onPressed: onPressed,
      );
    }

    return _WatchedFilledButton(
      isWatched: isWatched,
      label: label,
      onPressed: onPressed,
    );
  }
}

/// Visual badge stays 32x32 (unchanged look on poster overlays); the
/// IconButton's own hit area is left at the platform default (min
/// 48x48) so the tap target meets the project's accessibility rule
/// without growing the visible circle.
class _WatchedIconBadge extends StatelessWidget {
  final bool isWatched;
  final bool hasBackground;
  final Color? unwatchedIconColor;
  final String label;
  final VoidCallback onPressed;

  const _WatchedIconBadge({
    required this.isWatched,
    required this.hasBackground,
    this.unwatchedIconColor,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final Color iconColor;
    if (hasBackground) {
      iconColor = Colors.white;
    } else if (isWatched) {
      iconColor = colors.primary;
    } else {
      iconColor = unwatchedIconColor ?? Colors.white;
    }
    return IconButton(
      tooltip: label,
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
          color: iconColor,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class _WatchedFilledButton extends StatelessWidget {
  final bool isWatched;
  final String label;
  final VoidCallback onPressed;

  const _WatchedFilledButton({
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
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
