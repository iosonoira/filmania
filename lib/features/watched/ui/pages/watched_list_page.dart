import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations_provider.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../providers/watched_providers.dart';
import '../providers/categorized_tv_series_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/watched_item.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/selection_action_feedback.dart';
import '../../../../core/widgets/selection/media_selection_item.dart';
import '../../../../core/widgets/selection/selectable_card.dart';
import '../../../../core/widgets/selection/selection_action_bar.dart';
import '../../../../core/widgets/selection/selection_scope.dart';
import '../widgets/watched_bulk_actions.dart';
import '../../../watchlist/ui/widgets/watchlist_picker_sheet.dart';

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
                loading: () => const Center(child: CircularProgressIndicator()),
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
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: colors.primary,
            dividerColor: Colors.transparent,
            labelColor: colors.onSurfacePrimary,
            unselectedLabelColor: colors.onSurfaceSecondary,
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
    List<MediaSelectionItem> items,
  ) async {
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
              _handleWatchLater(context, ref, selected.toList()),
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
      loading: () => const Center(child: CircularProgressIndicator()),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        boxShadow: Theme.of(context).brightness == Brightness.dark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
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
                errorWidget: (context, url, error) => Container(
                  color: colors.surface,
                  child: Center(
                    child: Icon(Icons.movie, color: colors.onSurfaceSecondary),
                  ),
                ),
              )
            : Container(
                color: colors.surface,
                child: Center(
                  child: Icon(Icons.movie, color: colors.onSurfaceSecondary),
                ),
              ),
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
