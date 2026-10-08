import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/ui/core/themes/app_theme.dart';
import 'package:filmania/domain/models/cast_member.dart';
import 'package:filmania/ui/core/ui/cast_section.dart';
import 'package:filmania/l10n/generated/app_localizations.dart';

const _cast = [
  CastMember(
    id: 500,
    name: 'Uma Thurman',
    character: 'The Bride',
    profilePath: null,
  ),
];

void main() {
  testWidgets('tapping a cast card navigates to /person/:id', (tester) async {
    final router = GoRouter(
      initialLocation: '/movie/1',
      routes: [
        GoRoute(
          path: '/movie/1',
          builder: (context, state) =>
              const Scaffold(body: CastSection(cast: _cast)),
        ),
        GoRoute(
          path: '/person/:id',
          builder: (context, state) =>
              Scaffold(body: Text('Person ${state.pathParameters['id']}')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Uma Thurman'));
    await tester.pumpAndSettle();

    expect(find.text('Person 500'), findsOneWidget);
  });
}
