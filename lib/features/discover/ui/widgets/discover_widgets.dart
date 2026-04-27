import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../tv_series/domain/entities/tv_series.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../watchlist/ui/widgets/watchlist_picker_sheet.dart';
import '../../../watched/ui/widgets/watched_button.dart';

class MediaGridCard extends ConsumerWidget {
  final int mediaId;
  final String title;
  final String? posterUrl;
  final String? posterPath;
  final String? releaseYear;
  final double voteAverage;
  final MediaType mediaType;
  final VoidCallback? onTap;

  const MediaGridCard({
    super.key,
    required this.mediaId,
    required this.title,
    required this.posterUrl,
    required this.posterPath,
    required this.releaseYear,
    required this.voteAverage,
    required this.mediaType,
    this.onTap,
  });

  factory MediaGridCard.movie({
    required Movie movie,
    VoidCallback? onTap,
  }) {
    return MediaGridCard(
      mediaId: movie.id,
      title: movie.title,
      posterUrl: movie.fullPosterUrl,
      posterPath: movie.posterPath,
      releaseYear: movie.releaseDate?.year.toString(),
      voteAverage: movie.voteAverage,
      mediaType: MediaType.movie,
      onTap: onTap,
    );
  }

  factory MediaGridCard.tv({
    required TVSeries tv,
    VoidCallback? onTap,
  }) {
    return MediaGridCard(
      mediaId: tv.id,
      title: tv.name,
      posterUrl: tv.fullPosterUrl,
      posterPath: tv.posterPath,
      releaseYear: tv.firstAirDate?.year.toString(),
      voteAverage: tv.voteAverage,
      mediaType: MediaType.tv,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: 'Media: $title, voto ${voteAverage.toStringAsFixed(1)}',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Poster
              if (posterUrl != null)
                CachedNetworkImage(
                  imageUrl: posterUrl!,
                  fit: BoxFit.cover,
                  memCacheWidth: 300,
                  placeholder: (context, url) => Container(
                    color: colors.surface.withValues(alpha: 0.1),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: colors.surface,
                    child: const Icon(Icons.movie_rounded, size: 40),
                  ),
                )
              else
                Container(
                  color: colors.surface,
                  child: const Icon(Icons.movie_rounded, size: 40),
                ),
              
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
              ),

              // Buttons (Watched & Watchlist)
              Positioned(
                top: 8,
                right: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GlassOverlay(
                      sigma: 10,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withValues(alpha: 0.5),
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: WatchedButton(
                          mediaId: mediaId,
                          mediaTitle: title,
                          mediaType: mediaType,
                          posterPath: posterPath,
                          isIconOnly: true,
                          hasBackground: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    GlassOverlay(
                      sigma: 10,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withValues(alpha: 0.5),
                      child: IconButton(
                        style: IconButton.styleFrom(
                          minimumSize: const Size(32, 32),
                          fixedSize: const Size(32, 32),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                          maxWidth: 32,
                          maxHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.bookmark_add_outlined, color: Colors.white, size: 18),
                        onPressed: () => showWatchlistPicker(
                          context,
                          ref,
                          mediaId: mediaId,
                          mediaTitle: title,
                          mediaType: mediaType,
                          posterPath: posterPath,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Info
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (releaseYear != null)
                      Text(
                        releaseYear!,
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
