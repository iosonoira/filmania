import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import '../../../auth/ui/providers/auth_notifier.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).padding.top + AppSpacing.xl * 2),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.2),
                        width: 4,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAg65sVztpdXhKS87ibQl8tebp1L1qq99AOyhFPOOgNHO9SUE7c8M9N-Pmt6Pk-MuQQyR97gRJsdVz01XAT0Ulr-ctCeuUdQxfTfM7cLee2zYtbF1SQ7CqTKKPkWQFaiKFh-c1qorZu8fGn-ZRCIMX4eX20WpAU15JTUk8OlvGsCcqSVSdpHH3ALWmFDtA31AcVWJjFG4d4nzibyffFkN_c_HofrLvbigWpH5YqBJL4uTUvCSfqGGMeMZfMy210EcVL6ZtoDuuc28mx',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Filmania',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      fontFamily: 'Manrope',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'admin@filmania.app',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CompactStat(label: 'Watched', value: '184'),
                      SizedBox(width: AppSpacing.lg),
                      _CompactStat(label: 'Reviews', value: '42'),
                      SizedBox(width: AppSpacing.lg),
                      _CompactStat(label: 'Followers', value: '1.2k'),
                    ],
                  ),
                   const SizedBox(height: AppSpacing.xxl),
                  _ActionTile(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                   _ActionTile(
                    icon: Icons.history_rounded,
                    label: 'History',
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ActionTile(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                   const SizedBox(height: AppSpacing.xl),
                  OutlinedButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                    ),
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            ),
          ),
           const SliverToBoxAdapter(
            child: SizedBox(height: 140),
          ),
        ],
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  final String label;
  final String value;

  const _CompactStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = AppColors.of(context);
    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: colors.onSurfaceSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      label: label,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.onSurfacePrimary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.onSurfacePrimary.withValues(alpha: 0.08)),
          ),
          child: Row(
            children: [
              Icon(icon, color: colors.onSurfacePrimary),
              const SizedBox(width: AppSpacing.md),
              Text(
                label,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: colors.onSurfaceSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
