import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/ui/core/ui/media_grid_card.dart';
import 'package:filmania/data/repositories/watchlist/watchlist_providers.dart';
import 'package:filmania/data/repositories/auth/auth_providers.dart';
import 'package:filmania/ui/core/view_models/is_media_watched.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filmania/l10n/app_localizations_provider.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';
import '../../../helpers/preferences.dart';

Widget _wrap(SharedPreferences prefs, {required bool isInWatchlist}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      isMediaInWatchlistProvider(
        1,
        MediaType.movie,
      ).overrideWith((ref) => Future.value(isInWatchlist)),
      isMediaWatchedProvider(
        mediaId: 1,
        mediaType: MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: MediaGridCard(
          mediaId: 1,
          title: 'Test Movie',
          posterUrl: null,
          posterPath: null,
          releaseYear: '2024',
          voteAverage: 7.5,
          mediaType: MediaType.movie,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows outlined bookmark icon when not in watchlist', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(await emptyPreferences(), isInWatchlist: false),
    );
    await tester.pump();

    expect(find.byIcon(Icons.bookmark_add_outlined), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_rounded), findsNothing);
  });

  testWidgets('shows filled bookmark icon when in watchlist', (tester) async {
    await tester.pumpWidget(
      _wrap(await emptyPreferences(), isInWatchlist: true),
    );
    await tester.pump();

    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_add_outlined), findsNothing);
  });
}
