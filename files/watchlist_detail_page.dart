import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../providers/watchlist_providers.dart';
import '../widgets/watchlist_widgets.dart';
import '../../../../core/widgets/error_view.dart';

class WatchlistDetailPage extends ConsumerWidget {
  final String watchlistId;

  const WatchlistDetailPage({super.key, required this.watchlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final watchlistsAsync = ref.watch(userWatchlistsProvider);
    final itemsAsync = ref.watch(watchlistItemsProvider(watchlistId));

    final watchlistName = watchlistsAsync.value
            ?.where((w) => w.id == watchlistId)
            .map((w) => w.name)
            .firstOrNull ??
        '…';

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top + AppSpacing.xl * 2,
            ),
          ),

          // Header row with title + delete button
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          watchlistName,
                          style: textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.5,
                            color: colors.onSurfacePrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        itemsAsync.when(
                          data: (items) => Text(
                            '${items.length} titoli',
                            style: textTheme.labelLarge?.copyWith(
                              color: colors.onSurfaceSecondary,
                            ),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (err, stack) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  // Delete button
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: colors.onSurfaceSecondary,
                    ),
                    onPressed: () =>
                        _confirmDelete(context, ref, watchlistName),
                    tooltip: 'Elimina lista',
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

          itemsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    child: _WatchlistDetailEmpty(
                        colors: colors, textTheme: textTheme),
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
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = items[index];
                      return WatchlistMediaCard(
                        item: item,
                        onTap: () {
                          if (item.mediaType == MediaType.movie) {
                            context.push(
                              AppRoutes.movieDetails.replaceFirst(
                                  ':id', item.mediaId.toString()),
                            );
                          } else {
                            context.push(
                              AppRoutes.tvDetails.replaceFirst(
                                  ':id', item.mediaId.toString()),
                            );
                          }
                        },
                        onRemove: () => ref
                            .read(watchlistProvider.notifier)
                            .removeItemFromWatchlist(
                              watchlistId: watchlistId,
                              mediaId: item.mediaId,
                              mediaType: item.mediaType,
                            ),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              );
            },
            loading: () => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const WatchlistShimmerCard(),
                  childCount: 6,
                ),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorView(
                error: err,
                onRetry: () =>
                    ref.invalidate(watchlistItemsProvider(watchlistId)),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: AppSpacing.xxxl * 2 + AppSpacing.sm + AppSpacing.xs,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String name,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Elimina watchlist'),
        content:
            Text('Vuoi eliminare "$name"? Questa azione è irreversibile.'),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref
          .read(watchlistProvider.notifier)
          .deleteWatchlist(watchlistId);
      if (context.mounted) context.pop();
    }
  }
}

class _WatchlistDetailEmpty extends StatelessWidget {
  final AppColorScheme colors;
  final TextTheme textTheme;

  const _WatchlistDetailEmpty(
      {required this.colors, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: colors.onSurfacePrimary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 56,
            color: colors.onSurfacePrimary.withValues(alpha: 0.18),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Lista vuota',
            style:
                textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Aggiungi film e serie dalla loro pagina dettaglio.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
