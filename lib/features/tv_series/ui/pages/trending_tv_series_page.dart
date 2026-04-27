import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/glassmorphic_app_bar.dart';
import '../../../../core/router/app_router.dart';
import '../providers/tv_series_provider.dart';
import '../../../discover/ui/widgets/discover_widgets.dart';

class TrendingTVSeriesPage extends ConsumerWidget {
  const TrendingTVSeriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tvAsync = ref.watch(trendingTVSeriesProvider(page: 1));
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight + AppSpacing.xl,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Serie TV del Momento',
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
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final tv = tvSeries[index];
                    return MediaGridCard.tv(
                      tv: tv,
                      onTap: () => context.push(
                        AppRoutes.tvDetails.replaceAll(':id', tv.id.toString()),
                      ),
                    );
                  },
                  childCount: tvSeries.length,
                ),
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: AppErrorView(
                error: err,
                onRetry: () => ref.invalidate(trendingTVSeriesProvider(page: 1)),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}
