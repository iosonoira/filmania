import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../../../../core/widgets/selection/media_selection_item.dart';
import '../../../../core/widgets/selection/selection_action_bar.dart';
import '../../../../core/widgets/selection/selection_scope.dart';
import '../../../watched/ui/widgets/watched_bulk_actions.dart';
import '../../../watchlist/ui/widgets/watchlist_picker_sheet.dart';
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
      body: SelectionScope<MediaSelectionItem>(
        child: Stack(
          children: [
            CustomScrollView(
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
                const SliverToBoxAdapter(child: TrendingMoviesSection()),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl),
                ),
                const TrendingTVSeriesSliver(),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl),
                ),
                const SliverToBoxAdapter(child: CuratedSection()),
                // Extra space for bottom nav bar so it's not overriding the last element
                const SliverToBoxAdapter(child: SizedBox(height: 140)),
              ],
            ),
            SelectionActionBar<MediaSelectionItem>(
              actions: [
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.bookmark_add_rounded,
                  label: 'Aggiungi a lista',
                  onPressed: (selected) => showBulkWatchlistPicker(
                    context,
                    ref,
                    items: selected.toList(),
                  ),
                ),
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.visibility_rounded,
                  label: 'Segna come visto/non visto',
                  onPressed: (selected) =>
                      toggleWatchedBulk(ref, items: selected.toList()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
