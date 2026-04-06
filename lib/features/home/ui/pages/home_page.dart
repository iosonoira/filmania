import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/home_widgets.dart';

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
            child: SizedBox(height: MediaQuery.of(context).padding.top + AppSpacing.xl),
          ),
          const SliverToBoxAdapter(
            child: CurrentlyWatchingSection(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xxl),
          ),
          const SliverToBoxAdapter(
            child: UpcomingEpisodesSection(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xxl),
          ),
          const SliverToBoxAdapter(
            child: CuratedSection(),
          ),
          // Extra space for bottom nav bar so it's not overriding the last element
          const SliverToBoxAdapter(
            child: SizedBox(height: 140),
          ),
        ],
      ),
    );
  }
}
