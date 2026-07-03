// test/features/favorites/ui/widgets/favorite_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/favorites/ui/widgets/favorite_button.dart';
import 'package:filmania/features/favorites/ui/providers/favorites_providers.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';

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
