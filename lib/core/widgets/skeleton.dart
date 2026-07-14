import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum SkeletonShape { rect, circle }

/// Animated pulse placeholder for loading states with a known, predictable
/// layout (grid cards, list rows, avatars, buttons). Consolidates three
/// near-identical hand-rolled placeholders that existed independently in
/// episodes, favorites, and watchlist. Includes a subtle breathing animation
/// — opacité oscillates from 0.5 to 1.0 over ~1.2 seconds.
class Skeleton extends StatefulWidget {
  Skeleton({
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
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isCircle = widget.shape == SkeletonShape.circle;

    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : widget.borderRadius,
          color: widget.gradient ? null : colors.surface.withValues(alpha: 0.15),
          gradient: widget.gradient
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
      ),
    );
  }
}

/// Person details page skeleton. Displays circular 160x160 profile image,
/// name + birthdate/place + biography text, filmography grid (2-col, 0.7 ratio).
/// Matches [_PersonDetailsContent] + [_PersonHeader] + [_PersonFilmographySection] layout.
class PersonDetailsSkeleton extends StatelessWidget {
  const PersonDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.top),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Skeleton(
                    width: 160,
                    height: 160,
                    shape: SkeletonShape.circle,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Skeleton(height: 28, width: 180),
                ),
                const SizedBox(height: AppSpacing.xs),
                Center(
                  child: Skeleton(height: 16, width: 220),
                ),
                const SizedBox(height: AppSpacing.lg),
                Skeleton(height: 24, width: 120),
                const SizedBox(height: AppSpacing.md),
                Column(
                  children: [
                    Skeleton(height: 16, width: double.infinity),
                    const SizedBox(height: AppSpacing.sm),
                    Skeleton(height: 16, width: double.infinity),
                    const SizedBox(height: AppSpacing.sm),
                    Skeleton(height: 16, width: 200),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                Skeleton(height: 24, width: 140),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => Skeleton(),
              childCount: 6,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),
      ],
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
        SliverToBoxAdapter(
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
        SliverPadding(
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
        SliverPadding(
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

/// Generic grid skeleton for loading states. Configurable columns, aspect
/// ratio, and item count for flex use across different grids (trending, watched,
/// categorized TV tabs).
class GridSkeleton extends StatelessWidget {
  const GridSkeleton({
    super.key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.65,
    this.itemCount = 9,
    this.spacing = AppSpacing.md,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  final int crossAxisCount;
  final double childAspectRatio;
  final int itemCount;
  final double spacing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => Skeleton(),
    );
  }
}

/// Sliver variant of [GridSkeleton] for use in CustomScrollView contexts.
/// Configurable for different grid layouts (trending pages, watched grids).
class GridSliverSkeleton extends StatelessWidget {
  const GridSliverSkeleton({
    super.key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.65,
    this.itemCount = 9,
    this.spacing = AppSpacing.md,
  });

  final int crossAxisCount;
  final double childAspectRatio;
  final int itemCount;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => Skeleton(),
        childCount: itemCount,
      ),
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
    return const GridSkeleton(
      crossAxisCount: 3,
      childAspectRatio: 0.65,
      itemCount: 9,
      spacing: AppSpacing.sm,
      padding: EdgeInsets.all(AppSpacing.md),
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
        itemBuilder: (context, index) => Skeleton(
          width: 100,
          height: 100,
          shape: SkeletonShape.circle,
        ),
      ),
    );
  }
}

/// Horizontal scrolling row skeleton for trending content (280dp tall).
/// Displays 4 card-like skeletons suitable for poster cards in a horizontal
/// list (e.g., trending movies carousel).
class TrendingRowSkeleton extends StatelessWidget {
  const TrendingRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, index) => SizedBox(
          width: 140,
          height: 280,
          child: Skeleton(),
        ),
      ),
    );
  }
}

/// List skeleton for upcoming episodes. Displays 4 rows matching the layout
/// of [_UpcomingEpisodeItem]: 50x75 poster + title + subtitle + rating row.
class UpcomingEpisodeListSkeleton extends StatelessWidget {
  const UpcomingEpisodeListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            Skeleton(width: 50, height: 75),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeleton(height: 18, width: double.infinity),
                  const SizedBox(height: AppSpacing.xs),
                  Skeleton(height: 14, width: 100),
                  const SizedBox(height: AppSpacing.xs),
                  Skeleton(height: 14, width: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Curated content section skeleton. Displays featured card (300dp),
/// optional secondary card, and a trending row. Matches [_CuratedContent] layout.
class CuratedContentSkeleton extends StatelessWidget {
  const CuratedContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Skeleton(height: 300, width: double.infinity),
        const SizedBox(height: AppSpacing.md),
        Skeleton(height: 200, width: double.infinity),
        const SizedBox(height: AppSpacing.md),
        Skeleton(height: 280, width: double.infinity),
      ],
    );
  }
}

/// Activity item row skeleton. Displays poster (50x75) + title/subtitle/date
/// layout matching [_ActivityItem]. Use in a Column for multiple items.
class ActivityRowSkeleton extends StatelessWidget {
  const ActivityRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.of(context).surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Row(
        children: [
          Skeleton(width: 50, height: 75),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(height: 18, width: double.infinity),
                const SizedBox(height: AppSpacing.xs),
                Skeleton(height: 14, width: 150),
                const SizedBox(height: AppSpacing.xs),
                Skeleton(height: 12, width: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Watchlist item list skeleton. Displays 2-3 rows of watchlist title
/// skeletons for use in a bottom sheet or list.
class WatchlistListSkeleton extends StatelessWidget {
  const WatchlistListSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Skeleton(height: 48, width: double.infinity),
        ),
      ),
    );
  }
}

/// Genre chip filter skeleton. Displays a wrap of 6 pill-shaped skeleton
/// items matching the width/height of [_GenreChip] elements.
class GenreChipsSkeleton extends StatelessWidget {
  const GenreChipsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.sm,
        children: List.generate(
          6,
          (index) => Skeleton(
            width: 80 + (index % 3) * 20,
            height: 36,
            borderRadius: BorderRadius.circular(24),
          ),
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
    return Column(
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
    return Column(
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
            Skeleton(width: 140, height: 200),
      ),
    );
  }
}
