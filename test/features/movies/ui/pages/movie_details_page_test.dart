import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/favorites/ui/providers/favorites_providers.dart';
import 'package:filmania/features/watchlist/ui/providers/watchlist_providers.dart';
import 'package:filmania/features/watched/ui/providers/watched_providers.dart';
import 'package:filmania/features/movies/domain/entities/movie.dart';
import 'package:filmania/features/movies/ui/providers/movies_provider.dart';
import 'package:filmania/features/movies/ui/pages/movie_details_page.dart';

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

Widget _buildSubject() {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      movieDetailsProvider(42).overrideWith((ref) async => _movie),
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
    await tester.pumpWidget(_buildSubject());
    await tester.pump();
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
  });
}
