import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import 'package:filmania/core/utils/logger.dart';
import '../../domain/entities/tv_series.dart';
import '../providers/tv_series_provider.dart';
import '../widgets/tv_series_widgets.dart';
import '../../../watchlist/ui/providers/watchlist_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/error_view.dart';

class TVSeriesDetailsPage extends ConsumerWidget {
  final int seriesId;

  const TVSeriesDetailsPage({super.key, required this.seriesId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(tvSeriesDetailsProvider(seriesId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true),
      body: seriesAsync.when(
        data: (series) => _TVSeriesDetailsContent(series: series),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () => ref.invalidate(tvSeriesDetailsProvider(seriesId)),
        ),
      ),
    );
  }
}

class _TVSeriesDetailsContent extends StatelessWidget {
  final TVSeries series;

  const _TVSeriesDetailsContent({required this.series});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Backdrop & Poster Header
        SliverToBoxAdapter(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Hero(
                tag: 'backdrop_${series.id}',
                child: Container(
                  height: 300,
                  width: double.infinity,
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        colors.surface.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: series.fullBackdropUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: colors.surface.withValues(alpha: 0.1)),
                    errorWidget: (context, url, error) => Container(
                      color: colors.surface.withValues(alpha: 0.1),
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Hero(
                      tag: 'poster_${series.id}',
                      child: Container(
                        height: 180,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                          imageUrl: series.fullPosterUrl ?? '',
                          fit: BoxFit.cover,
                          memCacheWidth: 300,
                          placeholder: (context, url) => Container(
                            color: colors.surface.withValues(alpha: 0.1),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: colors.surface.withValues(alpha: 0.1),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            series.name,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.onSurfacePrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                series.voteAverage.toStringAsFixed(1),
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurfacePrimary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              if (series.firstAirDate != null)
                                Text(
                                  series.firstAirDate!.year.toString(),
                                  style: textTheme.labelLarge?.copyWith(
                                    color: colors.onSurfaceSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.xxxl + AppSpacing.md),
        ),

        // Watchlist CTA
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverToBoxAdapter(child: _WatchlistButton(series: series)),
        ),

        // Overview
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overview',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  series.overview,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Separatore
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

        // Sezione episodi
        SliverToBoxAdapter(
          child: EpisodesSection(tvId: series.id, seasons: series.seasons),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(
            height: AppSpacing.xxxl + AppSpacing.xl + AppSpacing.xs,
          ),
        ),
      ],
    );
  }
}

class _WatchlistButton extends ConsumerWidget {
  final TVSeries series;

  const _WatchlistButton({required this.series});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final isInWatchlistAsync = ref.watch(
      isMediaInWatchlistProvider(series.id, MediaType.tv),
    );
    final notifierState = ref.watch(watchlistProvider);

    return isInWatchlistAsync.when(
      data: (isIn) {
        final isLoading = notifierState.isLoading;

        if (isIn) {
          return OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () => ref
                      .read(watchlistProvider.notifier)
                      .toggleTVSeries(series),
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.bookmark_remove_rounded,
                    color: Colors.redAccent,
                  ),
            label: const Text('Rimuovi dalla Watchlist'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.redAccent),
              foregroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: colors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: isLoading
                ? null
                : () => ref
                      .read(watchlistProvider.notifier)
                      .toggleTVSeries(series),
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.bookmark_add_rounded, color: Colors.white),
            label: const Text('Aggiungi alla Watchlist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) {
        AppLogger.error(
          'Watchlist status load failed',
          tag: 'WatchlistButton',
          exception: error,
        );
        return Center(
          child: Text(
            'Error loading watchlist status',
            style: TextStyle(color: colors.error, fontSize: 12),
          ),
        );
      },
    );
  }
}
