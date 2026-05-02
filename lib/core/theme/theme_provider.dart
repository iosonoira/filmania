import '../l10n/app_localizations_provider.dart';
import 'app_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _themeKey = 'app_theme_mode';

  @override
  AppThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedTheme = prefs.getString(_themeKey);
    
    if (savedTheme != null) {
      return AppThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => AppThemeMode.dark,
      );
    }
    return AppThemeMode.dark;
  }

  Future<void> setMode(AppThemeMode mode) async {
    final prefs = ref.watch(sharedPreferencesProvider);
    await prefs.setString(_themeKey, mode.name);
    state = mode;
  }

  Future<void> toggle() async {
    final newMode = state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    await setMode(newMode);
  }
}
