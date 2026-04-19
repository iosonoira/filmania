import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
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

  const WatchedButton({
    super.key,
    required this.mediaId,
    required this.mediaTitle,
    required this.mediaType,
    this.posterPath,
    this.isIconOnly = false,
    this.hasBackground = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final user = ref.watch(authStateProvider).value;
    
    // FutureProvider for checking watched status
    final isWatchedAsync = ref.watch(isMediaWatchedProvider(
      mediaId: mediaId,
      mediaType: mediaType,
    ));

    final isWatched = isWatchedAsync.value ?? false;

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
        } else {
          await repo.markAsWatched(
            WatchedItem(
              id: '',
              userId: user.id,
              mediaId: mediaId,
              mediaTitle: mediaTitle,
              mediaType: mediaType,
              posterPath: posterPath,
              watchedAt: DateTime.now(),
            ),
          );
        }
        // Invalidate to refresh immediately
        ref.invalidate(isMediaWatchedProvider(
          mediaId: mediaId,
          mediaType: mediaType,
        ));
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
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
          maxWidth: 32,
          maxHeight: 32,
        ),
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: hasBackground 
            ? (isWatched ? colors.primary.withValues(alpha: 0.8) : Colors.black.withValues(alpha: 0.3))
            : Colors.transparent,
          foregroundColor: (hasBackground || !isWatched) ? Colors.white : colors.primary,
          minimumSize: const Size(32, 32),
          fixedSize: const Size(32, 32),
          padding: EdgeInsets.zero,
        ),
        icon: Icon(
          isWatched ? Icons.visibility : Icons.visibility_outlined,
          size: 18,
        ),
        onPressed: toggleWatched,
      );
    }

    return OutlinedButton.icon(
      onPressed: toggleWatched,
      style: OutlinedButton.styleFrom(
        foregroundColor: isWatched ? colors.primary : colors.primary,
        backgroundColor: isWatched ? colors.primary.withValues(alpha: 0.1) : Colors.transparent,
        side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
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
