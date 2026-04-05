
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/ui/pages/login_page.dart';
import '../../features/auth/ui/pages/register_page.dart';
import '../../features/auth/ui/providers/auth_notifier.dart';

part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Route paths
// ---------------------------------------------------------------------------
abstract class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
}

// ---------------------------------------------------------------------------
// Placeholder home page (replace when the Home feature is built)
// ---------------------------------------------------------------------------
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home')),
    );
  }
}

// ---------------------------------------------------------------------------
// Router provider
// ---------------------------------------------------------------------------
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Keep a listenable that refreshes the router whenever auth state changes.
  final authListenable = _AuthStateListenable(ref);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: authListenable,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const _HomePage(),
      ),
    ],
    redirect: (context, state) {
      final authAsync = ref.watch(authStateProvider);

      // While loading, don't redirect yet.
      if (authAsync.isLoading || authAsync.hasError) return null;

      final isAuthenticated = authAsync.value != null;
      final isOnLogin = state.matchedLocation == AppRoutes.login;
      final isOnRegister = state.matchedLocation == AppRoutes.register;
      final isAuthRoute = isOnLogin || isOnRegister;

      // Unauthenticated users can only be on login or register explicitly
      if (!isAuthenticated && !isAuthRoute) return AppRoutes.login;
      
      // Authenticated users should go to home
      if (isAuthenticated && isAuthRoute) return AppRoutes.home;

      return null; // No redirect needed.
    },
  );
}

// ---------------------------------------------------------------------------
// Helper: turns the authStateProvider stream into a ChangeNotifier so that
// GoRouter can listen to auth changes and re-evaluate its redirect logic.
// ---------------------------------------------------------------------------
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref ref) {
    ref.listen(authStateProvider, (_, _) => notifyListeners());
  }
}
