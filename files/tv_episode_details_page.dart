import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../watched/ui/widgets/watched_episode_button.dart';
import '../../domain/entities/tv_episode.dart';
import '../providers/tv_series_provider.dart';

class TVEpisodeDetailsPage extends ConsumerWidget {
  final int tvId;
  final int seasonNumber;
  final int episodeNumber;

  const TVEpisodeDetailsPage({
    super.key,
    required this.tvId,
    required this.seasonNumber,
    required this.episodeNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodeAsync = ref.watch(tvEpisodeDetailsProvider(
      tvId: tvId,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
    ));
    final seriesAsync = ref.watch(tvSeriesDetailsProvider(tvId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true),
      body: episodeAsync.when(
        data: (episode) => seriesAsync.when(
          data: (series) => _TVEpisodeDetailsContent(
            episode: episode,
            seriesId: tvId,
            seriesTitle: series.name,
            seriesPosterPath: series.posterPath,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => _TVEpisodeDetailsContent(
            episode: episode,
            seriesId: tvId,
            seriesTitle: 'Serie TV', // Fallback
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () => ref.invalidate(tvEpisodeDetailsProvider(
            tvId: tvId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
          )),
        ),
      ),
    );
  }
}

class _TVEpisodeDetailsContent extends StatelessWidget {
  final TVEpisode episode;
  final int seriesId;
  final String seriesTitle;
  final String? seriesPosterPath;

  const _TVEpisodeDetailsContent({
    required this.episode,
    required this.seriesId,
    required this.seriesTitle,
    this.seriesPosterPath,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Still Header
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      colors.background.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: episode.fullStillUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: colors.surface.withValues(alpha: 0.1)),
                  errorWidget: (context, url, error) => Container(
                    color: colors.surface.withValues(alpha: 0.1),
                    child: const Center(
                      child: Icon(Icons.tv_rounded, color: Colors.grey, size: 64),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: AppSpacing.lg,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'STAGIONE ${episode.seasonNumber} • EPISODIO ${episode.episodeNumber}',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      episode.name,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onSurfacePrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Stats Row
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                if (episode.voteAverage > 0) ...[
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    episode.voteAverage.toStringAsFixed(1),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                ],
                if (episode.runtime != null) ...[
                  Icon(Icons.timer_outlined, color: colors.onSurfaceSecondary, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${episode.runtime} min',
                    style: textTheme.titleSmall?.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                ],
                if (episode.airDate != null) ...[
                  Icon(Icons.calendar_today_rounded, color: colors.onSurfaceSecondary, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    episode.airDate!,
                    style: textTheme.titleSmall?.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Actions
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: WatchedEpisodeButton(
                    seriesId: seriesId,
                    seasonNumber: episode.seasonNumber,
                    episodeNumber: episode.episodeNumber,
                    seriesTitle: seriesTitle,
                    seriesPosterPath: seriesPosterPath,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Overview
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trama',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  episode.overview.isNotEmpty
                      ? episode.overview
                      : 'Nessuna descrizione disponibile per questo episodio.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
