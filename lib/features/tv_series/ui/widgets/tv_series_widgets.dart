import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/tv_episode.dart';
import '../../domain/entities/tv_season.dart';
import '../providers/tv_series_provider.dart';
import '../../../../core/widgets/error_view.dart';

class EpisodesSection extends ConsumerWidget {
  final int tvId;
  final List<TVSeason> seasons;

  const EpisodesSection({super.key, required this.tvId, required this.seasons});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainSeasons = seasons.where((s) => s.seasonNumber > 0).toList();

    if (mainSeasons.isEmpty) return const SizedBox.shrink();

    final selectedSeason = ref.watch(selectedSeasonProvider(tvId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EpisodesSectionHeader(
          tvId: tvId,
          seasons: mainSeasons,
          selectedSeason: selectedSeason,
        ),
        const SizedBox(height: AppSpacing.md),
        _EpisodesList(tvId: tvId, seasonNumber: selectedSeason),
      ],
    );
  }
}

class _EpisodesSectionHeader extends ConsumerWidget {
  final int tvId;
  final List<TVSeason> seasons;
  final int selectedSeason;

  const _EpisodesSectionHeader({
    required this.tvId,
    required this.seasons,
    required this.selectedSeason,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Episodi',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 36,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: seasons.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final season = seasons[index];
              final isSelected = season.seasonNumber == selectedSeason;
              return _SeasonChip(
                label: season.name,
                isSelected: isSelected,
                onTap: () => ref
                    .read(selectedSeasonProvider(tvId).notifier)
                    .select(season.seasonNumber),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SeasonChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SeasonChip({
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
          curve: Curves.easeInOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            border: Border.all(
              color: isSelected
                  ? colors.primary
                  : colors.onSurfaceSecondary.withValues(alpha: 0.3),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: isSelected ? Colors.white : colors.onSurfaceSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _EpisodesList extends ConsumerWidget {
  final int tvId;
  final int seasonNumber;

  const _EpisodesList({required this.tvId, required this.seasonNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(seasonEpisodesProvider(tvId, seasonNumber));

    return episodesAsync.when(
      data: (episodes) => _EpisodesListContent(episodes: episodes),
      loading: () => const _EpisodesLoadingSkeleton(),
      error: (err, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: AppErrorView(
          error: err,
          compact: true,
          onRetry: () =>
              ref.invalidate(seasonEpisodesProvider(tvId, seasonNumber)),
        ),
      ),
    );
  }
}

class _EpisodesListContent extends StatelessWidget {
  final List<TVEpisode> episodes;

  const _EpisodesListContent({required this.episodes});

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return const _EpisodesEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: episodes.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) => EpisodeCard(episode: episodes[index]),
    );
  }
}

class EpisodeCard extends StatelessWidget {
  final TVEpisode episode;

  const EpisodeCard({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Semantics(
      label: 'Episodio ${episode.episodeNumber}: ${episode.name}',
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: Border.all(
            color: colors.onSurfaceSecondary.withValues(alpha: 0.1),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            _EpisodeCardThumbnail(episode: episode),
            const SizedBox(width: AppSpacing.md),
            _EpisodeCardInfo(episode: episode),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _EpisodeCardThumbnail extends StatelessWidget {
  final TVEpisode episode;

  const _EpisodeCardThumbnail({required this.episode});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return SizedBox(
      width: 120,
      height: 90,
      child: episode.fullStillUrl != null
          ? CachedNetworkImage(
              imageUrl: episode.fullStillUrl!,
              fit: BoxFit.cover,
              memCacheWidth: 240,
              placeholder: (context, url) =>
                  Container(color: colors.surface.withValues(alpha: 0.1)),
              errorWidget: (context, url, error) =>
                  _EpisodeCardThumbnailFallback(colors: colors),
            )
          : _EpisodeCardThumbnailFallback(colors: colors),
    );
  }
}

class _EpisodeCardThumbnailFallback extends StatelessWidget {
  final AppColorScheme colors;

  const _EpisodeCardThumbnailFallback({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.surface.withValues(alpha: 0.2),
      child: Icon(
        Icons.tv_rounded,
        color: colors.onSurfaceSecondary.withValues(alpha: 0.4),
        size: 32,
      ),
    );
  }
}

class _EpisodeCardInfo extends StatelessWidget {
  final TVEpisode episode;

  const _EpisodeCardInfo({required this.episode});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _EpisodeCardNumberRow(
            episode: episode,
            colors: colors,
            textTheme: textTheme,
          ),
          const SizedBox(height: 2),
          Text(
            episode.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurfacePrimary,
            ),
          ),
          const SizedBox(height: 2),
          if (episode.overview.isNotEmpty)
            Text(
              episode.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceSecondary,
                height: 1.3,
              ),
            ),
        ],
      ),
    );
  }
}

class _EpisodeCardNumberRow extends StatelessWidget {
  final TVEpisode episode;
  final AppColorScheme colors;
  final TextTheme textTheme;

  const _EpisodeCardNumberRow({
    required this.episode,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'E${episode.episodeNumber}',
          style: textTheme.labelSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        if (episode.runtime != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${episode.runtime} min',
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceSecondary,
            ),
          ),
        ],
        if (episode.voteAverage > 0) ...[
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
          const SizedBox(width: 2),
          Text(
            episode.voteAverage.toStringAsFixed(1),
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _EpisodesLoadingSkeleton extends StatelessWidget {
  const _EpisodesLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _SkeletonCard(),
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
    );
  }
}

class _EpisodesEmptyState extends StatelessWidget {
  const _EpisodesEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 48,
              color: colors.onSurfaceSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Nessun episodio disponibile',
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
