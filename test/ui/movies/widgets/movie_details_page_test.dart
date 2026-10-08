import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/data/repositories/favorites/favorites_providers.dart';
import 'package:filmania/data/repositories/watchlist/watchlist_providers.dart';
import 'package:filmania/domain/models/movie.dart';
import 'package:filmania/data/repositories/movies/movies_providers.dart';
import 'package:filmania/ui/movies/widgets/movie_details_page.dart';
import 'package:filmania/data/repositories/auth/auth_providers.dart';
import 'package:filmania/ui/core/view_models/is_media_watched.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filmania/l10n/app_localizations_provider.dart';
import '../../../helpers/preferences.dart';
import 'package:filmania/domain/models/credits.dart';

const _movie = Movie(
  id: 42,
  title: 'Test Movie',
  overview: 'overview',
  posterPath: null,
  backdropPath: null,
  releaseDate: null,
  voteAverage: 0,
  runtime: null,
);

Widget _buildSubject(SharedPreferences prefs) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      movieDetailsProvider(42).overrideWith((ref) async => _movie),
      // Without these the page would call TMDB for real, and Dio's pending
      // timers outlive the test.
      movieCreditsProvider(
        42,
      ).overrideWith((ref) async => const Credits(cast: [], crew: [])),
      movieRecommendationsProvider(42).overrideWith((ref) async => const []),
      isMediaFavoriteProvider(
        mediaId: 42,
        mediaType: MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
      isMediaInWatchlistProvider(
        42,
        MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
      isMediaWatchedProvider(
        mediaId: 42,
        mediaType: MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MovieDetailsPage(movieId: 42),
    ),
  );
}

void main() {
  testWidgets('shows a FavoriteButton (heart icon) on the detail page', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject(await emptyPreferences()));
    await tester.pump();
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
  });
}
