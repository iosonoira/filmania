import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/core/router/app_router.dart';

class GlassmorphicAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final List<Widget>? actions;
  final bool showProfileIcon;
  final bool minimal;

  const GlassmorphicAppBar({
    super.key,
    this.showBackButton = false,
    this.actions,
    this.showProfileIcon = true,
    this.minimal = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  if (!minimal)
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
              if (!minimal)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (actions != null) ...actions!,
                    if (showProfileIcon) const _ProfileAvatarButton(),
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

class _ProfileAvatarButton extends ConsumerWidget {
  const _ProfileAvatarButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final authState = ref.watch(authStateProvider);
    final photoUrl = authState.value?.photoUrl;

    return Semantics(
      label: 'Profilo',
      button: true,
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.profile),
        child: Container(
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
          child: photoUrl != null && photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Icon(Icons.person, color: colors.primary),
                )
              : Icon(Icons.person, color: colors.primary),
        ),
      ),
    );
  }
}
