import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations_provider.dart';
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
    final isMovie = mediaType == MediaType.movie;

    if (isMovie) {
      return _buildMoviesScaffold(context, ref);
    } else {
      return _buildTvSeriesScaffold(context, ref);
    }
  }

  Widget _buildMoviesScaffold(BuildContext context, WidgetRef ref) {
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
                    if (!context.mounted) return;
                    handleBulkSelectionResult<MediaSelectionItem>(
                      context,
                      ref,
                      failureCount: failures,
                    );
                  },
                ),
                SelectionAction<MediaSelectionItem>(
                  icon: Icons.visibility_off_rounded,
                  label: l10n.markAsUnwatchedAction,
                  onPressed: (selected) async {
                    final confirmed = await showConfirmDialog(
                      context,
                      title: l10n.markUnwatchedConfirmTitle,
                      message: l10n.markUnwatchedConfirmMessage(
                        selected.length,
                      ),
                      confirmLabel: l10n.markAsUnwatchedAction,
                      cancelLabel: l10n.cancel,
                    );
                    if (!confirmed || !context.mounted) return;
                    final items = selected.toList();
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
                  },
                ),
              ],
            ),
            Expanded(
              child: asyncItems.when(
                data: (items) => _buildGrid(
                  context,
                  items,
                  colors,
                  textTheme,
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

  Widget _buildTvSeriesScaffold(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final asyncItems = ref.watch(categorizedTvSeriesProvider);
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
        body: SelectionScope<MediaSelectionItem>(
          child: _ClearSelectionOnTabChange(
            child: Column(
              children: [
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
                        if (!context.mounted) return;
                        handleBulkSelectionResult<MediaSelectionItem>(
                          context,
                          ref,
                          failureCount: failures,
                        );
                      },
                    ),
                    SelectionAction<MediaSelectionItem>(
                      icon: Icons.visibility_off_rounded,
                      label: l10n.markAsUnwatchedAction,
                      onPressed: (selected) async {
                        final confirmed = await showConfirmDialog(
                          context,
                          title: l10n.markUnwatchedConfirmTitle,
                          message: l10n.markUnwatchedConfirmMessage(
                            selected.length,
                          ),
                          confirmLabel: l10n.markAsUnwatchedAction,
                          cancelLabel: l10n.cancel,
                        );
                        if (!confirmed || !context.mounted) return;
                        final items = selected.toList();
                        final failures = await toggleWatchedBulk(
                          ref,
                          items: items,
                        );
                        if (!context.mounted) return;
                        handleBulkSelectionResult<MediaSelectionItem>(
                          context,
                          ref,
                          failureCount: failures,
                          onUndo: () async {
                            await toggleWatchedBulk(ref, items: items);
                          },
                        );
                      },
                    ),
                    SelectionAction<MediaSelectionItem>(
                      icon: Icons.stop_circle_outlined,
                      label: l10n.dropSeriesAction,
                      onPressed: (selected) async {
                        final confirmed = await showConfirmDialog(
                          context,
                          title: l10n.dropSeriesConfirmTitle,
                          message: l10n.dropSeriesConfirmMessage(
                            selected.length,
                          ),
                          confirmLabel: l10n.dropSeriesAction,
                          cancelLabel: l10n.cancel,
                        );
                        if (!confirmed || !context.mounted) return;
                        final items = selected.toList();
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
                            await markSeriesDroppedBulk(
                              ref,
                              items: items,
                              isDropped: false,
                            );
                          },
                        );
                      },
                    ),
                    SelectionAction<MediaSelectionItem>(
                      icon: Icons.watch_later_outlined,
                      label: l10n.watchLaterAction,
                      onPressed: (selected) async {
                        final failures = await markSeriesWatchLaterBulk(
                          ref,
                          items: selected.toList(),
                          isWatchLater: true,
                        );
                        if (!context.mounted) return;
                        handleBulkSelectionResult<MediaSelectionItem>(
                          context,
                          ref,
                          failureCount: failures,
                        );
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: asyncItems.when(
                    data: (items) {
                      final watching = items
                          .where(
                            (e) => e.status == TvSeriesWatchStatus.watching,
                          )
                          .map((e) => e.series)
                          .toList();
                      final upToDate = items
                          .where(
                            (e) => e.status == TvSeriesWatchStatus.upToDate,
                          )
                          .map((e) => e.series)
                          .toList();
                      final watchLater = items
                          .where(
                            (e) => e.status == TvSeriesWatchStatus.watchLater,
                          )
                          .map((e) => e.series)
                          .toList();
                      final completed = items
                          .where(
                            (e) => e.status == TvSeriesWatchStatus.completed,
                          )
                          .map((e) => e.series)
                          .toList();
                      final dropped = items
                          .where((e) => e.status == TvSeriesWatchStatus.dropped)
                          .map((e) => e.series)
                          .toList();

                      return TabBarView(
                        children: [
                          _buildGrid(
                            context,
                            watching,
                            colors,
                            textTheme,
                            emptyMessage: l10n.emptyWatching,
                          ),
                          _buildGrid(
                            context,
                            upToDate,
                            colors,
                            textTheme,
                            emptyMessage: l10n.emptyUpToDate,
                          ),
                          _buildGrid(
                            context,
                            watchLater,
                            colors,
                            textTheme,
                            emptyMessage: l10n.emptyWatchLater,
                          ),
                          _buildGrid(
                            context,
                            completed,
                            colors,
                            textTheme,
                            emptyMessage: l10n.emptyCompleted,
                          ),
                          _buildGrid(
                            context,
                            dropped,
                            colors,
                            textTheme,
                            emptyMessage: l10n.emptyDropped,
                          ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => AppErrorView(
                      error: err,
                      onRetry: () =>
                          ref.invalidate(categorizedTvSeriesProvider),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    List<WatchedItem> items,
    AppColorScheme colors,
    TextTheme textTheme, {
    required String emptyMessage,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            emptyMessage,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: colors.onSurfaceSecondary,
            ),
          ),
        ),
      );
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
          onTap: () {
            final path = item.mediaType == MediaType.movie
                ? AppRoutes.movieDetails.replaceAll(
                    ':id',
                    item.mediaId.toString(),
                  )
                : AppRoutes.tvDetails.replaceAll(
                    ':id',
                    item.mediaId.toString(),
                  );
            context.push(path);
          },
          child: _WatchedGridCard(item: item),
        );
      },
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
