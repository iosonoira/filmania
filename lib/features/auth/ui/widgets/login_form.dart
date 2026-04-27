import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations_provider.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import '../../domain/failures/auth_failure.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authProvider.notifier).login(
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(authProvider);
    final isLoading = loginState is AsyncLoading;
    final colors = AppColors.of(context);
    final l10n = ref.watch(appLocalizationsProvider);

    // Rule: Use ref.listen for side-effects like snackbars (Rule 120 State Management)
    ref.listen(authProvider, (previous, next) {
      if (next case AsyncError(:final error)) {
        final message = switch (error) {
          InvalidCredentials() => error.message,
          EmailAlreadyInUse() => error.message,
          NetworkError() => l10n.networkErrorDesc,
          RateLimitExceeded() => error.message,
          _ => l10n.genericErrorDesc,
        };
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: colors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.md)),
          ),
        );
      }
    });

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: l10n.emailAddress,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
            validator: (value) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (value == null || !emailRegex.hasMatch(value)) {
                return l10n.enterValidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            decoration: InputDecoration(
              hintText: l10n.password,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 20,
                  color: colors.onSurfaceSecondary,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) =>
                (value?.length ?? 0) >= 6 ? null : l10n.min6Chars,
          ),
          const SizedBox(height: AppSpacing.xl),
          
          // Hero CTA styling from DESIGN.md
          Material(
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                gradient: const LinearGradient(
                  colors: [Color(0xFFCDBDFF), Color(0xFF7C4DFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.2),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSpacing.radius),
                onTap: isLoading ? null : _handleSubmit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md + 4),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            l10n.enterCinema,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          
          Center(
            child: TextButton(
              onPressed: isLoading ? null : () {},
              child: Text(l10n.forgotPassword),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.dontHavePass,
                style: TextStyle(color: colors.onSurfaceSecondary),
              ),
              TextButton(
                onPressed: isLoading ? null : () => context.go('/register'),
                child: Text(l10n.requestItHere),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
