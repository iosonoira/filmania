import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/image_upload_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../watched/ui/providers/watched_providers.dart';
import '../../../watched/domain/entities/watched_item.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/l10n/app_localizations_provider.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../providers/user_stats_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final uploadState = ref.watch(imageUploadControllerProvider);
    final colors = AppColors.of(context);
    final l10n = ref.watch(appLocalizationsProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: GlassmorphicAppBar(
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_rounded),
            color: colors.onSurfacePrimary,
            tooltip: l10n.settingsTitle,
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight + AppSpacing.xl,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ProfileHero(
                  username: user?.username ?? 'The Curator',
                  photoUrl: user?.photoUrl,
                  isLoading: uploadState.isLoading,
                  onAvatarTap: () => _pickAndUpload(ref),
                ),
                if (uploadState.hasError) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.uploadError(uploadState.error.toString()),
                    style: TextStyle(color: colors.error),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                const _StatsBentoGrid(),
                const SizedBox(height: AppSpacing.xl),
                const _RecentActivitySection(),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: OutlinedButton(
                    onPressed: () => ref.read(authProvider.notifier).logout(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.error,
                      side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                    ),
                    child: Text(l10n.signOut),
                  ),
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUpload(WidgetRef ref) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      await ref.read(imageUploadControllerProvider.notifier).upload(xfile);
    }
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.username,
    required this.photoUrl,
    required this.isLoading,
    required this.onAvatarTap,
  });

  final String username;
  final String? photoUrl;
  final bool isLoading;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: isLoading ? null : onAvatarTap,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  color: colors.surface,
                ),
                child: photoUrl != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: photoUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.person, color: colors.primary, size: 50),
                        ),
                      )
                    : Icon(Icons.person, color: colors.primary, size: 50),
              ),
            ),
            if (isLoading)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          username,
          textAlign: TextAlign.center,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}


class _StatsBentoGrid extends ConsumerWidget {
  const _StatsBentoGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final statsAsync = ref.watch(userStatsProvider);

    return statsAsync.when(
      loading: () => _BentoCard(
        child: Center(
          child: SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator(color: colors.primary)),
          ),
        ),
      ),
      error: (error, stack) => const _BentoCard(
        child: Center(child: Icon(Icons.error_outline)),
      ),
      data: (stats) {
        final totalMinutes = stats?.totalWatchTimeMinutes ?? 0;
        final totalHours = totalMinutes / 60.0;
        final movieHours = ((stats?.moviesWatchTimeMinutes ?? 0) / 60).floor();
        final tvHours = ((stats?.tvWatchTimeMinutes ?? 0) / 60).floor();

        return _BentoCard(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -AppSpacing.sm,
                right: -AppSpacing.sm,
                child: Icon(
                  Icons.watch_later,
                  size: 160,
                  color: colors.primary.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.05 : 0.1),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.totalWatchTime.toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceSecondary,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        totalHours < 10 
                            ? totalHours.toStringAsFixed(1) 
                            : totalHours.floor().toString(),
                        style: textTheme.displayLarge?.copyWith(
                          color: colors.primary,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        AppLocalizations.of(context)!.hoursUnit,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colors.onSurfaceSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      _MiniStat(
                        label: AppLocalizations.of(context)!.moviesTitle,
                        value: stats?.moviesWatchedCount.toString() ?? '0',
                        subtitle: '${movieHours}h',
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      _MiniStat(
                        label: AppLocalizations.of(context)!.tvSeriesTitle,
                        value: stats?.tvSeriesWatchedCount.toString() ?? '0',
                        subtitle: '${tvHours}h',
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      _MiniStat(
                        label: AppLocalizations.of(context)!.episodesTitle,
                        value: stats?.episodesWatchedCount.toString() ?? '0',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BentoCard extends StatelessWidget {
  const _BentoCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDark 
            ? colors.surface.withValues(alpha: 0.4) 
            : colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(
          color: colors.onSurfacePrimary.withValues(alpha: isDark ? 0.05 : 0.08),
        ),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15), // Much darker shadow
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, this.subtitle});
  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            color: colors.onSurfaceSecondary,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 9,
              color: colors.onSurfaceSecondary,
            ),
          ),
      ],
    );
  }
}

class _RecentActivitySection extends ConsumerWidget {
  const _RecentActivitySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final asyncMovies = ref.watch(watchedItemsProvider(MediaType.movie));
    final asyncTv = ref.watch(watchedItemsProvider(MediaType.tv));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: asyncMovies.when(
                data: (movies) => _CategoryCard(
                  title: AppLocalizations.of(context)!.moviesTitle,
                  items: movies,
                  onTap: () => context.push(AppRoutes.watchedMovies),
                ),
                loading: () => const _CategoryCardPlaceholder(),
                error: (e, st) => const _CategoryCardPlaceholder(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: asyncTv.when(
                data: (tv) => _CategoryCard(
                  title: AppLocalizations.of(context)!.tvSeriesTitle,
                  items: tv,
                  onTap: () => context.push(AppRoutes.watchedTv),
                ),
                loading: () => const _CategoryCardPlaceholder(),
                error: (e, st) => const _CategoryCardPlaceholder(),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          AppLocalizations.of(context)!.recentActivity,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Manrope',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        asyncMovies.when(
          data: (movies) => asyncTv.when(
            data: (tv) {
              final allItems = [...movies, ...tv]
                ..sort((a, b) => b.watchedAt.compareTo(a.watchedAt));
              final recentItems = allItems.take(5).toList();

              if (recentItems.isEmpty) {
                return const _EmptyActivity();
              }

              return Column(
                children: recentItems.map((item) => _ActivityItem(item: item)).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),

            error: (e, _) => Text('Errore: $e'),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Errore: $e'),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.items,
    required this.onTap,
  });

  final String title;
  final List<WatchedItem> items;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isDark ? colors.surface.withValues(alpha: 0.8) : colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          border: Border.all(
            color: colors.onSurfacePrimary.withValues(alpha: isDark ? 0.1 : 0.08),
          ),
          boxShadow: isDark ? null : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (items.isNotEmpty)
              Positioned.fill(
                child: Row(
                  children: items.take(3).map((item) => Expanded(
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (item.posterPath != null)
                            CachedNetworkImage(
                              imageUrl: 'https://image.tmdb.org/t/p/w200${item.posterPath}',
                              fit: BoxFit.cover,
                              memCacheWidth: 150,
                            ),
                          Container(
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
            Center(
              child: Text(
                title.toUpperCase(),
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCardPlaceholder extends StatelessWidget {
  const _CategoryCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.6),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}


class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.item});
  final WatchedItem item;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        final path = item.mediaType == MediaType.movie
            ? AppRoutes.movieDetails.replaceAll(':id', item.mediaId.toString())
            : AppRoutes.tvDetails.replaceAll(':id', item.mediaId.toString());
        context.push(path);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? colors.surface.withValues(alpha: 0.5) : colors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          boxShadow: isDark ? null : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              child: SizedBox(
                width: 50,
                height: 75,
                child: item.posterPath != null
                    ? CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w200${item.posterPath}',
                        fit: BoxFit.cover,
                        memCacheWidth: 100,
                      )
                    : Container(color: colors.surface),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.mediaTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.mediaType == MediaType.movie 
                        ? AppLocalizations.of(context)!.moviesTitle 
                        : AppLocalizations.of(context)!.tvSeriesTitle,
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        Icons.star,
                        size: 14,
                        color: i < 4
                            ? colors.primary
                            : colors.onSurfaceSecondary.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.onSurfaceSecondary),
          ],
        ),
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: isDark ? colors.surface.withValues(alpha: 0.3) : colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.movie_outlined, size: 48, color: colors.onSurfaceSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppLocalizations.of(context)!.noRecentActivity,
            style: TextStyle(color: colors.onSurfaceSecondary),
          ),
        ],
      ),
    );
  }
}
