import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';

class GlassmorphicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const GlassmorphicAppBar({
    super.key,
    this.showBackButton = false,
  });

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
                  if (showBackButton) ...[
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: colors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
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
              Semantics(
                label: 'Notifiche',
                button: true,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                  color: colors.primary,
                  splashColor: colors.primary.withValues(alpha: 0.1),
                  highlightColor: colors.primary.withValues(alpha: 0.1),
                ),
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
