import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/routing/app_router.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/ui/core/themes/app_colors.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/ui/core/ui/glass_overlay.dart';
import 'package:filmania/ui/core/ui/glassmorphic_app_bar.dart';
import 'package:filmania/ui/core/ui/skeleton.dart';
import 'package:filmania/features/movies/ui/providers/movies_provider.dart';
import 'package:filmania/features/tv_series/ui/providers/tv_series_provider.dart';
import 'package:filmania/features/discover/ui/widgets/discover_widgets.dart';
import 'package:filmania/features/discover/ui/providers/discover_providers.dart';
import 'package:filmania/ui/core/ui/error_view.dart';
import 'package:filmania/ui/core/ui/selection_action_feedback.dart';
import 'package:filmania/ui/core/ui/selection/media_selection_item.dart';
import 'package:filmania/ui/core/ui/selection/selectable_card.dart';
import 'package:filmania/ui/core/ui/selection/selection_action_bar.dart';
import 'package:filmania/ui/core/ui/selection/selection_scope.dart';
import 'package:filmania/l10n/app_localizations_provider.dart';
import 'package:filmania/features/watched/ui/widgets/watched_bulk_actions.dart';
import 'package:filmania/features/watchlist/ui/widgets/watchlist_picker_sheet.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';

class DiscoverPage extends ConsumerWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typingQuery = ref.watch(movieSearchQueryProvider);
    final query = ref.watch(debouncedSearchQueryProvider);
    final selectedMediaType = ref.watch(selectedMediaTypeProvider);
    final movieFilters = ref.watch(movieDiscoverFiltersProvider);
    final tvFilters = ref.watch(tvDiscoverFiltersProvider);
    final activeFilters = selectedMediaType == DiscoverMediaType.movie
        ? movieFilters
        : tvFilters;
    final isDebouncing = typingQuery != query && typingQuery.isNotEmpty;
    final discoverAsync = _buildDiscoverAsync(
      ref,
      query,
      selectedMediaType,
      activeFilters,
    );
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
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DiscoverHeader(
                          selectedMediaType: selectedMediaType,
                          onMovieSelected: () => ref
                              .read(selectedMediaTypeProvider.notifier)
                              .set(DiscoverMediaType.movie),
                          onTvSelected: () => ref
                              .read(selectedMediaTypeProvider.notifier)
                              .set(DiscoverMediaType.tv),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _DiscoverSearchBar(
                          selectedMediaType: selectedMediaType,
                          isDebouncing: isDebouncing,
                          isFiltersActive: activeFilters.isActive,
                          onFiltersTap: () =>
                              _showFiltersSheet(context, selectedMediaType),
                          onChanged: (value) {
                            ref
                                .read(movieSearchQueryProvider.notifier)
                                .update(value);
                            ref
                                .read(debouncedSearchQueryProvider.notifier)
                                .update(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxl),
                ),
                _DiscoverResultsSliver(
                  discoverAsync: discoverAsync,
                  selectedMediaType: selectedMediaType,
                  query: query,
                  filters: activeFilters,
                  ref: ref,
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
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
                    if (!context.mounted) return;
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
          ],
        ),
      ),
    );
  }

  AsyncValue<List<dynamic>> _buildDiscoverAsync(
    WidgetRef ref,
    String query,
    DiscoverMediaType selectedMediaType,
    DiscoverFilters filters,
  ) {
    if (query.isEmpty) {
      return selectedMediaType == DiscoverMediaType.movie
          ? ref.watch(
              discoverMoviesProvider(
                genreIds: filters.genreIdsKey,
                yearFrom: filters.yearFrom,
                yearTo: filters.yearTo,
              ),
            )
          : ref
                .watch(
                  discoverTVSeriesProvider(
                    genreIds: filters.genreIdsKey,
                    yearFrom: filters.yearFrom,
                    yearTo: filters.yearTo,
                  ),
                )
                .whenData((l) => l);
    }
    return selectedMediaType == DiscoverMediaType.movie
        ? ref.watch(searchMoviesProvider(query))
        : ref.watch(searchTVSeriesProvider(query)).whenData((l) => l);
  }
}

void _showFiltersSheet(
  BuildContext context,
  DiscoverMediaType selectedMediaType,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) =>
        _FiltersSheetContent(selectedMediaType: selectedMediaType),
  );
}

class _DiscoverHeader extends StatelessWidget {
  const _DiscoverHeader({
    required this.selectedMediaType,
    required this.onMovieSelected,
    required this.onTvSelected,
  });

  final DiscoverMediaType selectedMediaType;
  final VoidCallback onMovieSelected;
  final VoidCallback onTvSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.navDiscover,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            color: colors.onSurfacePrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? colors.surface.withValues(alpha: 0.5)
                : colors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            boxShadow: Theme.of(context).brightness == Brightness.dark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MediaTypeButton(
                label: AppLocalizations.of(context)!.moviesTitle,
                isSelected: selectedMediaType == DiscoverMediaType.movie,
                onTap: onMovieSelected,
              ),
              _MediaTypeButton(
                label: AppLocalizations.of(context)!.tvSeriesTitle,
                isSelected: selectedMediaType == DiscoverMediaType.tv,
                onTap: onTvSelected,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DiscoverSearchBar extends StatelessWidget {
  const _DiscoverSearchBar({
    required this.selectedMediaType,
    required this.onChanged,
    required this.isDebouncing,
    required this.isFiltersActive,
    required this.onFiltersTap,
  });

  final DiscoverMediaType selectedMediaType;
  final ValueChanged<String> onChanged;
  final bool isDebouncing;
  final bool isFiltersActive;
  final VoidCallback onFiltersTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        GlassOverlay(
          sigma: 12,
          color: colors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppSpacing.xl),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: colors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    onChanged: onChanged,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfacePrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: selectedMediaType == DiscoverMediaType.movie
                          ? AppLocalizations.of(context)!.searchMoviesHint
                          : AppLocalizations.of(context)!.searchTvHint,
                      hintStyle: textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceSecondary,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _FiltersButton(isActive: isFiltersActive, onTap: onFiltersTap),
              ],
            ),
          ),
        ),
        if (isDebouncing) ...[
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              backgroundColor: colors.primary.withValues(alpha: 0.1),
              color: colors.primary,
              minHeight: 2,
            ),
          ),
        ],
      ],
    );
  }
}

class _FiltersButton extends StatelessWidget {
  const _FiltersButton({required this.isActive, required this.onTap});

  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Semantics(
      label: AppLocalizations.of(context)!.filtersTitle,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.tune_rounded, color: colors.onSurfaceSecondary),
            if (isActive)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FiltersSheetContent extends StatelessWidget {
  const _FiltersSheetContent({required this.selectedMediaType});

  final DiscoverMediaType selectedMediaType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.of(context).background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radius),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FiltersSheetHeader(selectedMediaType: selectedMediaType),
            const SizedBox(height: AppSpacing.lg),
            _GenreFilterSection(selectedMediaType: selectedMediaType),
            const SizedBox(height: AppSpacing.xl),
            _YearRangeFilterSection(selectedMediaType: selectedMediaType),
          ],
        ),
      ),
    );
  }
}

class _FiltersSheetHeader extends ConsumerWidget {
  const _FiltersSheetHeader({required this.selectedMediaType});

  final DiscoverMediaType selectedMediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final isMovie = selectedMediaType == DiscoverMediaType.movie;
    final filters = isMovie
        ? ref.watch(movieDiscoverFiltersProvider)
        : ref.watch(tvDiscoverFiltersProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.filtersTitle,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (filters.isActive)
          TextButton(
            onPressed: () => isMovie
                ? ref.read(movieDiscoverFiltersProvider.notifier).clear()
                : ref.read(tvDiscoverFiltersProvider.notifier).clear(),
            child: Text(
              AppLocalizations.of(context)!.clearFilters,
              style: TextStyle(color: colors.error),
            ),
          ),
      ],
    );
  }
}

class _GenreFilterSection extends ConsumerWidget {
  const _GenreFilterSection({required this.selectedMediaType});

  final DiscoverMediaType selectedMediaType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final isMovie = selectedMediaType == DiscoverMediaType.movie;
    final genresAsync = isMovie
        ? ref.watch(movieGenresProvider)
        : ref.watch(tvGenresProvider);
    final filters = isMovie
        ? ref.watch(movieDiscoverFiltersProvider)
        : ref.watch(tvDiscoverFiltersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.genreLabel.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(
            color: colors.onSurfaceSecondary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        genresAsync.when(
          data: (genres) => Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: genres
                .map(
                  (genre) => _GenreChip(
                    label: genre.name,
                    isSelected: filters.genreIds.contains(genre.id),
                    onTap: () => isMovie
                        ? ref
                              .read(movieDiscoverFiltersProvider.notifier)
                              .toggleGenre(genre.id)
                        : ref
                              .read(tvDiscoverFiltersProvider.notifier)
                              .toggleGenre(genre.id),
                  ),
                )
                .toList(),
          ),
          loading: () => const GenreChipsSkeleton(),
          error: (e, st) => Text(
            AppLocalizations.of(context)!.genresLoadError,
            style: TextStyle(color: colors.error),
          ),
        ),
      ],
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary
                : colors.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected ? Colors.white : colors.onSurfaceSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _YearRangeFilterSection extends ConsumerStatefulWidget {
  const _YearRangeFilterSection({required this.selectedMediaType});

  final DiscoverMediaType selectedMediaType;

  @override
  ConsumerState<_YearRangeFilterSection> createState() =>
      _YearRangeFilterSectionState();
}

class _YearRangeFilterSectionState
    extends ConsumerState<_YearRangeFilterSection> {
  static const int _minYear = 1950;
  static final int _maxYear = DateTime.now().year;

  late RangeValues _values;

  @override
  void initState() {
    super.initState();
    final filters = widget.selectedMediaType == DiscoverMediaType.movie
        ? ref.read(movieDiscoverFiltersProvider)
        : ref.read(tvDiscoverFiltersProvider);
    _values = RangeValues(
      (filters.yearFrom ?? _minYear).toDouble(),
      (filters.yearTo ?? _maxYear).toDouble(),
    );
  }

  void _commit(RangeValues values) {
    final from = values.start.round();
    final to = values.end.round();
    final resolvedFrom = from == _minYear ? null : from;
    final resolvedTo = to == _maxYear ? null : to;
    if (widget.selectedMediaType == DiscoverMediaType.movie) {
      ref
          .read(movieDiscoverFiltersProvider.notifier)
          .setYearRange(resolvedFrom, resolvedTo);
    } else {
      ref
          .read(tvDiscoverFiltersProvider.notifier)
          .setYearRange(resolvedFrom, resolvedTo);
    }
  }

  int? get _fromOfValues =>
      _values.start.round() == _minYear ? null : _values.start.round();

  int? get _toOfValues =>
      _values.end.round() == _maxYear ? null : _values.end.round();

  /// Resyncs the local slider state whenever the provider's year range
  /// changes from outside this widget (e.g. the "Cancella filtri" button),
  /// so the slider doesn't visually desync from the actual active filter.
  void _onFiltersChanged(DiscoverFilters? previous, DiscoverFilters next) {
    if (!mounted) return;
    if (next.yearFrom == _fromOfValues && next.yearTo == _toOfValues) return;
    setState(() {
      _values = RangeValues(
        (next.yearFrom ?? _minYear).toDouble(),
        (next.yearTo ?? _maxYear).toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    if (widget.selectedMediaType == DiscoverMediaType.movie) {
      ref.listen(movieDiscoverFiltersProvider, _onFiltersChanged);
    } else {
      ref.listen(tvDiscoverFiltersProvider, _onFiltersChanged);
    }
    final isDefaultRange =
        _values.start.round() == _minYear && _values.end.round() == _maxYear;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.releaseYearLabel.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(
            color: colors.onSurfaceSecondary,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          isDefaultRange
              ? AppLocalizations.of(context)!.anyPeriod
              : '${_values.start.round()} – ${_values.end.round()}',
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfacePrimary),
        ),
        RangeSlider(
          min: _minYear.toDouble(),
          max: _maxYear.toDouble(),
          divisions: _maxYear - _minYear,
          values: _values,
          activeColor: colors.primary,
          onChanged: (values) => setState(() => _values = values),
          onChangeEnd: _commit,
        ),
      ],
    );
  }
}

class _DiscoverResultsSliver extends StatelessWidget {
  const _DiscoverResultsSliver({
    required this.discoverAsync,
    required this.selectedMediaType,
    required this.query,
    required this.filters,
    required this.ref,
  });

  final AsyncValue<List<dynamic>> discoverAsync;
  final DiscoverMediaType selectedMediaType;
  final String query;
  final DiscoverFilters filters;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return discoverAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 64,
                    color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppLocalizations.of(context)!.noResultsTitle,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSurfacePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppLocalizations.of(context)!.noResultsHint,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = items[index];
              if (selectedMediaType == DiscoverMediaType.movie) {
                final selectionId = MediaSelectionItem(
                  mediaId: item.id,
                  mediaType: MediaType.movie,
                  title: item.title,
                  posterPath: item.posterPath,
                );
                return SelectableCard<MediaSelectionItem>(
                  id: selectionId,
                  onTap: () => context.push(
                    AppRoutes.movieDetails.replaceFirst(
                      ':id',
                      item.id.toString(),
                    ),
                  ),
                  child: MediaGridCard.movie(movie: item),
                );
              } else {
                final selectionId = MediaSelectionItem(
                  mediaId: item.id,
                  mediaType: MediaType.tv,
                  title: item.name,
                  posterPath: item.posterPath,
                );
                return SelectableCard<MediaSelectionItem>(
                  id: selectionId,
                  onTap: () => context.push(
                    AppRoutes.tvDetails.replaceFirst(':id', item.id.toString()),
                  ),
                  child: MediaGridCard.tv(tv: item),
                );
              }
            }, childCount: items.length),
          ),
        );
      },
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
        hasScrollBody: false,
        child: AppErrorView(
          error: err,
          onRetry: () => query.isEmpty
              ? (selectedMediaType == DiscoverMediaType.movie
                    ? ref.invalidate(
                        discoverMoviesProvider(
                          genreIds: filters.genreIdsKey,
                          yearFrom: filters.yearFrom,
                          yearTo: filters.yearTo,
                        ),
                      )
                    : ref.invalidate(
                        discoverTVSeriesProvider(
                          genreIds: filters.genreIdsKey,
                          yearFrom: filters.yearFrom,
                          yearTo: filters.yearTo,
                        ),
                      ))
              : (selectedMediaType == DiscoverMediaType.movie
                    ? ref.invalidate(searchMoviesProvider(query))
                    : ref.invalidate(searchTVSeriesProvider(query))),
        ),
      ),
    );
  }
}

class _MediaTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MediaTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            style: textTheme.labelLarge?.copyWith(
              color: isSelected ? Colors.white : colors.onSurfaceSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
