import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/image_upload_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../watched/ui/providers/watched_providers.dart';
import '../../../watched/domain/entities/watched_item.dart';
import '../../../watched/ui/pages/watched_list_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final uploadState = ref.watch(imageUploadControllerProvider);
    final colors = AppColors.of(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top + AppSpacing.xl,
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
                    'Errore upload: ${uploadState.error}',
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
                    child: const Text('Esci'),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: isLoading ? null : onAvatarTap,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.2),
                    width: 2,
                  ),
                  color: colors.surface,
                  image: photoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(photoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: photoUrl == null
                    ? Icon(Icons.person, color: colors.primary, size: 40)
                    : null,
              ),
            ),
            if (isLoading)
              const Positioned.fill(
                child: Center(child: CircularProgressIndicator()),
              ),
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'LV 42',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'CINEPHILE ELITE • JOINED SEPT 2023',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.primary.withValues(alpha: 0.7),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _HeroBadge(
                    icon: Icons.military_tech,
                    label: 'Grand Master',
                    color: colors.accent,
                  ),
                  _HeroBadge(
                    icon: Icons.verified,
                    label: 'Top 1% Reviewer',
                    color: colors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: colors.onSurfacePrimary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _StatsBentoGrid extends StatelessWidget {
  const _StatsBentoGrid();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

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
              color: colors.primary.withValues(alpha: 0.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tempo Totale'.toUpperCase(),
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
                    '1.248',
                    style: textTheme.displayLarge?.copyWith(
                      color: colors.primary,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'ore',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colors.onSurfaceSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              const Row(
                children: [
                  _MiniStat(label: 'Film', value: '412'),
                  SizedBox(width: AppSpacing.xl),
                  _MiniStat(label: 'Serie', value: '84'),
                  SizedBox(width: AppSpacing.xl),
                  _MiniStat(label: 'Episodi', value: '2.8k'),
                ],
              ),
            ],
          ),
        ],
      ),
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(
          color: colors.onSurfacePrimary.withValues(alpha: 0.05),
        ),
      ),
      child: child,
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});
  final String label;
  final String value;

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attività Recente',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Manrope',
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const WatchedListPage(mediaType: MediaType.movie),
                    ));
                  },
                  child: const Text('Film'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const WatchedListPage(mediaType: MediaType.tv),
                    ));
                  },
                  child: const Text('Serie'),
                ),
              ],
            ),
          ],
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

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.item});
  final WatchedItem item;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: SizedBox(
              width: 50,
              height: 75,
              child: item.posterPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w200${item.posterPath}',
                      fit: BoxFit.cover,
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
                  item.mediaType == MediaType.movie ? 'Film' : 'Serie TV',
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
                      color: i < 4 ? colors.primary : colors.onSurfaceSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: colors.onSurfaceSecondary),
        ],
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
      ),
      child: Column(
        children: [
          Icon(Icons.movie_outlined, size: 48, color: colors.onSurfaceSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Nessuna attività recente',
            style: TextStyle(color: colors.onSurfaceSecondary),
          ),
        ],
      ),
    );
  }
}
