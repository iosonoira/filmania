import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'core/env/env.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/l10n/app_localizations_provider.dart';
import 'core/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    final ThemeData theme;
    switch (themeMode) {
      case AppThemeMode.light:
        theme = AppTheme.light();
        break;
      case AppThemeMode.dark:
        theme = AppTheme.dark();
        break;
      case AppThemeMode.pureBlack:
        theme = AppTheme.pureBlack();
        break;
    }

    return MaterialApp.router(
      title: 'Filmania',
      debugShowCheckedModeBanner: false,
      theme: theme,
      // themeMode is set to the underlying brightness to help system components
      themeMode: themeMode == AppThemeMode.light ? ThemeMode.light : ThemeMode.dark,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
