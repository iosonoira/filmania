import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/recommendations_section.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('hides when itemCount is zero', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: RecommendationsSection(
            title: 'Consigliati',
            itemCount: 0,
            itemBuilder: _unusedBuilder,
          ),
        ),
      ),
    );

    expect(find.text('Consigliati'), findsNothing);
  });

  testWidgets('renders title and tapping an item navigates', (tester) async {
    final router = GoRouter(
      initialLocation: '/movie/1',
      routes: [
        GoRoute(
          path: '/movie/1',
          builder: (context, state) => Scaffold(
            body: RecommendationsSection(
              title: 'Consigliati',
              itemCount: 2,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => context.push('/movie/${index + 100}'),
                child: Text('Item $index'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/movie/:id',
          builder: (context, state) =>
              Scaffold(body: Text('Movie ${state.pathParameters['id']}')),
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

    expect(find.text('Consigliati'), findsOneWidget);

    await tester.tap(find.text('Item 0'));
    await tester.pumpAndSettle();

    expect(find.text('Movie 100'), findsOneWidget);
  });
}

Widget _unusedBuilder(BuildContext context, int index) => const SizedBox();
