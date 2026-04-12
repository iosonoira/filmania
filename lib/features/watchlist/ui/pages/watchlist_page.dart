import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../providers/watchlist_providers.dart';
import '../widgets/watchlist_widgets.dart';
import '../../../../core/widgets/error_view.dart';

class WatchlistPage extends ConsumerWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final watchlistAsync = ref.watch(userWatchlistProvider);

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
                    'Watchlist',
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      color: colors.onSurfacePrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Movies and shows you want to watch.',
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xxl),
          ),
          
          watchlistAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: WatchlistEmptyState(),
                  ),
                );
              }
              return SliverPadding(
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
                      final item = items[index];
                      return WatchlistMovieCard(
                        item: item,
                        onTap: () {
                          context.push(AppRoutes.movieDetails
                              .replaceFirst(':id', item.movieId.toString()));
                        },
                        onRemove: () => ref
                            .read(watchlistProvider.notifier)
                            .remove(item.movieId),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              );
            },
            loading: () => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const WatchlistShimmerCard(),
                  childCount: 6,
                ),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorView(
                error: err,
                onRetry: () => ref.invalidate(userWatchlistProvider),
              ),
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xxxl * 2 + AppSpacing.sm + AppSpacing.xs),
          ),
        ],
      ),
    );
  }
}

class WatchlistEmptyState extends StatelessWidget {
  const WatchlistEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return GlassOverlay(
      borderRadius: BorderRadius.circular(24),
      color: colors.onSurfacePrimary.withValues(alpha: 0.05),
      sigma: 10,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Icon(
              Icons.bookmark_outline_rounded,
              size: 64,
              color: colors.onSurfacePrimary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Your Watchlist is Empty',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Start adding movies and shows to keep track of what you want to watch!',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
