import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/widgets/glassmorphic_app_bar.dart';
import '../../../../core/l10n/app_localizations_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final l10n = ref.watch(appLocalizationsProvider);
    final currentLocale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const GlassmorphicAppBar(showBackButton: true),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top + kToolbarHeight + AppSpacing.xl,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  l10n.settingsTitle,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                    color: colors.onSurfacePrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                
                _SettingsSection(
                  title: l10n.appSection,
                  children: [
                    _SettingsTile(
                      icon: Icons.language_rounded,
                      title: l10n.language,
                      subtitle: currentLocale.languageCode == 'it' ? 'Italiano' : 'English',
                      onTap: () => _showLanguagePicker(context, ref, l10n),
                    ),
                    _SettingsTile(
                      icon: Icons.palette_rounded,
                      title: l10n.theme,
                      subtitle: _getThemeLabel(context, themeMode, l10n),
                      onTap: () => _showThemePicker(context, ref, l10n, themeMode),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                _SettingsSection(
                  title: l10n.infoSection,
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: l10n.version,
                      subtitle: '1.0.0 (BETA)',
                    ),
                    _SettingsTile(
                      icon: Icons.attribution_rounded,
                      title: l10n.dataSource,
                      subtitle: 'TMDB API',
                    ),
                  ],
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  String _getThemeLabel(BuildContext context, AppThemeMode mode, dynamic l10n) {
    switch (mode) {
      case AppThemeMode.light:
        return l10n.themeLight;
      case AppThemeMode.dark:
        return l10n.themeDark;
      case AppThemeMode.pureBlack:
        return l10n.themeMichele;
    }
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, dynamic l10n, AppThemeMode currentMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.of(context).background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.chooseTheme,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              leading: const Icon(Icons.light_mode_rounded),
              title: Text(l10n.themeLight),
              trailing: currentMode == AppThemeMode.light ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
              onTap: () {
                ref.read(themeModeProvider.notifier).setMode(AppThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode_rounded),
              title: Text(l10n.themeDark),
              trailing: currentMode == AppThemeMode.dark ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
              onTap: () {
                ref.read(themeModeProvider.notifier).setMode(AppThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.nightlight_round),
              title: Text(l10n.themeMichele),
              trailing: currentMode == AppThemeMode.pureBlack ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
              onTap: () {
                ref.read(themeModeProvider.notifier).setMode(AppThemeMode.pureBlack);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, dynamic l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.of(context).background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.chooseLanguage,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              title: const Text('Italiano'),
              onTap: () {
                ref.read(localeProvider.notifier).changeLocale(const Locale('it'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                ref.read(localeProvider.notifier).changeLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 12,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            boxShadow: [
               BoxShadow(
                color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.light ? 0.05 : 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ListTile(
      leading: Icon(icon, color: colors.onSurfacePrimary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: colors.onSurfaceSecondary)),
      trailing: onTap != null ? const Icon(Icons.chevron_right_rounded) : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radius)),
    );
  }
}
