import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';

// --- Currently Watching Section ---
class CurrentlyWatchingSection extends StatelessWidget {
  const CurrentlyWatchingSection({super.key});

  static const _mockItems = [
    {
      'title': 'Shōgun',
      'subtitle': 'Season 1 • Ep 8',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuABHin8DHJXVAakKuHBaa4v5QxiwHkXrcFSOJ3NUyb1R3IXS2U82fwwgTEYSBOKg-bq068veOMUcsBsbv1vcfHZfjYC08ukKXWyo8jwvYVhzbxjFAoTbiJ0wE_HrfG3uqUoQI2wO-8nONajZ0Uz3uAvkiwWgad4k4fnRGj06y4KMOAp0uXe9Iblmcd5pzU3ZCA_JSc97xVr7Ie5OlrR_bGYsueWtYx1olYFuL1tNC0JN_6jom-4_S7U7MYplwEdiVajlYAL1qRl0VJp',
      'progress': 0.75,
    },
    {
      'title': 'Blade Runner 2049',
      'subtitle': 'Movie',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuABpOAU_cn2ng30yT5tNmwcP5iuw2Ubm4HLQEghxc-MD0FNizfE0RJm9zVbIDB_7G2RZWa7P_cuUmHYZw5LQYa5JczW4q8oWMyCAyeTLRWauEbHALcX6YHfP5v2pNAAhtUnN0SgzltaFs6SVqO2nkonFW6sD9g1qVB5VNrOPg9Mo4opPg42_1tkDni4MNHSWvUSjOaazf6N3AQY4XH730tX_f1dKa6E9vpCdpJ61pT1xfK1shqOv7pm1Br3gEeyhHlHMY9C0cq9fzlj',
      'progress': 0.40,
    },
    {
      'title': 'Succession',
      'subtitle': 'Season 4 • Ep 10',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDiktX9fOLMawZcjgbQbAnJzHk3qTXmuRWtjRZM0nBqeQ71OSjLMARkJrxCRsW7S8W4xhQ6_GKJ8fWLIOG23-Q2vqDMeKDL1AIiUcSic2VFzFCj8AFpn_03VwQYZ8vbrozy3FEtBGUbRQicbD6IgvDmteHYZowPqHPtRBaPyoniS_ZY8DdineMGq5xMHrvyRBiBTErrQjyGRJbTeM2bp1qFybv82bmS0zKtbTqpaYbPWBFPEaWgV78wvoa9Kb_geHED7XcDjN5R6imK',
      'progress': 0.95,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CurrentlyWatchingHeader(),
        SizedBox(height: AppSpacing.lg),
        _CurrentlyWatchingList(items: _mockItems),
      ],
    );
  }
}


class _CurrentlyWatchingHeader extends StatelessWidget {
  const _CurrentlyWatchingHeader();

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
            'Currently Watching',
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

class _CurrentlyWatchingList extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const _CurrentlyWatchingList({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, index) {
          final item = items[index];
          return WatchingCard(
            title: item['title'] as String,
            subtitle: item['subtitle'] as String,
            imageUrl: item['imageUrl'] as String,
            progress: item['progress'] as double,
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


// --- Upcoming Episodes Section ---
class UpcomingEpisodesSection extends StatelessWidget {
  const UpcomingEpisodesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // TODO: add specific container tokens to AppColors for these grey surfaces
    final containerColor = isDark
        ? const Color(0xFF1C1B20)
        : const Color(0xFFF5F5F5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Episodes',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _mockEpisodes.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = _mockEpisodes[index];
              return _UpcomingEpisodeItem(
                title: item['title'] as String,
                subtitle: item['subtitle'] as String,
                time: item['time'] as String,
                timeColor: (item['id'] == 'tonight')
                    ? colors.primary
                    : colors.onSurfaceSecondary,
                imageUrl: item['imageUrl'] as String,
                containerColor: containerColor,
              );
            },
          ),
        ],
      ),
    );
  }

  // Mock Data
  static const _mockEpisodes = [
    {
      'id': 'tonight',
      'title': 'Fallout',
      'subtitle': 'Episode 1 • The End',
      'time': 'TONIGHT • 9:00 PM',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAfwd-EUi-ltAtA-Vm4Azpwt4WFOQR4999iERlxF4hId-Egawd1Zp9z8RRH19fVEUBCKC1H_RQpueIMWil-tEl1tfCBS0SuLN_XPnpMjj0fRtEsU7P_SvclIfxILEurZckDKgybRSFbjwFrM_P20izYagld88Q0j9dBzpZrJCAg018xtKqOA7RIEGzxsukDbavxow50_bzSwLiybsiMDqPDRJnNLZ53jTJEv5bvd7HTXrj3aVDaWK0OOTIB2YhWawkrHl4mbGMGvhzX',
    },
    {
      'id': 'tomorrow',
      'title': 'The Bear',
      'subtitle': 'Season 3 • Ep 1',
      'time': 'TOMORROW',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBFCHeHpxpQXNBIBRGoQusxsqmRdu5UBOvO9R3CFq5yjhvE8eYJBizFFzeqC_bcVOFPiIz2Ig54tAyDBGxBnE5LnWWemMmN28k5nOCIeE5Mn8X7RIUKzVqQU1jTffeZcTTgQ8VZc_lvBgvzjL_jhuaNE1juYWWzO3Xo7a-Zrldn_9mq-wZFeCX8tC6qxybbKF0mXqwg1JwRG1iQTUD5SQH38NSNHRUDLW8TipgD5g7_fvj-oPxOudXSCW4UK2vmby-Cim9-mAFcvXy5',
    },
    {
      'id': 'future',
      'title': 'Severance',
      'subtitle': 'Season 2 • Ep 1',
      'time': 'OCT 24',
      'imageUrl':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDwimj14jySerJlwAITl0OVFugN0UsPfFfhV8-vKCUrEVlY3jAg9X6ARXtMUBWcAuwSmb750PLbXU6cQRycKckoyf1FgDq12yHSRmpHgBQMbVyBe-NDIKlwMag7jkCRBxZBcgm7ddUR0TnUe_VIiNPU402SO44nIgU3tD2HScykNfBU7QBOc5gZA8g_UqOtqk6WVtggBd7cddlaYTdhjJnv_fQOSc_N05v03CzhlV7qEIBLiwREcMDZhazNfZvhenEJEC8p-Rt2EtZ_',
    },
  ];
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
            child: Image.network(
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


// --- Curated for You Section (Simplified Bento) ---
class CuratedSection extends StatelessWidget {
  const CuratedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // TODO: add specific container tokens to AppColors for these grey surfaces
    final containerColorLow = isDark
        ? const Color(0xFF1C1B20)
        : const Color(0xFFF5F5F5);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CuratedSectionHeader(),
          const SizedBox(height: AppSpacing.md),
          const _FeaturedBentoCard(),
          const SizedBox(height: AppSpacing.md),
          _SuccessionBentoCard(containerColor: containerColorLow),
          const SizedBox(height: AppSpacing.md),
          _TrendingTopRatedRow(containerColor: containerColorLow),
        ],
      ),
    );
  }
}

class _CuratedSectionHeader extends StatelessWidget {
  const _CuratedSectionHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Text(
      'Curated for You',
      style: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
    );
  }
}

class _FeaturedBentoCard extends StatelessWidget {
  const _FeaturedBentoCard();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        image: const DecorationImage(
          // Mock Data
          image: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuByaZwHXenriTfWuTYiTAZfQyzu_OaikS8eqo8MFge03eUoeF_BuAnbYV841d6LJyyObw93di6M5hPESYxL16fYR1e03wOQ3kp5cxhA-PIfVX2QYmuQuXGloYtLAS22cHz8wJVIubKcwI7M4zabQK_dQCeTKKfZFq_NyusXLE4Nw-4zJxbGeY19OHcA5Mwc9vcXNgVCOf_Z-sHSq6-ARz_RSsK0fXBdIjQcaccY0itIUmtT6Nz8v38O3qMNMXCRy66wUSQlTP1JrSRY',
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
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _FeaturedBentoTags(),
            SizedBox(height: AppSpacing.md),
            _FeaturedBentoContent(),
            SizedBox(height: AppSpacing.lg),
            _FeaturedBentoButton(),
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
            color: const Color(0xFFB55800), // TODO: add token
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'MUST WATCH',
            style: textTheme.labelSmall?.copyWith(
              color: const Color(0xFFFFF7F4), // TODO: add token
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
                ? const Color(0xFF36343A) // TODO: add token
                : const Color(0xFFE0E0E0), // TODO: add token
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            'SCI-FI',
            style: textTheme.labelSmall?.copyWith(
              color: isDark
                  ? const Color(0xFFCAC3D8) // TODO: add token
                  : const Color(0xFF4A4264), // TODO: add token
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
  const _FeaturedBentoContent();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'The Expanse',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Experience the ultimate political thriller set in the cold depths of space.',
          style: textTheme.bodySmall?.copyWith(
            color: const Color(0xFFCAC3D8), // TODO: add token
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


class _SuccessionBentoCard extends StatelessWidget {
  final Color containerColor;

  const _SuccessionBentoCard({required this.containerColor});

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Succession',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Family politics at its most brutal.',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceSecondary,
                ),
              ),
            ],
          ),
          Text(
            '8.9',
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
