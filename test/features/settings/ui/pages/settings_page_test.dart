import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/l10n/app_localizations_provider.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';
import 'package:filmania/features/settings/ui/pages/settings_page.dart';

Widget _wrap(SharedPreferences prefs) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SettingsPage()),
    ],
  );

  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: MaterialApp.router(
      theme: AppTheme.dark(),
      locale: const Locale('it'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  testWidgets('renders a sign-out button', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(_wrap(prefs));
    await tester.pumpAndSettle();

    expect(find.text('Esci'), findsOneWidget);
  });
}
