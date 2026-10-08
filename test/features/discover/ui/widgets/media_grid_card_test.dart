import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/features/discover/ui/widgets/discover_widgets.dart';
import 'package:filmania/features/watchlist/ui/providers/watchlist_providers.dart';
import 'package:filmania/features/watched/ui/providers/watched_providers.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';

Widget _wrap({required bool isInWatchlist}) {
  return ProviderScope(
    overrides: [
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
    await tester.pumpWidget(_wrap(isInWatchlist: false));
    await tester.pump();

    expect(find.byIcon(Icons.bookmark_add_outlined), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_rounded), findsNothing);
  });

  testWidgets('shows filled bookmark icon when in watchlist', (tester) async {
    await tester.pumpWidget(_wrap(isInWatchlist: true));
    await tester.pump();

    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_add_outlined), findsNothing);
  });
}
