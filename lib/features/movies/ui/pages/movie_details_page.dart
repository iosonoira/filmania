import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import 'package:filmania/core/utils/logger.dart';
import '../../domain/entities/movie.dart';
import '../providers/movies_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../watchlist/ui/providers/watchlist_providers.dart';
import '../../../watchlist/ui/widgets/watchlist_picker_sheet.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../watched/ui/widgets/watched_button.dart';
import '../../../../core/widgets/cast_section.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';

class MovieDetailsPage extends ConsumerWidget {
  final int movieId;

  const MovieDetailsPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieAsync = ref.watch(movieDetailsProvider(movieId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true),
      body: movieAsync.when(
        data: (movie) => _MovieDetailsContent(movie: movie),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => AppErrorView(
          error: err,
          onRetry: () => ref.invalidate(movieDetailsProvider(movieId)),
        ),
      ),
    );
  }
}

class _MovieDetailsContent extends StatelessWidget {
  final Movie movie;

  const _MovieDetailsContent({required this.movie});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
        ),
        _MovieHeroHeader(movie: movie),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.xxxl + AppSpacing.md),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _WatchlistButton(movie: movie),
                const SizedBox(height: AppSpacing.md),
                WatchedButton(
                  mediaId: movie.id,
                  mediaTitle: movie.title,
                  mediaType: MediaType.movie,
                  posterPath: movie.posterPath,
                  runtimeMinutes: movie.runtime,
                  isIconOnly: false,
                ),
              ],
            ),
          ),
        ),
        _MovieOverviewSection(overview: movie.overview),
        SliverToBoxAdapter(
          child: _MovieCastSection(movieId: movie.id),
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

class _MovieHeroHeader extends StatelessWidget {
  final Movie movie;

  const _MovieHeroHeader({required this.movie});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return SliverToBoxAdapter(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Hero(
            tag: 'backdrop_${movie.id}',
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
                imageUrl: movie.fullBackdropUrl ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: colors.surface.withValues(alpha: 0.1)),
                errorWidget: (context, url, error) => Container(
                  color: colors.surface.withValues(alpha: 0.1),
                  child: const Center(
                    child: Icon(Icons.broken_image_rounded, color: Colors.grey),
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
                  tag: 'poster_${movie.id}',
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
                      imageUrl: movie.fullPosterUrl ?? '',
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
                        movie.title,
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
                            movie.voteAverage.toStringAsFixed(1),
                            style: textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colors.onSurfacePrimary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          if (movie.releaseDate != null)
                            Text(
                              movie.releaseDate!.year.toString(),
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
    );
  }
}

class _MovieOverviewSection extends StatelessWidget {
  const _MovieOverviewSection({required this.overview});

  final String overview;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.overviewTitle,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              overview.isNotEmpty ? overview : l10n.noDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchlistButton extends ConsumerWidget {
  final Movie movie;

  const _WatchlistButton({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final isInWatchlistAsync = ref.watch(
      isMediaInWatchlistProvider(movie.id, MediaType.movie),
    );
    final notifierState = ref.watch(watchlistProvider);
    final isLoading = notifierState.isLoading;

    return isInWatchlistAsync.when(
      data: (isIn) {
        if (isIn) {
          return OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () => showWatchlistPicker(
                      context,
                      ref,
                      mediaId: movie.id,
                      mediaTitle: movie.title,
                      mediaType: MediaType.movie,
                      posterPath: movie.posterPath,
                    ),
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bookmark_rounded),
            label: Text(AppLocalizations.of(context)!.inYourWatchlists),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
              foregroundColor: colors.primary,
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
                : () => showWatchlistPicker(
                      context,
                      ref,
                      mediaId: movie.id,
                      mediaTitle: movie.title,
                      mediaType: MediaType.movie,
                      posterPath: movie.posterPath,
                    ),
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
            label: Text(AppLocalizations.of(context)!.addToWatchlist),
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
class _MovieCastSection extends ConsumerWidget {
  final int movieId;

  const _MovieCastSection({required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditsAsync = ref.watch(movieCreditsProvider(movieId));

    return creditsAsync.when(
      data: (cast) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: CastSection(cast: cast),
      ),
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}
