import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../providers/watchlist_providers.dart';
import '../../../../core/widgets/error_view.dart';
import '../../domain/entities/watchlist.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WatchlistPage extends ConsumerWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final watchlistsAsync = ref.watch(userWatchlistsProvider);

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
                  Text(
                    'Le mie Watchlist',
                    style: textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      color: colors.onSurfacePrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Organizza film e serie nelle tue liste personali.',
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),

          watchlistsAsync.when(
            data: (lists) {
              if (lists.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: _WatchlistEmptyState(),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final wl = lists[index];
                      return _WatchlistCard(
                        watchlist: wl,
                        onTap: () => context.push(
                          AppRoutes.watchlistDetail.replaceFirst(':id', wl.id),
                        ),
                      );
                    },
                    childCount: lists.length,
                  ),
                ),
              );
            },
            loading: () => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _WatchlistShimmerCard(),
                  childCount: 4,
                ),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorView(
                error: err,
                onRetry: () => ref.invalidate(userWatchlistsProvider),
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
}

class _WatchlistCard extends ConsumerWidget {
  final Watchlist watchlist;
  final VoidCallback? onTap;

  const _WatchlistCard({required this.watchlist, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final itemsAsync = ref.watch(watchlistItemsProvider(watchlist.id));
    final items = itemsAsync.value ?? [];
    final cover = items
        .where((i) => i.fullPosterUrl != null)
        .map((i) => i.fullPosterUrl)
        .firstOrNull;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover image or placeholder
            if (cover != null)
              CachedNetworkImage(
                imageUrl: cover,
                fit: BoxFit.cover,
                memCacheWidth: 300,
                placeholder: (context, url) => Container(
                    color: colors.surface.withValues(alpha: 0.2)),
                errorWidget: (context, url, err) =>
                    _WatchlistCoverPlaceholder(colors: colors),
              )
            else
              _WatchlistCoverPlaceholder(colors: colors),

            // Gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.black.withValues(alpha: 0.1),
                    ],
                    stops: const [0.0, 0.6],
                  ),
                ),
              ),
            ),

            // Info
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    watchlist.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${items.length} titoli',
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Top-right bookmark badge
            Positioned(
              top: 8,
              right: 8,
              child: GlassOverlay(
                sigma: 10,
                borderRadius: BorderRadius.circular(10),
                color: colors.primary.withValues(alpha: 0.75),
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.xs),
                  child: Icon(
                    Icons.bookmark_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchlistCoverPlaceholder extends StatelessWidget {
  final AppColorScheme colors;
  const _WatchlistCoverPlaceholder({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary.withValues(alpha: 0.3),
            colors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.movie_filter_rounded,
          size: 40,
          color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _WatchlistShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            colors.surface.withValues(alpha: 0.05),
            colors.surface.withValues(alpha: 0.12),
            colors.surface.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

class _WatchlistEmptyState extends StatelessWidget {
  const _WatchlistEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return GlassOverlay(
      borderRadius: BorderRadius.circular(24),
      color: colors.onSurfacePrimary.withValues(alpha: 0.05),
      sigma: 10,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Icon(
              Icons.bookmark_outline_rounded,
              size: 64,
              color: colors.onSurfacePrimary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Nessuna Watchlist',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Aggiungi un film o una serie dalla pagina dettaglio per creare la tua prima watchlist!',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
