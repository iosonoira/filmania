import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/ui/core/themes/app_colors.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/ui/core/ui/error_view.dart';
import 'package:filmania/ui/core/ui/glassmorphic_app_bar.dart';
import 'package:filmania/routing/app_router.dart';
import 'package:filmania/ui/core/ui/skeleton.dart';
import 'package:filmania/features/tv_series/ui/providers/tv_series_provider.dart';
import 'package:filmania/features/discover/ui/widgets/discover_widgets.dart';
import 'package:filmania/l10n/app_localizations_provider.dart';

class TrendingTVSeriesPage extends ConsumerWidget {
  const TrendingTVSeriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tvAsync = ref.watch(trendingTVSeriesProvider(page: 1));
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final l10n = ref.watch(appLocalizationsProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height:
                  MediaQuery.of(context).padding.top +
                  kToolbarHeight +
                  AppSpacing.xl,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Text(
                l10n.trendingTvTitle,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  color: colors.onSurfacePrimary,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
          tvAsync.when(
            data: (tvSeries) => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final tv = tvSeries[index];
                  return MediaGridCard.tv(
                    tv: tv,
                    onTap: () => context.push(
                      AppRoutes.tvDetails.replaceAll(':id', tv.id.toString()),
                    ),
                  );
                }, childCount: tvSeries.length),
              ),
            ),
            loading: () => const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: GridSliverSkeleton(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                itemCount: 6,
                spacing: AppSpacing.md,
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: AppErrorView(
                error: err,
                onRetry: () =>
                    ref.invalidate(trendingTVSeriesProvider(page: 1)),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}
