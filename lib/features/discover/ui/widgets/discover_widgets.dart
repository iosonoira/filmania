import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../tv_series/domain/entities/tv_series.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';

class MediaGridCard extends StatelessWidget {
  final String title;
  final String? posterUrl;
  final String? releaseYear;
  final double voteAverage;
  final VoidCallback? onTap;

  const MediaGridCard({
    super.key,
    required this.title,
    required this.posterUrl,
    required this.releaseYear,
    required this.voteAverage,
    this.onTap,
  });

  factory MediaGridCard.movie({
    required Movie movie,
    VoidCallback? onTap,
  }) {
    return MediaGridCard(
      title: movie.title,
      posterUrl: movie.fullPosterUrl,
      releaseYear: movie.releaseDate?.year.toString(),
      voteAverage: movie.voteAverage,
      onTap: onTap,
    );
  }

  factory MediaGridCard.tv({
    required TVSeries tv,
    VoidCallback? onTap,
  }) {
    return MediaGridCard(
      title: tv.name,
      posterUrl: tv.fullPosterUrl,
      releaseYear: tv.firstAirDate?.year.toString(),
      voteAverage: tv.voteAverage,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Image.network(
                  posterUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
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
