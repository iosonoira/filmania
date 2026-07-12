import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum SkeletonShape { rect, circle }

/// Static tonal placeholder for loading states with a known, predictable
/// layout (grid cards, list rows, avatars, buttons). Consolidates three
/// near-identical hand-rolled placeholders that existed independently in
/// episodes, favorites, and watchlist. No shimmer sweep/animation by
/// design — matches DESIGN.md's quiet, No-Line aesthetic.
class Skeleton extends StatelessWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppSpacing.radius),
    ),
    this.shape = SkeletonShape.rect,
    this.gradient = true,
  });

  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final SkeletonShape shape;
  final bool gradient;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isCircle = shape == SkeletonShape.circle;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : borderRadius,
        color: gradient ? null : colors.surface.withValues(alpha: 0.15),
        gradient: gradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.surface.withValues(alpha: 0.05),
                  colors.surface.withValues(alpha: 0.15),
                  colors.surface.withValues(alpha: 0.05),
                ],
              )
            : null,
      ),
    );
  }
}

/// Full detail-page skeleton for the movie and TV series details pages,
/// which share the same backdrop (300dp) + overlapping poster (120x180)
/// hero layout, two full-width action-button rows, an overview block, and
/// a horizontal cast row of 100x100 avatar circles.
class MediaDetailsSkeleton extends StatelessWidget {
  const MediaDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top),
        ),
        const SliverToBoxAdapter(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Skeleton(
                width: double.infinity,
                height: 300,
                borderRadius: BorderRadius.zero,
                gradient: false,
              ),
              Positioned(
                bottom: -60,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Skeleton(
                      width: 120,
                      height: 180,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Skeleton(height: 22, width: 180),
                          SizedBox(height: AppSpacing.sm),
                          Skeleton(height: 16, width: 90),
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
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Skeleton(
                  height: 52,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                SizedBox(height: AppSpacing.md),
                Skeleton(
                  height: 52,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ],
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.all(AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(height: 20, width: 100),
                SizedBox(height: AppSpacing.md),
                Skeleton(height: 14, width: double.infinity),
                SizedBox(height: AppSpacing.xs),
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
              itemBuilder: (context, index) => const Skeleton(
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

/// Grid skeleton matching `_WatchedGrid`'s 3-column, 0.65-aspect-ratio
/// layout, used for both the Watched movies grid and the categorized TV
/// series tabs.
class WatchedGridSkeleton extends StatelessWidget {
  const WatchedGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: 9,
      itemBuilder: (context, index) => const Skeleton(),
    );
  }
}

/// Lightweight loading placeholder for a cast/crew row (matches
/// [CastSection]/[CrewSection]'s 160dp-tall horizontal list of 100x100
/// avatar circles), used while secondary detail-page sections load.
class CastRowSkeleton extends StatelessWidget {
  const CastRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) => const Skeleton(
          width: 100,
          height: 100,
          shape: SkeletonShape.circle,
        ),
      ),
    );
  }
}

/// Two-row loading placeholder for stacked cast + crew sections (matches
/// [CastSection] followed by [CrewSection], each a title label + 160dp
/// avatar row with [AppSpacing.lg] bottom padding). Use instead of a bare
/// [CastRowSkeleton] wherever both sections render together; [CastRowSkeleton]
/// alone remains correct where only cast is shown (e.g. the episode page).
class CastCrewSkeleton extends StatelessWidget {
  const CastCrewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.lg),
          child: _TitledRowSkeleton(),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.lg),
          child: _TitledRowSkeleton(),
        ),
      ],
    );
  }
}

class _TitledRowSkeleton extends StatelessWidget {
  const _TitledRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Skeleton(height: 20, width: 100),
        ),
        SizedBox(height: AppSpacing.md),
        CastRowSkeleton(),
      ],
    );
  }
}

/// Lightweight loading placeholder for a recommendations row (matches
/// [RecommendationsSection]'s 220dp-tall horizontal list of 140dp-wide
/// media cards), used while the recommendations section loads.
class RecommendationsRowSkeleton extends StatelessWidget {
  const RecommendationsRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) =>
            const Skeleton(width: 140, height: 200),
      ),
    );
  }
}
