import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';

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

    // Rule: Use ref.listen for side-effects like snackbars (Rule 120 State Management)
    ref.listen(authProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: colors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            decoration: const InputDecoration(
              hintText: 'Indirizzo Email',
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
            validator: (value) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (value == null || !emailRegex.hasMatch(value)) {
                return 'Inserisci una email valida';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            obscureText: true,
            validator: (value) =>
                (value?.length ?? 0) >= 6 ? null : 'Minimo 6 caratteri',
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
                        : const Text(
                            'Entra nel Cinema',
                            style: TextStyle(
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
              child: const Text('Password dimenticata?'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Non hai un pass?',
                style: TextStyle(color: colors.onSurfaceSecondary),
              ),
              TextButton(
                onPressed: isLoading ? null : () => context.go('/register'),
                child: const Text('Richiedilo qui'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
