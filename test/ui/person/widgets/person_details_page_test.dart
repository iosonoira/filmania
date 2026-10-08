import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';
import 'package:filmania/domain/models/person.dart';
import 'package:filmania/domain/models/person_credit.dart';
import 'package:filmania/ui/person/widgets/person_details_page.dart';
import 'package:filmania/data/repositories/person/person_providers.dart';
import 'package:filmania/data/repositories/watchlist/watchlist_providers.dart';
import 'package:filmania/data/repositories/auth/auth_providers.dart';
import 'package:filmania/ui/core/view_models/is_media_watched.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filmania/l10n/app_localizations_provider.dart';
import '../../../helpers/preferences.dart';

const _person = Person(
  id: 138,
  name: 'Quentin Tarantino',
  biography: 'American filmmaker.',
  birthday: null,
  placeOfBirth: 'Knoxville, Tennessee, USA',
  profilePath: null,
);

const _credits = [
  PersonCredit(
    mediaId: 680,
    title: 'Pulp Fiction',
    posterPath: null,
    releaseYear: 1994,
    voteAverage: 8.5,
    mediaType: MediaType.movie,
  ),
];

Widget _wrap(SharedPreferences prefs) {
  final router = GoRouter(
    initialLocation: '/person/138',
    routes: [
      GoRoute(
        path: '/person/:id',
        builder: (context, state) => const PersonDetailsPage(personId: 138),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      personDetailsProvider(138).overrideWith((ref) => Future.value(_person)),
      personFilmographyProvider(
        138,
      ).overrideWith((ref) => Future.value(_credits)),
      isMediaInWatchlistProvider(
        680,
        MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
      isMediaWatchedProvider(
        mediaId: 680,
        mediaType: MediaType.movie,
      ).overrideWith((ref) => Future.value(false)),
    ],
    child: MaterialApp.router(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('shows person name, place of birth and biography', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(await emptyPreferences()));
    await tester.pumpAndSettle();

    expect(find.text('Quentin Tarantino'), findsOneWidget);
    expect(find.textContaining('Knoxville, Tennessee, USA'), findsOneWidget);
    expect(find.text('American filmmaker.'), findsOneWidget);
  });

  testWidgets('shows filmography credit title', (tester) async {
    await tester.pumpWidget(_wrap(await emptyPreferences()));
    await tester.pumpAndSettle();

    expect(find.text('Pulp Fiction'), findsOneWidget);
  });
}
