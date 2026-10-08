import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/ui/tv_series/widgets/tv_series_widgets.dart';
import 'package:filmania/domain/models/tv_episode.dart';
import 'package:filmania/data/repositories/watched/watched_providers.dart';
import 'package:filmania/data/repositories/auth/auth_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filmania/l10n/app_localizations_provider.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';
import 'package:filmania/ui/core/ui/selection/selection_scope.dart';
import 'package:filmania/ui/core/ui/selection/episode_selection_item.dart';
import '../../../helpers/preferences.dart';

const _episode = TVEpisode(
  id: 101,
  episodeNumber: 1,
  seasonNumber: 1,
  name: 'Winter Is Coming',
  overview: 'The story begins.',
  stillPath: null,
  voteAverage: 8.9,
  airDate: '2011-04-17',
  runtime: 62,
);

Widget _wrap(SharedPreferences prefs, {bool isWatched = false}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      isEpisodeWatchedProvider(
        seriesId: 1,
        seasonNumber: 1,
        episodeNumber: 1,
      ).overrideWith((ref) => Future.value(isWatched)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // The details page provides the selection scope for its episode cards.
      home: const SelectionScope<EpisodeSelectionItem>(
        child: Scaffold(
          body: EpisodeCard(
            episode: _episode,
            tvId: 1,
            seriesTitle: 'Game of Thrones',
            seriesPosterPath: null,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'EpisodeCard renders a toggle button when episode is not watched',
    (tester) async {
      await tester.pumpWidget(
        _wrap(await emptyPreferences(), isWatched: false),
      );
      await tester.pump();
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    },
  );

  testWidgets(
    'EpisodeCard renders a filled check icon when episode is watched',
    (tester) async {
      await tester.pumpWidget(_wrap(await emptyPreferences(), isWatched: true));
      await tester.pump();
      expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(2));
    },
  );

  testWidgets(
    'EpisodeCard does not show a vote star even when voteAverage > 0',
    (tester) async {
      await tester.pumpWidget(
        _wrap(await emptyPreferences(), isWatched: false),
      );
      await tester.pump();

      expect(find.byIcon(Icons.star_rounded), findsNothing);
      expect(find.text('8.9'), findsNothing);
    },
  );
}
