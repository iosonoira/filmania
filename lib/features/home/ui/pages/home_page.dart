import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../widgets/home_widgets.dart';

// Pattern for future AsyncValue sections:
// sectionAsync.when(
//   data: (data) => SectionWidget(data: data),
//   loading: () => const SectionShimmer(),
//   error: (err, stack) => AppErrorView(error: err, compact: true, onRetry: () => ref.invalidate(provider)),
// )

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight + AppSpacing.xl,
            ),
          ),
          const SliverToBoxAdapter(child: TrendingMoviesSection()),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          const TrendingTVSeriesSliver(),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          const SliverToBoxAdapter(child: CuratedSection()),
          // Extra space for bottom nav bar so it's not overriding the last element
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
    );
  }
}
