import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/features/tv_series/ui/widgets/tv_series_widgets.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_episode.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/watched/ui/providers/watched_providers.dart';

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

Widget _wrap({bool isWatched = false}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      watchedEpisodesProvider(1).overrideWith(
        (ref) => Stream.value(isWatched ? ['s1e1'] : []),
      ),
      isEpisodeWatchedProvider(
        seriesId: 1,
        seasonNumber: 1,
        episodeNumber: 1,
      ).overrideWith((ref) => Future.value(isWatched)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: Scaffold(
        body: EpisodeCard(
          episode: _episode,
          tvId: 1,
          seriesTitle: 'Game of Thrones',
          seriesPosterPath: null,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('EpisodeCard renders a toggle button when episode is not watched', (tester) async {
    await tester.pumpWidget(_wrap(isWatched: false));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
  });

  testWidgets('EpisodeCard renders a filled check icon when episode is watched', (tester) async {
    await tester.pumpWidget(_wrap(isWatched: true));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(2));
  });
}
