import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: GlassOverlay(
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
              ),
            ),
          ),
           const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xxl),
          ),
        ],
      ),
    );
  }
}
