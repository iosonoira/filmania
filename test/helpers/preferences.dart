import 'package:shared_preferences/shared_preferences.dart';

/// Empty preferences for `sharedPreferencesProvider`.
///
/// Every widget that shows translated text reads the locale, and the locale
/// lives in SharedPreferences, so widget tests must override the provider
/// that `main.dart` fills in at startup. Empty preferences give the app's
/// default locale (Italian).
Future<SharedPreferences> emptyPreferences() async {
  SharedPreferences.setMockInitialValues({});
  return SharedPreferences.getInstance();
}
