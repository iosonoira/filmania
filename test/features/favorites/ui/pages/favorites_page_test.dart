import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/favorites/domain/entities/favorite_item.dart';
import 'package:filmania/features/favorites/ui/providers/favorites_providers.dart';
import 'package:filmania/features/favorites/ui/pages/favorites_page.dart';

Widget _buildSubject(List<FavoriteItem> items) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      favoritesProvider.overrideWith((ref) => Stream.value(items)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const FavoritesPage(),
    ),
  );
}

void main() {
  testWidgets('shows empty state when there are no favorites', (tester) async {
    await tester.pumpWidget(_buildSubject(const []));
    await tester.pump();
    expect(find.text('No favorites'), findsOneWidget);
  });

  testWidgets('shows one card per favorite item', (tester) async {
    final items = [
      FavoriteItem(
        id: '1',
        userId: 'u1',
        mediaId: 42,
        mediaTitle: 'Test Movie',
        mediaType: MediaType.movie,
        posterPath: null,
        createdAt: DateTime(2026, 1, 1),
      ),
      FavoriteItem(
        id: '2',
        userId: 'u1',
        mediaId: 7,
        mediaTitle: 'Test Series',
        mediaType: MediaType.tv,
        posterPath: null,
        createdAt: DateTime(2026, 1, 1),
      ),
    ];
    await tester.pumpWidget(_buildSubject(items));
    await tester.pump();
    expect(find.text('Test Movie'), findsOneWidget);
    expect(find.text('Test Series'), findsOneWidget);
    expect(find.text('No favorites'), findsNothing);
  });
}
