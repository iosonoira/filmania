import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../tv_series/domain/entities/tv_series.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../watchlist/ui/widgets/watchlist_picker_sheet.dart';

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

    return Semantics(
      label: 'Media: $title, voto ${voteAverage.toStringAsFixed(1)}',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
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

              // Bookmark Button
              Positioned(
                top: 8,
                left: 8,
                child: GlassOverlay(
                  sigma: 10,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withValues(alpha: 0.5),
                  child: IconButton(
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
              ),

              // Vote Average Badge
              Positioned(
                top: 8,
                right: 8,
                child: GlassOverlay(
                  sigma: 10,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          voteAverage.toStringAsFixed(1),
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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
