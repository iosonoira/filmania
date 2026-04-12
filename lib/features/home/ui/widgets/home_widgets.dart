import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../movies/ui/providers/movies_provider.dart';
import '../../../tv_series/ui/providers/tv_series_provider.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';


// --- Trending Movies Section ---
class TrendingMoviesSection extends ConsumerWidget {
  const TrendingMoviesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(trendingMoviesProvider(page: 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Trending Movies'),
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
                'View all',
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
            title: movie.title,
            subtitle: movie.releaseDate?.year.toString() ?? '',
            imageUrl: movie.posterPath != null ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}' : '',
            progress: movie.voteAverage / 10,
          );
        },
      ),
    );
  }
}


class WatchingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double progress;

  const WatchingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Stai guardando $title, $subtitle, ${(progress * 100).round()}% completato',
      button: true,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
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
        child: _WatchingCardContent(
          title: title,
          subtitle: subtitle,
          progress: progress,
        ),
      ),
    );
  }
}

class _WatchingCardContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;

  const _WatchingCardContent({
    required this.title,
    required this.subtitle,
    required this.progress,
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
            const SizedBox(height: AppSpacing.md),
            _WatchingCardProgressBar(progress: progress),
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

class _WatchingCardProgressBar extends StatelessWidget {
  final double progress;

  const _WatchingCardProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Stack(
      children: [
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        Container(
          height: 6,
          width: MediaQuery.of(context).size.width * 0.85 * progress,
          constraints: BoxConstraints(maxWidth: 450 * progress),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.6),
                blurRadius: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// --- Trending TV Series Section ---
class TrendingTVSeriesSection extends ConsumerWidget {
  const TrendingTVSeriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final containerColor = isDark
        ? const Color(0xFF1C1B20)
        : const Color(0xFFF5F5F5);

    final tvSeriesAsync = ref.watch(trendingTVSeriesProvider(page: 1));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Trending TV Series',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          tvSeriesAsync.when(
            data: (tvSeries) => ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: tvSeries.length > 5 ? 5 : tvSeries.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final item = tvSeries[index];
                return _UpcomingEpisodeItem(
                  title: item.name,
                  subtitle: item.firstAirDate?.year.toString() ?? '',
                  time: 'Rating: ${item.voteAverage.toStringAsFixed(1)}',
                  timeColor: AppColors.of(context).primary,
                  imageUrl: item.posterPath != null ? 'https://image.tmdb.org/t/p/w500${item.posterPath}' : '',
                  containerColor: containerColor,
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => AppErrorView(
              error: err,
              compact: true,
              onRetry: () => ref.invalidate(trendingTVSeriesProvider(page: 1)),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingEpisodeItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Color timeColor;
  final String imageUrl;
  final Color containerColor;

  const _UpcomingEpisodeItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.timeColor,
    required this.imageUrl,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
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
                : Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
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
            onPressed: () {},
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
            'Curated for You',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          discoverAsync.when(
            data: (movies) {
              if (movies.isEmpty) return const SizedBox.shrink();
              final featuredMovie = movies[0];
              final secondaryMovie = movies.length > 1 ? movies[1] : null;

              return Column(
                children: [
                  _FeaturedBentoCard(movie: featuredMovie),
                  const SizedBox(height: AppSpacing.md),
                  if (secondaryMovie != null) ...[
                    _SecondaryBentoCard(movie: secondaryMovie, containerColor: containerColorLow),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  _TrendingTopRatedRow(containerColor: containerColorLow),
                ],
              );
            },
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
            movie.posterPath != null ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}' : '',
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
            const _FeaturedBentoButton(),
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
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFB55800),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'FEATURED',
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
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF36343A)
                : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'MOVIE',
            style: textTheme.labelSmall?.copyWith(
              color: isDark
                  ? const Color(0xFFCAC3D8)
                  : const Color(0xFF4A4264),
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
          style: textTheme.bodySmall?.copyWith(
            color: const Color(0xFFCAC3D8),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _FeaturedBentoButton extends StatelessWidget {
  const _FeaturedBentoButton();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: const Text('Add to Watchlist'),
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
            title: 'Trending',
            subtitle: 'New this week',
            containerColor: containerColor,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _BentoSmallBox(
            icon: Icons.star_rounded,
            iconColor: AppColors.tertiary,
            title: 'Top Rated',
            subtitle: 'All-time classics',
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
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
          icon: Icons.home_filled,
          label: 'Home',
          isSelected: currentIndex == 0,
          color: colors.primary,
          textTheme: textTheme,
          onTap: () => onDestinationSelected(0),
        ),
        _NavBarItem(
          icon: Icons.explore_outlined,
          label: 'Discover',
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
              Icon(icon, color: isSelected ? itemColor : color.withValues(alpha: 0.8)),
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
