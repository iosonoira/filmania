import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../movies/ui/providers/movies_provider.dart';
import '../../../tv_series/ui/providers/tv_series_provider.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/features/watchlist/ui/widgets/watchlist_picker_sheet.dart';
import '../../../../core/domain/enums/media_type.dart';

// --- Trending Movies Section ---
class TrendingMoviesSection extends ConsumerWidget {
  const TrendingMoviesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(trendingMoviesProvider(page: 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Film del Momento'),
        const SizedBox(height: AppSpacing.lg),
        moviesAsync.when(
          data: (movies) => _TrendingMoviesList(movies: movies),
          loading: () => const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => AppErrorView(
            error: err,
            compact: true,
            onRetry: () => ref.invalidate(trendingMoviesProvider(page: 1)),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          Row(
            children: [
              Text(
                'Vedi tutti',
                style: textTheme.labelLarge?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: colors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendingMoviesList extends StatelessWidget {
  final List<Movie> movies;

  const _TrendingMoviesList({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: movies.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return WatchingCard(
            mediaId: movie.id,
            title: movie.title,
            subtitle: movie.releaseDate?.year.toString() ?? '',
            imageUrl: movie.fullPosterUrl ?? '',
            posterPath: movie.posterPath,
          );
        },
      ),
    );
  }
}

class WatchingCard extends ConsumerWidget {
  final int mediaId;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? posterPath;

  const WatchingCard({
    super.key,
    required this.mediaId,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.posterPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: 'Guarda $title, $subtitle',
      button: true,
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.85,
        constraints: const BoxConstraints(maxWidth: 450),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: _WatchingCardContent(
                title: title,
                subtitle: subtitle,
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: IconButton.filled(
                onPressed: () => showWatchlistPicker(
                  context,
                  ref,
                  mediaId: mediaId,
                  mediaTitle: title,
                  mediaType: MediaType.movie,
                  posterPath: posterPath,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.bookmark_add_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchingCardContent extends StatelessWidget {
  final String title;
  final String subtitle;

  const _WatchingCardContent({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            colors.background.withValues(alpha: 0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _WatchingCardBadge(subtitle: subtitle),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchingCardBadge extends StatelessWidget {
  final String subtitle;

  const _WatchingCardBadge({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(100),
      ),
      child: GlassOverlay(
        sigma: 10,
        borderRadius: BorderRadius.circular(100),
        color: Colors.transparent,
        child: Text(
          subtitle.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

// _WatchingCardProgressBar removed because progress bar under trending films is not needed.

// --- Trending TV Series Section ---
class TrendingTVSeriesSliver extends ConsumerWidget {
  const TrendingTVSeriesSliver({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final tvSeriesAsync = ref.watch(trendingTVSeriesProvider(page: 1));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerColor = isDark
        ? const Color(0xFF1C1B20)
        : const Color(0xFFF5F5F5);

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Serie TV del Momento',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        tvSeriesAsync.when(
          data: (tvSeries) {
            final itemCount = tvSeries.length > 5 ? 5 : tvSeries.length;
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverList.separated(
                itemCount: itemCount,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final item = tvSeries[index];
                  return _UpcomingEpisodeItem(
                    mediaId: item.id,
                    title: item.name,
                    subtitle: item.firstAirDate?.year.toString() ?? '',
                    time: 'Voto: ${item.voteAverage.toStringAsFixed(1)}',
                    timeColor: AppColors.of(context).primary,
                    imageUrl: item.posterPath != null
                        ? 'https://image.tmdb.org/t/p/w500${item.posterPath}'
                        : '',
                    posterPath: item.posterPath,
                    containerColor: containerColor,
                  );
                },
              ),
            );
          },
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => SliverToBoxAdapter(
            child: AppErrorView(
              error: err,
              compact: true,
              onRetry: () => ref.invalidate(trendingTVSeriesProvider(page: 1)),
            ),
          ),
        ),
      ],
    );
  }
}

class _UpcomingEpisodeItem extends ConsumerWidget {
  final int mediaId;
  final String title;
  final String subtitle;
  final String time;
  final Color timeColor;
  final String imageUrl;
  final String? posterPath;
  final Color containerColor;

  const _UpcomingEpisodeItem({
    required this.mediaId,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.timeColor,
    required this.imageUrl,
    this.posterPath,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl.isEmpty
                ? Container(
                    width: 80,
                    height: 80,
                    color: colors.onSurfaceSecondary.withValues(alpha: 0.1),
                    child: Icon(Icons.tv, color: colors.onSurfaceSecondary),
                  )
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    memCacheWidth: 160,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: colors.surface.withValues(alpha: 0.1),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
                      color: colors.surface.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.tv_rounded,
                        color: colors.onSurfaceSecondary,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: textTheme.labelSmall?.copyWith(
                    color: timeColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Manrope',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark_add_outlined,
              color: colors.onSurfaceSecondary,
            ),
            onPressed: () => showWatchlistPicker(
              context,
              ref,
              mediaId: mediaId,
              mediaTitle: title,
              mediaType: MediaType.tv,
              posterPath: posterPath,
            ),
          ),
        ],
      ),
    );
  }
}

class CuratedSection extends ConsumerWidget {
  const CuratedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;
    final containerColorLow = isDark
        ? const Color(0xFF1C1B20)
        : const Color(0xFFF5F5F5);
    final discoverAsync = ref.watch(discoverMoviesProvider(page: 1));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selezionati per Te',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          discoverAsync.when(
            data: (movies) => _CuratedContent(
              movies: movies,
              containerColor: containerColorLow,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => AppErrorView(
              error: err,
              compact: true,
              onRetry: () => ref.invalidate(discoverMoviesProvider(page: 1)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CuratedContent extends StatelessWidget {
  const _CuratedContent({required this.movies, required this.containerColor});

  final List<Movie> movies;
  final Color containerColor;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();
    final featuredMovie = movies[0];
    final secondaryMovie = movies.length > 1 ? movies[1] : null;

    return Column(
      children: [
        _FeaturedBentoCard(movie: featuredMovie),
        const SizedBox(height: AppSpacing.md),
        if (secondaryMovie != null) ...[
          _SecondaryBentoCard(
            movie: secondaryMovie,
            containerColor: containerColor,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        _TrendingTopRatedRow(containerColor: containerColor),
      ],
    );
  }
}

class _FeaturedBentoCard extends StatelessWidget {
  final Movie movie;

  const _FeaturedBentoCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        image: DecorationImage(
          image: NetworkImage(
            movie.posterPath != null
                ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                : '',
          ),
          fit: BoxFit.cover,
          opacity: 0.6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              colors.background.withValues(alpha: 1.0),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const _FeaturedBentoTags(),
            const SizedBox(height: AppSpacing.md),
            _FeaturedBentoContent(movie: movie),
            const SizedBox(height: AppSpacing.lg),
            _FeaturedBentoButton(movie: movie),
          ],
        ),
      ),
    );
  }
}

class _FeaturedBentoTags extends StatelessWidget {
  const _FeaturedBentoTags();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFB55800),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'IN EVIDENZA',
            style: textTheme.labelSmall?.copyWith(
              color: const Color(0xFFFFF7F4),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 10,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF36343A) : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'FILM',
            style: textTheme.labelSmall?.copyWith(
              color: isDark ? const Color(0xFFCAC3D8) : const Color(0xFF4A4264),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedBentoContent extends StatelessWidget {
  final Movie movie;

  const _FeaturedBentoContent({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          movie.overview,
          style: textTheme.bodySmall?.copyWith(color: const Color(0xFFCAC3D8)),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _FeaturedBentoButton extends ConsumerWidget {
  final Movie movie;
  const _FeaturedBentoButton({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);

    return FilledButton(
      onPressed: () => showWatchlistPicker(
        context,
        ref,
        mediaId: movie.id,
        mediaTitle: movie.title,
        mediaType: MediaType.movie,
        posterPath: movie.posterPath,
      ),
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      child: const Text('Aggiungi alla Watchlist'),
    );
  }
}

class _SecondaryBentoCard extends StatelessWidget {
  final Movie movie;
  final Color containerColor;

  const _SecondaryBentoCard({
    required this.movie,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(
          color: colors.onSurfaceSecondary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  movie.overview,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            movie.voteAverage.toStringAsFixed(1),
            style: textTheme.titleLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingTopRatedRow extends StatelessWidget {
  final Color containerColor;

  const _TrendingTopRatedRow({required this.containerColor});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Row(
      children: [
        Expanded(
          child: _BentoSmallBox(
            icon: Icons.trending_up_rounded,
            iconColor: colors.primary,
            title: 'Tendenze',
            subtitle: 'Novità questa settimana',
            containerColor: containerColor,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _BentoSmallBox(
            icon: Icons.star_rounded,
            iconColor: AppColors.tertiary,
            title: 'I Più Votati',
            subtitle: 'Classici intramontabili',
            containerColor: containerColor,
          ),
        ),
      ],
    );
  }
}

class _BentoSmallBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color containerColor;

  const _BentoSmallBox({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(
          color: colors.onSurfaceSecondary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Floating Bottom Navigation Bar ---
class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: GlassOverlay(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        color: colors.background.withValues(alpha: 0.85),
        sigma: 24,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            border: Border.all(color: colors.primary.withValues(alpha: 0.05)),
          ),
          child: _NavBarItemsRow(
            currentIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
          ),
        ),
      ),
    );
  }
}

class _NavBarItemsRow extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const _NavBarItemsRow({
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _NavBarItem(
          icon: Icons.home_outlined,
          label: 'Home',
          isSelected: currentIndex == 0,
          color: colors.onSurfaceSecondary,
          textTheme: textTheme,
          onTap: () => onDestinationSelected(0),
        ),
        _NavBarItem(
          icon: Icons.explore_outlined,
          label: 'Scopri',
          isSelected: currentIndex == 1,
          color: colors.onSurfaceSecondary,
          textTheme: textTheme,
          onTap: () => onDestinationSelected(1),
        ),
        _NavBarItem(
          icon: Icons.bookmark_border_rounded,
          label: 'Watchlist',
          isSelected: currentIndex == 2,
          color: colors.onSurfaceSecondary,
          textTheme: textTheme,
          onTap: () => onDestinationSelected(2),
        ),
        _NavBarItem(
          icon: Icons.person_outline_rounded,
          label: 'Profile',
          isSelected: currentIndex == 3,
          color: colors.onSurfaceSecondary,
          textTheme: textTheme,
          onTap: () => onDestinationSelected(3),
        ),
      ],
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color color;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.color,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor = isSelected ? AppColors.of(context).primary : color;

    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: isSelected
              ? BoxDecoration(
                  color: itemColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: itemColor.withValues(alpha: 0.1)),
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? itemColor : color.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 2),
              Text(
                label.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: isSelected ? itemColor : color.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
