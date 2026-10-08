import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:filmania/features/auth/ui/pages/login_page.dart';
import 'package:filmania/features/auth/ui/pages/register_page.dart';
import 'package:filmania/features/home/ui/pages/home_page.dart';
import 'package:filmania/ui/core/ui/main_scaffold.dart';
import 'package:filmania/features/discover/ui/pages/discover_page.dart';
import 'package:filmania/features/watchlist/ui/pages/watchlist_page.dart';
import 'package:filmania/features/profile/ui/pages/profile_page.dart';
import 'package:filmania/features/movies/ui/pages/movie_details_page.dart';
import 'package:filmania/features/tv_series/ui/pages/tv_series_details_page.dart';
import 'package:filmania/features/person/ui/pages/person_details_page.dart';
import 'package:filmania/features/watchlist/ui/pages/watchlist_detail_page.dart';
import 'package:filmania/features/watched/ui/pages/watched_list_page.dart';
import 'package:filmania/features/favorites/ui/pages/favorites_page.dart';
import 'package:filmania/features/tv_series/ui/pages/tv_episode_details_page.dart';
import 'package:filmania/features/movies/ui/pages/trending_movies_page.dart';
import 'package:filmania/features/tv_series/ui/pages/trending_tv_series_page.dart';
import 'package:filmania/features/settings/ui/pages/settings_page.dart';
import 'package:filmania/features/tvtime_import/ui/pages/tvtime_import_page.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/ui/core/ui/splash_page.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';
import 'package:filmania/data/repositories/auth/auth_providers.dart';

part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Route paths
// ---------------------------------------------------------------------------
abstract class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const discover = '/discover';
  static const watchlist = '/watchlist';
  static const profile = '/profile';
  static const movieDetails = '/movie/:id';
  static const tvDetails = '/tv/:id';
  static const personDetails = '/person/:id';
  static const watchlistDetail = '/watchlist/:id';
  static const watchedMovies = '/watched/movies';
  static const watchedTv = '/watched/tv';
  static const favorites = '/favorites';
  static const trendingMovies = '/trending/movies';
  static const trendingTv = '/trending/tv';
  static const settings = '/settings';
  static const importTvTime = '/settings/import-tvtime';
  static const tvEpisodeDetails =
      '/tv/:id/season/:seasonNumber/episode/:episodeNumber';

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
    initialLocation: AppRoutes.splash,
    refreshListenable: authListenable,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
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
          final rawId = state.pathParameters['id'];
          final id = rawId != null ? int.tryParse(rawId) : null;
          if (id == null) {
            return const _InvalidRoutePage();
          }
          return MovieDetailsPage(movieId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.tvDetails,
        builder: (context, state) {
          final rawId = state.pathParameters['id'];
          final id = rawId != null ? int.tryParse(rawId) : null;
          if (id == null) {
            return const _InvalidRoutePage();
          }
          return TVSeriesDetailsPage(seriesId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.personDetails,
        builder: (context, state) {
          final rawId = state.pathParameters['id'];
          final id = rawId != null ? int.tryParse(rawId) : null;
          if (id == null) {
            return const _InvalidRoutePage();
          }
          return PersonDetailsPage(personId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.tvEpisodeDetails,
        builder: (context, state) {
          final tvId = int.tryParse(state.pathParameters['id'] ?? '');
          final seasonNumber = int.tryParse(
            state.pathParameters['seasonNumber'] ?? '',
          );
          final episodeNumber = int.tryParse(
            state.pathParameters['episodeNumber'] ?? '',
          );

          if (tvId == null || seasonNumber == null || episodeNumber == null) {
            return const _InvalidRoutePage();
          }

          return TVEpisodeDetailsPage(
            tvId: tvId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.watchlistDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null) {
            return const _InvalidRoutePage();
          }
          return WatchlistDetailPage(watchlistId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.watchedMovies,
        builder: (context, state) =>
            const WatchedListPage(mediaType: MediaType.movie),
      ),
      GoRoute(
        path: AppRoutes.watchedTv,
        builder: (context, state) =>
            const WatchedListPage(mediaType: MediaType.tv),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: AppRoutes.trendingMovies,
        builder: (context, state) => const TrendingMoviesPage(),
      ),
      GoRoute(
        path: AppRoutes.trendingTv,
        builder: (context, state) => const TrendingTVSeriesPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.importTvTime,
        builder: (context, state) => const TvTimeImportPage(),
      ),
    ],
    redirect: (context, state) {
      final authAsync = ref.watch(authStateProvider);

      final isOnSplash = state.matchedLocation == AppRoutes.splash;
      final isOnLogin = state.matchedLocation == AppRoutes.login;
      final isOnRegister = state.matchedLocation == AppRoutes.register;
      final isAuthRoute = isOnLogin || isOnRegister;

      // While loading, stay on splash (no redirect).
      if (authAsync.isLoading) return isOnSplash ? null : AppRoutes.splash;

      // On error, treat as unauthenticated (go to login).
      if (authAsync.hasError) return AppRoutes.login;

      final isAuthenticated = authAsync.value != null;

      // Splash screen routing after auth state loads
      if (isOnSplash) {
        return isAuthenticated ? AppRoutes.home : AppRoutes.login;
      }

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

/// Shown when a details route gets an id that isn't a valid number (e.g. a
/// hand-typed or stale deep link).
class _InvalidRoutePage extends StatelessWidget {
  const _InvalidRoutePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(AppLocalizations.of(context)!.pageNotFound)),
    );
  }
}
