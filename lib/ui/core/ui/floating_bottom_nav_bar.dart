import 'package:flutter/material.dart';
import 'package:filmania/ui/core/themes/app_colors.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/ui/core/ui/glass_overlay.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';

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

    // Equal-width slots: English labels ("DISCOVER", "WATCHLIST") are longer
    // than the Italian ones and overflowed the row at phone width.
    return Row(
      children: [
        Expanded(
          child: _NavBarItem(
            icon: Icons.home_outlined,
            label: AppLocalizations.of(context)!.navHome,
            isSelected: currentIndex == 0,
            color: colors.onSurfaceSecondary,
            textTheme: textTheme,
            onTap: () => onDestinationSelected(0),
          ),
        ),
        Expanded(
          child: _NavBarItem(
            icon: Icons.explore_outlined,
            label: AppLocalizations.of(context)!.navDiscover,
            isSelected: currentIndex == 1,
            color: colors.onSurfaceSecondary,
            textTheme: textTheme,
            onTap: () => onDestinationSelected(1),
          ),
        ),
        Expanded(
          child: _NavBarItem(
            icon: Icons.bookmark_border_rounded,
            label: AppLocalizations.of(context)!.navWatchlist,
            isSelected: currentIndex == 2,
            color: colors.onSurfaceSecondary,
            textTheme: textTheme,
            onTap: () => onDestinationSelected(2),
          ),
        ),
        Expanded(
          child: _NavBarItem(
            icon: Icons.person_outline_rounded,
            label: AppLocalizations.of(context)!.navProfile,
            isSelected: currentIndex == 3,
            color: colors.onSurfaceSecondary,
            textTheme: textTheme,
            onTap: () => onDestinationSelected(3),
          ),
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
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
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  style: textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? itemColor
                        : color.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
