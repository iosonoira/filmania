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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: asyncItems.when(
        data: (items) => _buildGrid(context, items, colors, textTheme, l10n),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(l10n.genericError(err.toString()))),
      ),
    );
  }

  Widget _buildTvSeriesScaffold(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final asyncItems = ref.watch(categorizedTvSeriesProvider);
    final l10n = ref.watch(appLocalizationsProvider);

    return DefaultTabController(
      length: 3,
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: TabBar(
            indicatorColor: colors.primary,
            dividerColor: Colors.transparent,
            labelColor: colors.onSurfacePrimary,
            unselectedLabelColor: colors.onSurfaceSecondary,
            tabs: [
              Tab(text: l10n.watching),
              Tab(text: l10n.upToDate),
              Tab(text: l10n.completed),
            ],
          ),
        ),
        body: asyncItems.when(
          data: (items) {
            final watching = items.where((e) => e.status == TvSeriesWatchStatus.watching).map((e) => e.series).toList();
            final upToDate = items.where((e) => e.status == TvSeriesWatchStatus.upToDate).map((e) => e.series).toList();
            final completed = items.where((e) => e.status == TvSeriesWatchStatus.completed).map((e) => e.series).toList();

            return TabBarView(
              children: [
                _buildGrid(context, watching, colors, textTheme, l10n),
                _buildGrid(context, upToDate, colors, textTheme, l10n),
                _buildGrid(context, completed, colors, textTheme, l10n),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text(l10n.genericError(err.toString()))),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<WatchedItem> items, AppColorScheme colors, TextTheme textTheme, AppLocalizations l10n) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          l10n.emptySection,
          style: textTheme.bodyLarge?.copyWith(color: colors.onSurfaceSecondary),
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
        return GestureDetector(
          onTap: () {
            final path = item.mediaType == MediaType.movie
                ? AppRoutes.movieDetails.replaceAll(':id', item.mediaId.toString())
                : AppRoutes.tvDetails.replaceAll(':id', item.mediaId.toString());
            context.push(path);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              boxShadow: Theme.of(context).brightness == Brightness.dark ? null : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              child: item.posterPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w200${item.posterPath}',
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: colors.surface,
                      child: Center(
                        child: Icon(Icons.movie, color: colors.onSurfaceSecondary),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
