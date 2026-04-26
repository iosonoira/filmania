import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
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

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          'Film Visti',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.onSurfacePrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: asyncItems.when(
        data: (items) => _buildGrid(context, items, colors, textTheme),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
      ),
    );
  }

  Widget _buildTvSeriesScaffold(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final asyncItems = ref.watch(categorizedTvSeriesProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.background,
          elevation: 0,
          title: Text(
            'Serie TV Viste',
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
            tabs: const [
              Tab(text: 'In visione'),
              Tab(text: 'In pari'),
              Tab(text: 'Terminate'),
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
                _buildGrid(context, watching, colors, textTheme),
                _buildGrid(context, upToDate, colors, textTheme),
                _buildGrid(context, completed, colors, textTheme),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Errore: $err')),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<WatchedItem> items, AppColorScheme colors, TextTheme textTheme) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Nessun elemento presente in questa sezione.',
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
        );
      },
    );
  }
}
