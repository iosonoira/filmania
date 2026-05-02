import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/core/theme/theme_provider.dart';
import 'package:filmania/core/l10n/app_localizations_provider.dart';

class GlassmorphicAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final List<Widget>? actions;

  const GlassmorphicAppBar({
    super.key,
    this.showBackButton = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final l10n = ref.watch(appLocalizationsProvider);
    final themeMode = ref.watch(themeModeProvider);

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
                      color: colors.primary.withValues(alpha: 0.1),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Builder(
                      builder: (context) {
                        final authState = ref.watch(authStateProvider);
                        final photoUrl = authState.value?.photoUrl;
                        return photoUrl != null && photoUrl.isNotEmpty
                            ? Image.network(
                                photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => Icon(Icons.person, color: colors.primary),
                              )
                            : Icon(Icons.person, color: colors.primary);
                      },
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (actions != null) ...actions!,
                  Semantics(
                    label: l10n.toggleTheme,
                    button: true,
                    child: IconButton(
                      onPressed: () =>
                          ref.read(themeModeProvider.notifier).toggle(),
                      icon: Icon(
                        themeMode != AppThemeMode.light
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                      ),
                      color: colors.primary,
                      tooltip: l10n.toggleTheme,
                      splashColor: colors.primary.withValues(alpha: 0.1),
                      highlightColor: colors.primary.withValues(alpha: 0.1),
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

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + AppSpacing.md * 2);
}
