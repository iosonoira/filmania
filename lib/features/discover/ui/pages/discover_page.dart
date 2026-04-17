import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../../../movies/ui/providers/movies_provider.dart';
import '../../../tv_series/ui/providers/tv_series_provider.dart';
import '../widgets/discover_widgets.dart';
import '../providers/discover_providers.dart';
import '../../../../core/widgets/error_view.dart';

class DiscoverPage extends ConsumerWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typingQuery = ref.watch(movieSearchQueryProvider);
    final query = ref.watch(debouncedSearchQueryProvider);
    final selectedMediaType = ref.watch(selectedMediaTypeProvider);
    final isDebouncing = typingQuery != query && typingQuery.isNotEmpty;
    final discoverAsync = _buildDiscoverAsync(ref, query, selectedMediaType);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top + AppSpacing.xl * 2,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                    onChanged: (value) {
                      ref.read(movieSearchQueryProvider.notifier).update(value);
                      ref
                          .read(debouncedSearchQueryProvider.notifier)
                          .update(value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          _DiscoverResultsSliver(
            discoverAsync: discoverAsync,
            selectedMediaType: selectedMediaType,
            query: query,
            ref: ref,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  AsyncValue<List<dynamic>> _buildDiscoverAsync(
    WidgetRef ref,
    String query,
    DiscoverMediaType selectedMediaType,
  ) {
    if (query.isEmpty) {
      return selectedMediaType == DiscoverMediaType.movie
          ? ref.watch(discoverMoviesProvider())
          : ref.watch(discoverTVSeriesProvider()).whenData((l) => l);
    }
    return selectedMediaType == DiscoverMediaType.movie
        ? ref.watch(searchMoviesProvider(query))
        : ref.watch(searchTVSeriesProvider(query)).whenData((l) => l);
  }
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
          'Discover',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            color: colors.onSurfacePrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MediaTypeButton(
                label: 'Film',
                isSelected: selectedMediaType == DiscoverMediaType.movie,
                onTap: onMovieSelected,
              ),
              _MediaTypeButton(
                label: 'Serie TV',
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
  });

  final DiscoverMediaType selectedMediaType;
  final ValueChanged<String> onChanged;
  final bool isDebouncing;

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
                          ? 'Cerca movie, attori, registi...'
                          : 'Cerca serie TV...',
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
                Icon(Icons.tune_rounded, color: colors.onSurfaceSecondary),
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

class _DiscoverResultsSliver extends StatelessWidget {
  const _DiscoverResultsSliver({
    required this.discoverAsync,
    required this.selectedMediaType,
    required this.query,
    required this.ref,
  });

  final AsyncValue<List<dynamic>> discoverAsync;
  final DiscoverMediaType selectedMediaType;
  final String query;
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
                    'Nessun risultato trovato',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSurfacePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Prova con parole chiave diverse.',
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
                return MediaGridCard.movie(
                  movie: item,
                  onTap: () {
                    context.push(
                      AppRoutes.movieDetails.replaceFirst(
                        ':id',
                        item.id.toString(),
                      ),
                    );
                  },
                );
              } else {
                return MediaGridCard.tv(
                  tv: item,
                  onTap: () {
                    context.push(
                      AppRoutes.tvDetails.replaceFirst(
                        ':id',
                        item.id.toString(),
                      ),
                    );
                  },
                );
              }
            }, childCount: items.length),
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SliverFillRemaining(
        hasScrollBody: false,
        child: AppErrorView(
          error: err,
          onRetry: () => query.isEmpty
              ? (selectedMediaType == DiscoverMediaType.movie
                    ? ref.invalidate(discoverMoviesProvider())
                    : ref.invalidate(discoverTVSeriesProvider()))
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
