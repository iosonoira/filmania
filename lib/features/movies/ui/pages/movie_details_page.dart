import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../../domain/entities/movie.dart';
import '../providers/movies_provider.dart';
import '../../../watchlist/ui/providers/watchlist_providers.dart';

class MovieDetailsPage extends ConsumerWidget {
  final int movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final movieAsync = ref.watch(movieDetailsProvider(movieId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(
        showBackButton: true,
      ),
      body: movieAsync.when(
        data: (movie) => _MovieDetailsContent(movie: movie),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: TextStyle(color: colors.error)),
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
                  child: Image.network(
                    movie.fullBackdropUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: AppSpacing.lg,
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
                        child: Image.network(movie.fullPosterUrl, fit: BoxFit.cover),
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
                              fontWeight: FontWeight.w900,
                              color: colors.onSurfacePrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
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
        ),
        
        const SliverToBoxAdapter(child: SizedBox(height: 80)),

        // Watchlist CTA
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: _WatchlistButton(movie: movie),
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
                  'Overview',
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  movie.overview,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceSecondary,
                    height: 1.5,
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

class _WatchlistButton extends ConsumerWidget {
  final Movie movie;

  const _WatchlistButton({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final isInWatchlistAsync = ref.watch(isMovieInWatchlistProvider(movie.id));
    final notifierState = ref.watch(watchlistProvider);

    return isInWatchlistAsync.when(
      data: (isIn) {
        final isLoading = notifierState.isLoading;
        
        if (isIn) {
          return OutlinedButton.icon(
            onPressed: isLoading ? null : () => ref.read(watchlistProvider.notifier).toggle(movie),
            icon: isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.bookmark_remove_rounded, color: Colors.redAccent),
            label: const Text('Rimuovi dalla Watchlist'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.redAccent),
              foregroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            onPressed: isLoading ? null : () => ref.read(watchlistProvider.notifier).toggle(movie),
            icon: isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.bookmark_add_rounded, color: Colors.white),
            label: const Text('Aggiungi alla Watchlist'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const SizedBox(),
    );
  }
}
