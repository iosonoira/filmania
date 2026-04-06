import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/login_form.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.xxxl + AppSpacing.xl,
            AppSpacing.xl,
            AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Editorial Branding: Filmania
              Text.rich(
                TextSpan(
                  text: 'Fil',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                    height: 1.0,
                    color: colors.onSurfacePrimary,
                  ),
                  children: [
                    TextSpan(
                      text: 'mania.',
                      style: TextStyle(color: colors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Cura la tua galleria personale\ndi opere cinematografiche.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.onSurfaceSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              
              // Container with depth as per DESIGN.md
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppSpacing.radius + 8),
                ),
                child: const LoginForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
