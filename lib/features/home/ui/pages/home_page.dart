import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../../../../core/l10n/app_localizations_provider.dart';
import '../../../../core/widgets/selection_action_feedback.dart';
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
    final l10n = ref.watch(appLocalizationsProvider);
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
              closeTooltip: l10n.closeSelection,
              actions: [
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.bookmark_add_rounded,
                  label: l10n.addToListAction,
                  onPressed: (selected) async {
                    final failures = await showBulkWatchlistPicker(
                      context,
                      ref,
                      items: selected.toList(),
                    );
                    handleBulkSelectionResult<MediaSelectionItem>(
                      context,
                      ref,
                      failureCount: failures,
                    );
                  },
                ),
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.visibility_rounded,
                  label: l10n.toggleWatchedAction,
                  onPressed: (selected) async {
                    final failures = await toggleWatchedBulk(
                      ref,
                      items: selected.toList(),
                    );
                    handleBulkSelectionResult<MediaSelectionItem>(
                      context,
                      ref,
                      failureCount: failures,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
