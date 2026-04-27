import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/app_localizations.dart';

part 'app_localizations_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('sharedPreferences must be overridden in ProviderScope');
}

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  static const _localeKey = 'app_locale';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedLanguage = prefs.getString(_localeKey);
    // Return saved locale if exists, otherwise fallback to English
    if (savedLanguage != null) {
      return Locale(savedLanguage);
    }
    return const Locale('en');
  }

  Future<void> changeLocale(Locale newLocale) async {
    final prefs = ref.watch(sharedPreferencesProvider);
    await prefs.setString(_localeKey, newLocale.languageCode);
    state = newLocale;
  }
}

/// Provider that returns the current AppLocalizations mapping without BuildContext
@Riverpod(keepAlive: true)
AppLocalizations appLocalizations(Ref ref) {
  final locale = ref.watch(localeProvider);
  return lookupAppLocalizations(locale);
}
