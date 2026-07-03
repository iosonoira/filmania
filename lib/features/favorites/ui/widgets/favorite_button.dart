import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../domain/entities/favorite_item.dart';
import '../../data/repositories/favorites_repository_impl.dart';
import '../providers/favorites_providers.dart';

/// Icon-only toggle for adding/removing a movie or TV series from
/// favorites. Reused as a secondary action on detail pages and as the
/// removal badge on the Favorites grid.
class FavoriteButton extends ConsumerStatefulWidget {
  final int mediaId;
  final String mediaTitle;
  final MediaType mediaType;
  final String? posterPath;
  final double size;
  final bool hasBackground;

  const FavoriteButton({
    super.key,
    required this.mediaId,
    required this.mediaTitle,
    required this.mediaType,
    this.posterPath,
    this.size = 32,
    this.hasBackground = true,
  });

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton> {
  bool _isToggling = false;

  Future<void> _toggle(bool isFavorite, String? userId) async {
    if (userId == null || _isToggling) return;
    setState(() => _isToggling = true);

    final repo = ref.read(favoritesRepositoryProvider);
    try {
      if (isFavorite) {
        await repo.removeFavorite(
          userId: userId,
          mediaId: widget.mediaId,
          mediaType: widget.mediaType,
        );
      } else {
        await repo.addFavorite(
          FavoriteItem(
            id: '',
            userId: userId,
            mediaId: widget.mediaId,
            mediaTitle: widget.mediaTitle,
            mediaType: widget.mediaType,
            posterPath: widget.posterPath,
            createdAt: DateTime.now(),
          ),
        );
      }
      ref.invalidate(
        isMediaFavoriteProvider(
          mediaId: widget.mediaId,
          mediaType: widget.mediaType,
        ),
      );
    } catch (e) {
      AppLogger.error(
        'Favorite toggle failed',
        tag: 'FavoriteButton',
        exception: e,
      );
    } finally {
      if (mounted) setState(() => _isToggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final user = ref.watch(authStateProvider).value;
    final isFavoriteAsync = ref.watch(
      isMediaFavoriteProvider(
        mediaId: widget.mediaId,
        mediaType: widget.mediaType,
      ),
    );
    final isFavorite = isFavoriteAsync.value ?? false;

    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: widget.size,
        minHeight: widget.size,
        maxWidth: widget.size,
        maxHeight: widget.size,
      ),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: widget.hasBackground
            ? (isFavorite
                  ? colors.primary.withValues(alpha: 0.8)
                  : Colors.black.withValues(alpha: 0.3))
            : Colors.transparent,
        foregroundColor: (widget.hasBackground || !isFavorite)
            ? Colors.white
            : colors.primary,
        minimumSize: Size(widget.size, widget.size),
        fixedSize: Size(widget.size, widget.size),
        padding: EdgeInsets.zero,
      ),
      icon: _isToggling
          ? SizedBox(
              width: widget.size * 0.5,
              height: widget.size * 0.5,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: widget.size * 0.55,
            ),
      onPressed: _isToggling ? null : () => _toggle(isFavorite, user?.id),
      tooltip: isFavorite
          ? AppLocalizations.of(context)!.removeFromFavorites
          : AppLocalizations.of(context)!.addToFavorites,
    );
  }
}
