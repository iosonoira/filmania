import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/ui/widgets/home_widgets.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

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
                    'Discover',
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      color: colors.onSurfacePrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: colors.onSurfacePrimary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colors.onSurfacePrimary.withValues(alpha: 0.1),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: colors.onSurfaceSecondary),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Search movies, actors, genres...',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colors.onSurfaceSecondary,
                          ),
                        ),
                      ],
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
                color: colors.primary.withValues(alpha: 0.05),
                sigma: 10,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      Icon(
                        Icons.explore_off_outlined,
                        size: 64,
                        color: colors.primary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Exploration Coming Soon',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'We are Curating the best content just for you.',
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
        ],
      ),
    );
  }
}
