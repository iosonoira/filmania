import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

// --- Reusable Glassmorphism Widget ---
class GlassOverlay extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final Color? color;
  final double sigma;

  const GlassOverlay({
    super.key,
    required this.child,
    this.borderRadius,
    this.color,
    this.sigma = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          color: color ?? AppColors.of(context).background.withValues(alpha: 0.8),
          child: child,
        ),
      ),
    );
  }
}

// --- Top App Bar ---
class GlassmorphicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GlassmorphicAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return GlassOverlay(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAg65sVztpdXhKS87ibQl8tebp1L1qq99AOyhFPOOgNHO9SUE7c8M9N-Pmt6Pk-MuQQyR97gRJsdVz01XAT0Ulr-ctCeuUdQxfTfM7cLee2zYtbF1SQ7CqTKKPkWQFaiKFh-c1qorZu8fGn-ZRCIMX4eX20WpAU15JTUk8OlvGsCcqSVSdpHH3ALWmFDtA31AcVWJjFG4d4nzibyffFkN_c_HofrLvbigWpH5YqBJL4uTUvCSfqGGMeMZfMy210EcVL6ZtoDuuc28mx',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Filmania',
                    style: textTheme.titleLarge?.copyWith(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
                color: colors.primary,
                splashColor: colors.primary.withValues(alpha: 0.1),
                highlightColor: colors.primary.withValues(alpha: 0.1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + AppSpacing.md * 2);
}

// --- Currently Watching Section ---
class CurrentlyWatchingSection extends StatelessWidget {
  const CurrentlyWatchingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);

    // Mock Data
    final items = [
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
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
        ),
      ],
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
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [colors.background.withValues(alpha: 0.9), Colors.transparent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
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
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Progress Bar
              Stack(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Upcoming Episodes Section ---
class UpcomingEpisodesSection extends StatelessWidget {
  const UpcomingEpisodesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerColor = isDark
        ? const Color(0xFF1C1B20)
        : const Color(0xFFF5F5F5);

    final items = [
      {
        'title': 'Fallout',
        'subtitle': 'Episode 1 • The End',
        'time': 'TONIGHT • 9:00 PM',
        'timeColor': AppColors.primary,
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAfwd-EUi-ltAtA-Vm4Azpwt4WFOQR4999iERlxF4hId-Egawd1Zp9z8RRH19fVEUBCKC1H_RQpueIMWil-tEl1tfCBS0SuLN_XPnpMjj0fRtEsU7P_SvclIfxILEurZckDKgybRSFbjwFrM_P20izYagld88Q0j9dBzpZrJCAg018xtKqOA7RIEGzxsukDbavxow50_bzSwLiybsiMDqPDRJnNLZ53jTJEv5bvd7HTXrj3aVDaWK0OOTIB2YhWawkrHl4mbGMGvhzX',
      },
      {
        'title': 'The Bear',
        'subtitle': 'Season 3 • Ep 1',
        'time': 'TOMORROW',
        'timeColor': AppColors.of(context).onSurfaceSecondary,
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBFCHeHpxpQXNBIBRGoQusxsqmRdu5UBOvO9R3CFq5yjhvE8eYJBizFFzeqC_bcVOFPiIz2Ig54tAyDBGxBnE5LnWWemMmN28k5nOCIeE5Mn8X7RIUKzVqQU1jTffeZcTTgQ8VZc_lvBgvzjL_jhuaNE1juYWWzO3Xo7a-Zrldn_9mq-wZFeCX8tC6qxybbKF0mXqwg1JwRG1iQTUD5SQH38NSNHRUDLW8TipgD5g7_fvj-oPxOudXSCW4UK2vmby-Cim9-mAFcvXy5',
      },
      {
        'title': 'Severance',
        'subtitle': 'Season 2 • Ep 1',
        'time': 'OCT 24',
        'timeColor': AppColors.of(context).onSurfaceSecondary,
        'imageUrl':
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDwimj14jySerJlwAITl0OVFugN0UsPfFfhV8-vKCUrEVlY3jAg9X6ARXtMUBWcAuwSmb750PLbXU6cQRycKckoyf1FgDq12yHSRmpHgBQMbVyBe-NDIKlwMag7jkCRBxZBcgm7ddUR0TnUe_VIiNPU402SO44nIgU3tD2HScykNfBU7QBOc5gZA8g_UqOtqk6WVtggBd7cddlaYTdhjJnv_fQOSc_N05v03CzhlV7qEIBLiwREcMDZhazNfZvhenEJEC8p-Rt2EtZ_',
      },
    ];

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
            itemCount: items.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item['imageUrl'] as String,
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
                            item['time'] as String,
                            style: textTheme.labelSmall?.copyWith(
                              color: item['timeColor'] as Color,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['title'] as String,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Manrope',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['subtitle'] as String,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.of(context).onSurfaceSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.bookmark_add_outlined,
                        color: AppColors.of(context).onSurfaceSecondary,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              );
            },
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
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerColorLow = isDark
        ? const Color(0xFF1C1B20)
        : const Color(0xFFF5F5F5);

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
          // Large Bento
          Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              image: const DecorationImage(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
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
                          'MUST WATCH',
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
                          'SCI-FI',
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
                  ),
                  const SizedBox(height: AppSpacing.md),
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
                      color: const Color(0xFFCAC3D8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text('Add to Watchlist'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Small Bento
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: containerColorLow,
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
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: containerColorLow,
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                    border: Border.all(
                      color: colors.onSurfaceSecondary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        color: colors.primary,
                        size: 32,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Trending',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'New this week',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: containerColorLow,
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                    border: Border.all(
                      color: colors.onSurfaceSecondary.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.tertiary,
                        size: 32,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Top Rated',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'All-time classics',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
    final textTheme = Theme.of(context).textTheme;

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
          child: Row(
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
          ),
        ),
      ),
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

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
    );
  }
}
