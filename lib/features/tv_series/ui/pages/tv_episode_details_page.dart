import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import 'package:filmania/core/utils/logger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:filmania/core/widgets/error_view.dart';
import 'package:filmania/core/widgets/skeleton.dart';
import 'package:filmania/core/widgets/cast_section.dart';
import 'package:filmania/features/watched/ui/widgets/watched_episode_button.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_episode.dart';
import 'package:filmania/features/tv_series/ui/providers/tv_series_provider.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';

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
    final episodeAsync = ref.watch(
      tvEpisodeDetailsProvider(
        tvId: tvId,
        seasonNumber: seasonNumber,
        episodeNumber: episodeNumber,
      ),
    );
    final seriesAsync = ref.watch(tvSeriesDetailsProvider(tvId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true, minimal: true),
      body: episodeAsync.when(
        data: (episode) => seriesAsync.when(
          data: (series) => _TVEpisodeDetailsContent(
            episode: episode,
            seriesId: tvId,
            seriesTitle: series.name,
            seriesPosterPath: series.posterPath,
          ),
          loading: () => const _EpisodeDetailsSkeleton(),
          error: (err, stack) => _TVEpisodeDetailsContent(
            episode: episode,
            seriesId: tvId,
            seriesTitle: AppLocalizations.of(
              context,
            )!.tvSeriesTitle, // Fallback
          ),
        ),
        loading: () => const _EpisodeDetailsSkeleton(),
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () => ref.invalidate(
            tvEpisodeDetailsProvider(
              tvId: tvId,
              seasonNumber: seasonNumber,
              episodeNumber: episodeNumber,
            ),
          ),
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
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top),
        ),
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
                      child: Icon(
                        Icons.tv_rounded,
                        color: Colors.grey,
                        size: 64,
                      ),
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
                      '${AppLocalizations.of(context)!.season.toUpperCase()} ${episode.seasonNumber} • ${AppLocalizations.of(context)!.episode.toUpperCase()} ${episode.episodeNumber}',
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
                  Icon(
                    Icons.timer_outlined,
                    color: colors.onSurfaceSecondary,
                    size: 20,
                  ),
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
                  Icon(
                    Icons.calendar_today_rounded,
                    color: colors.onSurfaceSecondary,
                    size: 20,
                  ),
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
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            0,
          ),
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
                    runtimeMinutes: episode.runtime,
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
                  AppLocalizations.of(context)!.overviewTitle,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  episode.overview.isNotEmpty
                      ? episode.overview
                      : AppLocalizations.of(context)!.noDescription,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: _TVEpisodeCastSection(
            tvId: seriesId,
            seasonNumber: episode.seasonNumber,
            episodeNumber: episode.episodeNumber,
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

class _TVEpisodeCastSection extends ConsumerWidget {
  final int tvId;
  final int seasonNumber;
  final int episodeNumber;

  const _TVEpisodeCastSection({
    required this.tvId,
    required this.seasonNumber,
    required this.episodeNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsAsync = ref.watch(
      tvEpisodeCreditsProvider(
        tvId: tvId,
        seasonNumber: seasonNumber,
        episodeNumber: episodeNumber,
      ),
    );

    return creditsAsync.when(
      data: (cast) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: CastSection(cast: cast),
      ),
      loading: () => const CastRowSkeleton(),
      error: (err, stack) {
        AppLogger.error(
          'Cast load failed',
          tag: 'TVEpisodeCastSection',
          exception: err,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AppErrorView(
            error: err,
            compact: true,
            onRetry: () => ref.invalidate(
              tvEpisodeCreditsProvider(
                tvId: tvId,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Episode page skeleton: full-width still (300dp, no separate poster,
/// unlike movie/TV series details), a stats row, one full-width action
/// button, an overview block, and a cast row.
class _EpisodeDetailsSkeleton extends StatelessWidget {
  const _EpisodeDetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top),
        ),
        SliverToBoxAdapter(
          child: Skeleton(
            width: double.infinity,
            height: 300,
            borderRadius: BorderRadius.zero,
            gradient: false,
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(height: 16, width: 140),
                SizedBox(height: AppSpacing.sm),
                Skeleton(height: 26, width: 220),
                SizedBox(height: AppSpacing.lg),
                Skeleton(height: 20, width: 180),
                SizedBox(height: AppSpacing.lg),
                Skeleton(
                  height: 52,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                SizedBox(height: AppSpacing.lg),
                Skeleton(height: 20, width: 100),
                SizedBox(height: AppSpacing.md),
                Skeleton(height: 14, width: double.infinity),
                SizedBox(height: AppSpacing.xs),
                Skeleton(height: 14, width: 200),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 160,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) => Skeleton(
                width: 100,
                height: 100,
                shape: SkeletonShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
