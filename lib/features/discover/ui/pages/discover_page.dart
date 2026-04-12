import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../../../movies/ui/providers/movies_provider.dart';
import '../widgets/discover_widgets.dart';
import '../providers/discover_providers.dart';

class DiscoverPage extends ConsumerWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    
    final query = ref.watch(movieSearchQueryProvider);
    final discoverAsync = query.isEmpty 
        ? ref.watch(discoverMoviesProvider())
        : ref.watch(searchMoviesProvider(query));

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.top + AppSpacing.xl * 2),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover',
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      color: colors.onSurfacePrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GlassOverlay(
                    sigma: 12,
                    color: colors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppSpacing.xl),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            color: colors.primary.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: TextField(
                              onChanged: (value) => 
                                  ref.read(movieSearchQueryProvider.notifier).update(value),
                              style: textTheme.bodyLarge?.copyWith(
                                color: colors.onSurfacePrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search for movies, actors, directors...',
                                hintStyle: textTheme.bodyLarge?.copyWith(
                                  color: colors.onSurfaceSecondary,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Icon(
                            Icons.tune_rounded,
                            color: colors.onSurfaceSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xxl),
          ),
          
          discoverAsync.when(
            data: (movies) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final movie = movies[index];
                    return MovieGridCard(
                      movie: movie,
                      onTap: () {
                        context.push(AppRoutes.movieDetails.replaceFirst(':id', movie.id.toString()));
                      },
                    );
                  },
                  childCount: movies.length,
                ),
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Error loading movies: $err',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(color: colors.error),
                ),
              ),
            ),
          ),
          
          // Bottom padding for the navigation bar
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }
}
