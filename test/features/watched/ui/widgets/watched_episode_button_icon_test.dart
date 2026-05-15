import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/features/watched/ui/widgets/watched_episode_button.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/watched/ui/providers/watched_providers.dart';

Widget _buildSubject({bool isWatched = false}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      isEpisodeWatchedProvider(
        seriesId: 1,
        seasonNumber: 1,
        episodeNumber: 1,
      ).overrideWith((ref) => Future.value(isWatched)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: const Scaffold(
        body: Center(
          child: WatchedEpisodeButton(
            isIconOnly: true,
            seriesId: 1,
            seasonNumber: 1,
            episodeNumber: 1,
            seriesTitle: 'Test Series',
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('isIconOnly shows check_circle_outline_rounded when not watched', (tester) async {
    await tester.pumpWidget(_buildSubject(isWatched: false));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
  });

  testWidgets('isIconOnly shows check_circle_rounded when watched', (tester) async {
    await tester.pumpWidget(_buildSubject(isWatched: true));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsNothing);
  });
}
