import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/glass_overlay.dart';
import '../../../../core/widgets/glassmorphic_app_bar.dart';
import '../../domain/entities/favorite_item.dart';
import '../providers/favorites_providers.dart';
import '../widgets/favorite_button.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true, minimal: true),
      body: CustomScrollView(
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
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Preferiti',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  color: colors.onSurfacePrimary,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          favoritesAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: _FavoritesEmptyState(),
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
                    (context, index) => _FavoriteCard(item: items[index]),
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
                  childAspectRatio: 0.85,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const _FavoriteShimmerCard(),
                  childCount: 4,
                ),
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              hasScrollBody: false,
              child: AppErrorView(
                error: err,
                onRetry: () => ref.invalidate(favoritesProvider),
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

class _FavoriteCard extends StatelessWidget {
  final FavoriteItem item;

  const _FavoriteCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final posterUrl = item.posterPath != null
        ? 'https://image.tmdb.org/t/p/w342${item.posterPath}'
        : null;

    return GestureDetector(
      onTap: () {
        final path = item.mediaType == MediaType.movie
            ? AppRoutes.movieDetails.replaceAll(':id', item.mediaId.toString())
            : AppRoutes.tvDetails.replaceAll(':id', item.mediaId.toString());
        context.push(path);
      },
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
            if (posterUrl != null)
              CachedNetworkImage(
                imageUrl: posterUrl,
                fit: BoxFit.cover,
                memCacheWidth: 300,
                placeholder: (context, url) =>
                    Container(color: colors.surface.withValues(alpha: 0.2)),
                errorWidget: (context, url, err) =>
                    _FavoritePosterPlaceholder(colors: colors),
              )
            else
              _FavoritePosterPlaceholder(colors: colors),
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
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                item.mediaTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GlassOverlay(
                sigma: 10,
                borderRadius: BorderRadius.circular(10),
                color: colors.primary.withValues(alpha: 0.75),
                child: FavoriteButton(
                  mediaId: item.mediaId,
                  mediaTitle: item.mediaTitle,
                  mediaType: item.mediaType,
                  posterPath: item.posterPath,
                  size: 28,
                  hasBackground: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritePosterPlaceholder extends StatelessWidget {
  final AppColorScheme colors;
  const _FavoritePosterPlaceholder({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary.withValues(alpha: 0.3), colors.surface],
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

class _FavoriteShimmerCard extends StatelessWidget {
  const _FavoriteShimmerCard();

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

class _FavoritesEmptyState extends StatelessWidget {
  const _FavoritesEmptyState();

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
              Icons.favorite_border_rounded,
              size: 64,
              color: colors.onSurfacePrimary.withValues(alpha: 0.2),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Nessun preferito',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Aggiungi un film o una serie dalla pagina dettaglio per vederlo qui.',
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
