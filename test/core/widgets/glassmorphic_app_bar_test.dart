import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glassmorphic_app_bar.dart';
import 'package:filmania/core/router/app_router.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';

Widget _wrapWithRouter({required Widget appBarUnderTest}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          appBar: appBarUnderTest as PreferredSizeWidget,
          body: const SizedBox(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const Scaffold(body: Text('Profile Page')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [authStateProvider.overrideWith((ref) => Stream.value(null))],
    child: MaterialApp.router(theme: AppTheme.dark(), routerConfig: router),
  );
}

void main() {
  testWidgets('does not render a theme-toggle button', (tester) async {
    await tester.pumpWidget(
      _wrapWithRouter(appBarUnderTest: const GlassmorphicAppBar()),
    );
    await tester.pump();

    expect(find.byIcon(Icons.dark_mode_rounded), findsNothing);
    expect(find.byIcon(Icons.light_mode_rounded), findsNothing);
  });

  testWidgets('tapping the profile avatar navigates to AppRoutes.profile', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrapWithRouter(appBarUnderTest: const GlassmorphicAppBar()),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();

    expect(find.text('Profile Page'), findsOneWidget);
  });

  testWidgets('showProfileIcon: false hides the avatar', (tester) async {
    await tester.pumpWidget(
      _wrapWithRouter(
        appBarUnderTest: const GlassmorphicAppBar(showProfileIcon: false),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.person), findsNothing);
  });

  testWidgets(
    'minimal: true hides logo and avatar, keeps only the back button',
    (tester) async {
      await tester.pumpWidget(
        _wrapWithRouter(
          appBarUnderTest: const GlassmorphicAppBar(
            showBackButton: true,
            minimal: true,
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Filmania'), findsNothing);
      expect(find.byIcon(Icons.person), findsNothing);
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    },
  );
}
