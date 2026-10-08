// test/ui/core/ui/favorite_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';
import 'package:filmania/ui/core/ui/favorite_button.dart';
import 'package:filmania/data/repositories/favorites/favorites_providers.dart';
import 'package:filmania/data/repositories/auth/auth_providers.dart';

Widget _buildSubject({bool isFavorite = false}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      isMediaFavoriteProvider(
        mediaId: 1,
        mediaType: MediaType.movie,
      ).overrideWith((ref) => Future.value(isFavorite)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: Center(
          child: FavoriteButton(
            mediaId: 1,
            mediaTitle: 'Test Movie',
            mediaType: MediaType.movie,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows favorite_border_rounded when not favorited', (
    tester,
  ) async {
    await tester.pumpWidget(_buildSubject(isFavorite: false));
    await tester.pump();
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_rounded), findsNothing);
  });

  testWidgets('shows favorite_rounded when favorited', (tester) async {
    await tester.pumpWidget(_buildSubject(isFavorite: true));
    await tester.pump();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
  });
}
