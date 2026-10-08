import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/ui/core/themes/app_colors.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/l10n/app_localizations_provider.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';
import 'package:filmania/data/repositories/watched/watched_providers.dart';
import 'package:filmania/features/watched/ui/providers/categorized_tv_series_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/routing/app_router.dart';
import 'package:filmania/domain/models/watched_item.dart';
import 'package:filmania/ui/core/ui/confirm_dialog.dart';
import 'package:filmania/ui/core/ui/error_view.dart';
import 'package:filmania/ui/core/ui/skeleton.dart';
import 'package:filmania/ui/core/ui/selection_action_feedback.dart';
import 'package:filmania/ui/core/ui/selection/media_selection_item.dart';
import 'package:filmania/ui/core/ui/selection/selectable_card.dart';
import 'package:filmania/ui/core/ui/selection/selection_action_bar.dart';
import 'package:filmania/ui/core/ui/selection/selection_scope.dart';
import 'package:filmania/features/watched/ui/widgets/watched_bulk_actions.dart';
import 'package:filmania/features/watchlist/ui/widgets/watchlist_picker_sheet.dart';

class WatchedListPage extends ConsumerWidget {
  final MediaType mediaType;

  const WatchedListPage({super.key, required this.mediaType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return mediaType == MediaType.movie
        ? _WatchedMoviesScaffold(mediaType: mediaType)
        : const _WatchedTvSeriesScaffold();
  }
}

class _WatchedMoviesScaffold extends ConsumerWidget {
  const _WatchedMoviesScaffold({required this.mediaType});

  final MediaType mediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final asyncItems = ref.watch(watchedItemsProvider(mediaType));
    final l10n = ref.watch(appLocalizationsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          l10n.watchedMovies,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onSurfacePrimary),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SelectionScope<MediaSelectionItem>(
        child: Column(
          children: [
            _WatchedMoviesActionBar(mediaType: mediaType),
            Expanded(
              child: asyncItems.when(
                data: (items) => _WatchedGrid(
                  items: items,
                  emptyMessage: l10n.emptyWatchedMovies,
                ),
                loading: () => const WatchedGridSkeleton(),
                error: (err, stack) => AppErrorView(
                  error: err,
                  onRetry: () =>
                      ref.invalidate(watchedItemsProvider(mediaType)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bulk-action bar for the movies grid. Handler bodies live as instance
/// methods (not private `Widget`-returning helpers) so `build()` stays a
/// thin declarative list — see `CLAUDE.md`'s 50-line/no-`_build*` rule.
class _WatchedMoviesActionBar extends ConsumerWidget {
  const _WatchedMoviesActionBar({required this.mediaType});

  final MediaType mediaType;

  Future<void> _handleAddToList(
    BuildContext context,
    WidgetRef ref,
    List<MediaSelectionItem> items,
  ) async {
    final failures = await showBulkWatchlistPicker(context, ref, items: items);
    if (!context.mounted) return;
    handleBulkSelectionResult<MediaSelectionItem>(
      context,
      ref,
      failureCount: failures,
    );
  }

  Future<void> _handleMarkUnwatched(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<MediaSelectionItem> items,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.markUnwatchedConfirmTitle,
      message: l10n.markUnwatchedConfirmMessage(items.length),
      confirmLabel: l10n.markAsUnwatchedAction,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed || !context.mounted) return;
    final failures = await toggleWatchedBulk(ref, items: items);
    if (!context.mounted) return;
    handleBulkSelectionResult<MediaSelectionItem>(
      context,
      ref,
      failureCount: failures,
      onUndo: () async {
        await toggleWatchedBulk(ref, items: items);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(appLocalizationsProvider);

    return SelectionActionBar<MediaSelectionItem>(
      closeTooltip: l10n.closeSelection,
      actions: [
        SelectionAction<MediaSelectionItem>(
          icon: Icons.bookmark_add_rounded,
          label: l10n.addToListAction,
          onPressed: (selected) =>
              _handleAddToList(context, ref, selected.toList()),
        ),
        SelectionAction<MediaSelectionItem>(
          icon: Icons.visibility_off_rounded,
          label: l10n.markAsUnwatchedAction,
          onPressed: (selected) =>
              _handleMarkUnwatched(context, ref, l10n, selected.toList()),
        ),
      ],
    );
  }
}

class _WatchedTvSeriesScaffold extends ConsumerWidget {
  const _WatchedTvSeriesScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final l10n = ref.watch(appLocalizationsProvider);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.background,
          elevation: 0,
          title: Text(
            l10n.watchedTvSeries,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.onSurfacePrimary),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: _ScrollHintTabBar(
            tabs: [
              Tab(text: l10n.watching),
              Tab(text: l10n.upToDate),
              Tab(text: l10n.watchLater),
              Tab(text: l10n.completed),
              Tab(text: l10n.dropped),
            ],
          ),
        ),
        body: const SelectionScope<MediaSelectionItem>(
          child: _ClearSelectionOnTabChange(
            child: Column(
              children: [
                _WatchedTvSeriesActionBar(),
                Expanded(child: _WatchedTvSeriesBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A scrollable [TabBar] gives no signal that swiping reveals more tabs —
/// with 5 categories and long localized labels, 2 can sit off-screen with
/// no visual hint they exist. Overlays edge fades that appear only while
/// there's unseen content in that direction (tracked via scroll metrics),
/// so the hint disappears once a user has scrolled all the way to an edge.
class _ScrollHintTabBar extends StatefulWidget implements PreferredSizeWidget {
  const _ScrollHintTabBar({required this.tabs});

  final List<Widget> tabs;

  @override
  Size get preferredSize => const TabBar(tabs: []).preferredSize;

  @override
  State<_ScrollHintTabBar> createState() => _ScrollHintTabBarState();
}

class _ScrollHintTabBarState extends State<_ScrollHintTabBar> {
  // Assume overflow until the first real scroll metrics arrive, since the
  // tabs are known to overflow on most locales/screen widths; this favors
  // showing the hint over silently hiding a real overflow on first frame.
  bool _canScrollForward = true;
  bool _canScrollBackward = false;

  bool _handleScrollMetrics(ScrollMetrics metrics) {
    final canForward = metrics.pixels < metrics.maxScrollExtent - 1;
    final canBackward = metrics.pixels > metrics.minScrollExtent + 1;
    if (canForward == _canScrollForward && canBackward == _canScrollBackward) {
      return false;
    }
    setState(() {
      _canScrollForward = canForward;
      _canScrollBackward = canBackward;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) =>
          _handleScrollMetrics(notification.metrics),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) =>
            _handleScrollMetrics(notification.metrics),
        child: Stack(
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: colors.primary,
              dividerColor: Colors.transparent,
              labelColor: colors.onSurfacePrimary,
              unselectedLabelColor: colors.onSurfaceSecondary,
              tabs: widget.tabs,
            ),
            if (_canScrollBackward)
              _TabEdgeFade(
                alignment: Alignment.centerLeft,
                color: colors.background,
              ),
            if (_canScrollForward)
              _TabEdgeFade(
                alignment: Alignment.centerRight,
                color: colors.background,
              ),
          ],
        ),
      ),
    );
  }
}

/// Directional gradient hinting that scrolling reveals more tabs. Ignores
/// touches so it never blocks the [TabBar] underneath.
class _TabEdgeFade extends StatelessWidget {
  const _TabEdgeFade({required this.alignment, required this.color});

  final Alignment alignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isLeading = alignment == Alignment.centerLeft;
    return Positioned(
      top: 0,
      bottom: 0,
      left: isLeading ? 0 : null,
      right: isLeading ? null : 0,
      child: IgnorePointer(
        child: Container(
          width: AppSpacing.xl,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: isLeading ? Alignment.centerLeft : Alignment.centerRight,
              end: isLeading ? Alignment.centerRight : Alignment.centerLeft,
              colors: [color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}

/// Bulk-action bar for the TV tabs. Handler bodies live as instance
/// methods (not private `Widget`-returning helpers) so `build()` stays a
/// thin declarative list — see `CLAUDE.md`'s 50-line/no-`_build*` rule.
class _WatchedTvSeriesActionBar extends ConsumerWidget {
  const _WatchedTvSeriesActionBar();

  Future<void> _handleAddToList(
    BuildContext context,
    WidgetRef ref,
    List<MediaSelectionItem> items,
  ) async {
    final failures = await showBulkWatchlistPicker(context, ref, items: items);
    if (!context.mounted) return;
    handleBulkSelectionResult<MediaSelectionItem>(
      context,
      ref,
      failureCount: failures,
    );
  }

  Future<void> _handleMarkUnwatched(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<MediaSelectionItem> items,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.markUnwatchedConfirmTitle,
      message: l10n.markUnwatchedConfirmMessage(items.length),
      confirmLabel: l10n.markAsUnwatchedAction,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed || !context.mounted) return;
    final failures = await toggleWatchedBulk(ref, items: items);
    if (!context.mounted) return;
    handleBulkSelectionResult<MediaSelectionItem>(
      context,
      ref,
      failureCount: failures,
      onUndo: () async {
        await toggleWatchedBulk(ref, items: items);
      },
    );
  }

  Future<void> _handleDropSeries(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<MediaSelectionItem> items,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.dropSeriesConfirmTitle,
      message: l10n.dropSeriesConfirmMessage(items.length),
      confirmLabel: l10n.dropSeriesAction,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed || !context.mounted) return;
    final failures = await markSeriesDroppedBulk(
      ref,
      items: items,
      isDropped: true,
    );
    if (!context.mounted) return;
    handleBulkSelectionResult<MediaSelectionItem>(
      context,
      ref,
      failureCount: failures,
      onUndo: () async {
        await markSeriesDroppedBulk(ref, items: items, isDropped: false);
      },
    );
  }

  Future<void> _handleWatchLater(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<MediaSelectionItem> items,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.watchLaterConfirmTitle,
      message: l10n.watchLaterConfirmMessage(items.length),
      confirmLabel: l10n.watchLaterAction,
      cancelLabel: l10n.cancel,
    );
    if (!confirmed || !context.mounted) return;
    final failures = await markSeriesWatchLaterBulk(
      ref,
      items: items,
      isWatchLater: true,
    );
    if (!context.mounted) return;
    handleBulkSelectionResult<MediaSelectionItem>(
      context,
      ref,
      failureCount: failures,
      onUndo: () async {
        await markSeriesWatchLaterBulk(ref, items: items, isWatchLater: false);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(appLocalizationsProvider);

    return SelectionActionBar<MediaSelectionItem>(
      closeTooltip: l10n.closeSelection,
      actions: [
        SelectionAction<MediaSelectionItem>(
          icon: Icons.bookmark_add_rounded,
          label: l10n.addToListAction,
          onPressed: (selected) =>
              _handleAddToList(context, ref, selected.toList()),
        ),
        SelectionAction<MediaSelectionItem>(
          icon: Icons.visibility_off_rounded,
          label: l10n.markAsUnwatchedAction,
          onPressed: (selected) =>
              _handleMarkUnwatched(context, ref, l10n, selected.toList()),
        ),
        SelectionAction<MediaSelectionItem>(
          icon: Icons.stop_circle_outlined,
          label: l10n.dropSeriesAction,
          onPressed: (selected) =>
              _handleDropSeries(context, ref, l10n, selected.toList()),
        ),
        SelectionAction<MediaSelectionItem>(
          icon: Icons.watch_later_outlined,
          label: l10n.watchLaterAction,
          onPressed: (selected) =>
              _handleWatchLater(context, ref, l10n, selected.toList()),
        ),
      ],
    );
  }
}

class _WatchedTvSeriesBody extends ConsumerWidget {
  const _WatchedTvSeriesBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(categorizedTvSeriesProvider);

    return asyncItems.when(
      data: (items) => _WatchedTvSeriesTabs(items: items),
      loading: () => const WatchedGridSkeleton(),
      error: (err, stack) => AppErrorView(
        error: err,
        onRetry: () => ref.invalidate(categorizedTvSeriesProvider),
      ),
    );
  }
}

class _WatchedTvSeriesTabs extends ConsumerWidget {
  const _WatchedTvSeriesTabs({required this.items});

  final List<CategorizedTvSeries> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(appLocalizationsProvider);

    final watching = items
        .where((e) => e.status == TvSeriesWatchStatus.watching)
        .map((e) => e.series)
        .toList();
    final upToDate = items
        .where((e) => e.status == TvSeriesWatchStatus.upToDate)
        .map((e) => e.series)
        .toList();
    final watchLater = items
        .where((e) => e.status == TvSeriesWatchStatus.watchLater)
        .map((e) => e.series)
        .toList();
    final completed = items
        .where((e) => e.status == TvSeriesWatchStatus.completed)
        .map((e) => e.series)
        .toList();
    final dropped = items
        .where((e) => e.status == TvSeriesWatchStatus.dropped)
        .map((e) => e.series)
        .toList();

    return TabBarView(
      children: [
        _WatchedGrid(items: watching, emptyMessage: l10n.emptyWatching),
        _WatchedGrid(items: upToDate, emptyMessage: l10n.emptyUpToDate),
        _WatchedGrid(items: watchLater, emptyMessage: l10n.emptyWatchLater),
        _WatchedGrid(items: completed, emptyMessage: l10n.emptyCompleted),
        _WatchedGrid(items: dropped, emptyMessage: l10n.emptyDropped),
      ],
    );
  }
}

class _WatchedGrid extends StatelessWidget {
  const _WatchedGrid({required this.items, required this.emptyMessage});

  final List<WatchedItem> items;
  final String emptyMessage;

  static String _detailsPath(WatchedItem item) {
    final route = item.mediaType == MediaType.movie
        ? AppRoutes.movieDetails
        : AppRoutes.tvDetails;
    return route.replaceAll(':id', item.mediaId.toString());
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return _WatchedGridEmpty(message: emptyMessage);
    }
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return SelectableCard<MediaSelectionItem>(
          id: MediaSelectionItem(
            mediaId: item.mediaId,
            mediaType: item.mediaType,
            title: item.mediaTitle,
            posterPath: item.posterPath,
          ),
          semanticLabel: item.mediaTitle,
          onTap: () => context.push(_detailsPath(item)),
          child: _WatchedGridCard(item: item),
        );
      },
    );
  }
}

class _WatchedGridEmpty extends StatelessWidget {
  const _WatchedGridEmpty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: colors.onSurfaceSecondary,
          ),
        ),
      ),
    );
  }
}

class _WatchedGridCard extends StatelessWidget {
  const _WatchedGridCard({required this.item});

  final WatchedItem item;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // DESIGN.md's Ambient Shadow spec: tinted (primary), 32-64px blur,
    // 4-8% opacity (dark) / 8-12% (light) — the prior flat black/8px
    // shadow matched neither the color nor the blur range.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: isDark ? 0.06 : 0.10),
            blurRadius: 40,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        clipBehavior: Clip.hardEdge,
        child: item.posterPath != null
            ? CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w200${item.posterPath}',
                fit: BoxFit.cover,
                memCacheWidth: 300,
                // Matches the grid's childAspectRatio (0.65) so the decoded
                // bitmap isn't larger than what's ever painted on screen.
                memCacheHeight: 462,
                placeholder: (context, url) => Container(color: colors.surface),
                errorWidget: (context, url, error) =>
                    _NoPosterFallback(title: item.mediaTitle),
              )
            : _NoPosterFallback(title: item.mediaTitle),
      ),
    );
  }
}

/// Shown in place of the poster art when there's none to fetch, or the
/// fetch failed — a title label keeps the card recognizable instead of
/// collapsing to an indistinguishable gray tile among other no-poster items.
class _NoPosterFallback extends StatelessWidget {
  const _NoPosterFallback({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      color: colors.surface,
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie, color: colors.onSurfaceSecondary),
          const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: colors.onSurfaceSecondary),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Clears the nearest `SelectionScope<MediaSelectionItem>` whenever the
/// enclosing `DefaultTabController` lands on a different tab. Selection is
/// otherwise shared across every tab in [TabBarView], so a user could build
/// a selection on one tab, swipe to another, and apply a bulk action to a
/// mixed set of items they can no longer see.
class _ClearSelectionOnTabChange extends StatefulWidget {
  const _ClearSelectionOnTabChange({required this.child});

  final Widget child;

  @override
  State<_ClearSelectionOnTabChange> createState() =>
      _ClearSelectionOnTabChangeState();
}

class _ClearSelectionOnTabChangeState
    extends State<_ClearSelectionOnTabChange> {
  TabController? _tabController;

  void _handleTabChange() {
    SelectionScope.controllerOf<MediaSelectionItem>(
      context,
      listen: false,
    ).clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = DefaultTabController.of(context);
    if (identical(controller, _tabController)) return;
    _tabController?.removeListener(_handleTabChange);
    _tabController = controller;
    _tabController!.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
