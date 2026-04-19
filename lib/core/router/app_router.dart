import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/ui/pages/login_page.dart';
import '../../features/auth/ui/pages/register_page.dart';
import '../../features/auth/ui/providers/auth_notifier.dart';
import '../../features/home/ui/pages/home_page.dart';
import '../widgets/main_scaffold.dart';
import '../../features/discover/ui/pages/discover_page.dart';
import '../../features/watchlist/ui/pages/watchlist_page.dart';
import '../../features/profile/ui/pages/profile_page.dart';
import '../../features/movies/ui/pages/movie_details_page.dart';
import '../../features/tv_series/ui/pages/tv_series_details_page.dart';
import '../../features/watchlist/ui/pages/watchlist_detail_page.dart';

part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Route paths
// ---------------------------------------------------------------------------
abstract class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const discover = '/discover';
  static const watchlist = '/watchlist';
  static const profile = '/profile';
  static const movieDetails = '/movie/:id';
  static const tvDetails = '/tv/:id';
  static const watchlistDetail = '/watchlist/:id';

  static const shellRoutes = [home, discover, watchlist, profile];
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
      
      // Main Application Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.discover,
                builder: (context, state) => const DiscoverPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.watchlist,
                builder: (context, state) => const WatchlistPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.movieDetails,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return MovieDetailsPage(movieId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.tvDetails,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TVSeriesDetailsPage(seriesId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.watchlistDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return WatchlistDetailPage(watchlistId: id);
        },
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
