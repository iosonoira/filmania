import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';

class GlassmorphicAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const GlassmorphicAppBar({
    super.key,
    this.showBackButton = false,
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
