# Quick UI Fixes (Sections A, B, C, E, H) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship 6 independent, low-risk UI fixes: top bar rework (theme toggle removed, profile avatar moved right + tappable, `showProfileIcon`/`minimal` params), move the sign-out button from Profile to Settings, fix two hardcoded Italian labels, make the watchlist bookmark icon in `MediaGridCard` reactive, and remove the vote display from episode cards.

**Architecture:** Pure UI-layer edits inside existing widgets. No new providers, no new routes, no backend changes. `GlassmorphicAppBar` (in `core/widgets/`) gains two new constructor params; every call site is updated to match the section-A spec. One new l10n key (`accountSection`) is added for the relocated sign-out section.

**Tech Stack:** Flutter, Riverpod (`@riverpod` codegen — no new providers needed here, only consuming existing `authStateProvider` and `isMediaInWatchlistProvider`), go_router, `flutter_test` widget tests.

## Global Constraints

- Colors: always `AppColors.of(context)`, never `Theme.of(context).colorScheme` / `Colors.black` / hex literals (except pre-existing `Colors.white`/`Colors.black.withValues(alpha:)` usages already in the touched files — do not introduce new raw colors).
- Spacing: always `AppSpacing` tokens, never raw doubles for padding.
- No 1px borders/dividers (No-Line Rule) — none of these tasks add borders.
- `const` everywhere a widget/value can be `const`.
- Widget `build()` max 50 lines; extract private widgets, not private methods returning `Widget`.
- No cross-feature imports — `core/widgets/glassmorphic_app_bar.dart` may import `core/router`, `core/theme`, and the `features/auth` provider it already depends on (pre-existing pattern), but must not start importing from `features/profile`, `features/settings`, etc.
- `ref.watch` only inside `build()`; `ref.read` only inside callbacks.
- Run `dart analyze` and `dart format --set-exit-if-changed .` after each task; run `flutter test` after the last task.
- Do not touch the full theme picker in `settings_page.dart` (`_showThemePicker`, Chiaro/Scuro/Michele) — only the quick-toggle button in the app bar is removed.

---

## File Structure

| File | Change |
|---|---|
| `lib/core/widgets/glassmorphic_app_bar.dart` | Remove theme-toggle button; extract `_ProfileAvatarButton`; add `showProfileIcon` + `minimal` params |
| `lib/features/profile/ui/pages/profile_page.dart` | Pass `showProfileIcon: false` (Task 2); remove the sign-out `OutlinedButton` block (Task 3) |
| `lib/features/settings/ui/pages/settings_page.dart` | Add a new "Account" `_SettingsSection` at the bottom containing the sign-out button |
| `lib/features/movies/ui/pages/movie_details_page.dart` | `GlassmorphicAppBar(showBackButton: true, minimal: true)` |
| `lib/features/tv_series/ui/pages/tv_episode_details_page.dart` | `GlassmorphicAppBar(showBackButton: true, minimal: true)` |
| `lib/features/home/ui/widgets/home_widgets.dart` | `'Profile'` → `'Profilo'` |
| `lib/features/discover/ui/pages/discover_page.dart` | `'Cerca movie, attori, registi...'` → `'Cerca film, attori, registi...'` |
| `lib/features/discover/ui/widgets/discover_widgets.dart` | `MediaGridCard`'s bookmark `IconButton` becomes reactive via `isMediaInWatchlistProvider` |
| `lib/features/tv_series/ui/widgets/tv_series_widgets.dart` | Remove the vote block from `_EpisodeCardNumberRow` |
| `lib/core/l10n/arb/app_it.arb`, `lib/core/l10n/arb/app_en.arb` | Add `accountSection` key |
| `test/core/widgets/glassmorphic_app_bar_test.dart` | New — covers theme-toggle removal, profile tap navigation, `showProfileIcon`, `minimal` |
| `test/features/discover/ui/widgets/media_grid_card_test.dart` | New — covers reactive bookmark icon |
| `test/features/tv_series/ui/widgets/episode_card_test.dart` | Modify — existing vote-icon expectation removed/updated |

---

### Task 1: `GlassmorphicAppBar` — remove theme toggle, move + wire profile avatar, add `showProfileIcon`/`minimal`

**Files:**
- Modify: `lib/core/widgets/glassmorphic_app_bar.dart` (full rewrite of the 121-line file)
- Test: `test/core/widgets/glassmorphic_app_bar_test.dart`

**Interfaces:**
- Consumes: `authStateProvider` (from `package:filmania/features/auth/ui/providers/auth_notifier.dart`, already imported) — `AsyncValue<AuthUser?>` with `.value?.photoUrl`. `AppRoutes.profile` (from `package:filmania/core/router/app_router.dart`, `= '/profile'`).
- Produces: `GlassmorphicAppBar({ bool showBackButton = false, List<Widget>? actions, bool showProfileIcon = true, bool minimal = false })`. When `minimal == true`, the app bar renders only the back button (if `showBackButton`) — no logo, no avatar, no `actions`. Later tasks (Task 3) pass `showProfileIcon: false`; Task 4 passes `minimal: true`.

- [ ] **Step 1: Write the failing test**

Create `test/core/widgets/glassmorphic_app_bar_test.dart`:

```dart
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
        builder: (context, state) =>
            const Scaffold(body: Text('Profile Page')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
    ],
    child: MaterialApp.router(
      theme: AppTheme.dark(),
      routerConfig: router,
    ),
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

  testWidgets('tapping the profile avatar navigates to AppRoutes.profile', (tester) async {
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

  testWidgets('minimal: true hides logo and avatar, keeps only the back button', (tester) async {
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
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/core/widgets/glassmorphic_app_bar_test.dart`
Expected: FAIL — `showProfileIcon`/`minimal` are not defined parameters (compile error), and the theme-toggle icons still exist.

- [ ] **Step 3: Rewrite `glassmorphic_app_bar.dart`**

Replace the full file content:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/theme/app_colors.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/widgets/glass_overlay.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/core/router/app_router.dart';

class GlassmorphicAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final List<Widget>? actions;
  final bool showProfileIcon;
  final bool minimal;

  const GlassmorphicAppBar({
    super.key,
    this.showBackButton = false,
    this.actions,
    this.showProfileIcon = true,
    this.minimal = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return GlassOverlay(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (showBackButton) ...[
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: colors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  if (!minimal)
                    Text(
                      'Filmania',
                      style: textTheme.titleLarge?.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                ],
              ),
              if (!minimal)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (actions != null) ...actions!,
                    if (showProfileIcon) const _ProfileAvatarButton(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + AppSpacing.md * 2);
}

class _ProfileAvatarButton extends ConsumerWidget {
  const _ProfileAvatarButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final authState = ref.watch(authStateProvider);
    final photoUrl = authState.value?.photoUrl;

    return Semantics(
      label: 'Profilo',
      button: true,
      child: GestureDetector(
        onTap: () => context.push(AppRoutes.profile),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.2),
              width: 2,
            ),
            color: colors.primary.withValues(alpha: 0.1),
          ),
          clipBehavior: Clip.antiAlias,
          child: photoUrl != null && photoUrl.isNotEmpty
              ? Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Icon(Icons.person, color: colors.primary),
                )
              : Icon(Icons.person, color: colors.primary),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/core/widgets/glassmorphic_app_bar_test.dart`
Expected: PASS (4/4)

- [ ] **Step 5: Static checks**

Run: `dart analyze` — expect no new errors from this file.
Run: `dart format lib/core/widgets/glassmorphic_app_bar.dart test/core/widgets/glassmorphic_app_bar_test.dart`

- [ ] **Step 6: Commit**

```bash
git add lib/core/widgets/glassmorphic_app_bar.dart test/core/widgets/glassmorphic_app_bar_test.dart
git commit -m "feat: rework GlassmorphicAppBar - drop theme toggle, tappable profile avatar on the right, showProfileIcon/minimal params"
```

---

### Task 2: Wire `minimal: true` into movie/episode details pages, `showProfileIcon: false` into Profile

**Files:**
- Modify: `lib/features/movies/ui/pages/movie_details_page.dart:29`
- Modify: `lib/features/tv_series/ui/pages/tv_episode_details_page.dart:37`
- Modify: `lib/features/profile/ui/pages/profile_page.dart:32-41`

**Interfaces:**
- Consumes: `GlassmorphicAppBar` from Task 1 (`minimal` and `showProfileIcon` params now exist).
- Produces: nothing consumed by later tasks.

- [ ] **Step 1: Edit `movie_details_page.dart`**

```dart
      appBar: const GlassmorphicAppBar(showBackButton: true, minimal: true),
```
(replaces `appBar: const GlassmorphicAppBar(showBackButton: true),` at line 29)

- [ ] **Step 2: Edit `tv_episode_details_page.dart`**

```dart
      appBar: const GlassmorphicAppBar(showBackButton: true, minimal: true),
```
(replaces `appBar: const GlassmorphicAppBar(showBackButton: true),` at line 37)

- [ ] **Step 3: Edit `profile_page.dart` to hide the duplicate avatar**

Replace lines 32-41:

```dart
      appBar: GlassmorphicAppBar(
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_rounded),
            color: colors.onSurfacePrimary,
            tooltip: l10n.settingsTitle,
          ),
        ],
      ),
```

with:

```dart
      appBar: GlassmorphicAppBar(
        showProfileIcon: false,
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_rounded),
            color: colors.onSurfacePrimary,
            tooltip: l10n.settingsTitle,
          ),
        ],
      ),
```

- [ ] **Step 4: Verify no other detail pages were touched**

Run: `git diff --stat` — expected files: only `movie_details_page.dart`, `tv_episode_details_page.dart`, `profile_page.dart`. `tv_series_details_page.dart`, `trending_movies_page.dart`, `trending_tv_series_page.dart`, `settings_page.dart`, `watchlist_detail_page.dart` must show no diff.

- [ ] **Step 5: Static checks**

Run: `dart analyze`
Run: `dart format lib/features/movies/ui/pages/movie_details_page.dart lib/features/tv_series/ui/pages/tv_episode_details_page.dart lib/features/profile/ui/pages/profile_page.dart`

- [ ] **Step 6: Manual check**

Run the app, open a movie details page and an episode details page: app bar must show only the back arrow (no logo, no avatar). Open a TV series details page: app bar must be unchanged (logo + avatar still visible, since `tv_series_details_page.dart` was not touched). Open Profile: no avatar in the app bar (only the settings gear icon), since `_ProfileHero` already shows a large avatar in the body.

- [ ] **Step 7: Commit**

```bash
git add lib/features/movies/ui/pages/movie_details_page.dart lib/features/tv_series/ui/pages/tv_episode_details_page.dart lib/features/profile/ui/pages/profile_page.dart
git commit -m "feat: use minimal app bar on details pages, hide duplicate avatar on Profile"
```

---

### Task 3: Move sign-out from Profile to Settings

**Files:**
- Modify: `lib/features/profile/ui/pages/profile_page.dart`
- Modify: `lib/features/settings/ui/pages/settings_page.dart`
- Modify: `lib/core/l10n/arb/app_it.arb`
- Modify: `lib/core/l10n/arb/app_en.arb`
- Test: `test/features/settings/ui/pages/settings_page_test.dart`

**Interfaces:**
- Consumes: `authProvider` (`ref.read(authProvider.notifier).logout()`, from `features/auth/ui/providers/auth_notifier.dart`, already imported in `profile_page.dart` — add the same import to `settings_page.dart`). `l10n.signOut` and new `l10n.accountSection`.
- Produces: nothing consumed by later tasks in this plan.

- [ ] **Step 1: Add the `accountSection` l10n key**

In `lib/core/l10n/arb/app_it.arb`, after line 71 (`"infoSection": "Informazioni",`):

```json
  "accountSection": "Account",
```

In `lib/core/l10n/arb/app_en.arb`, after line 71 (`"infoSection": "Information",`):

```json
  "accountSection": "Account",
```

- [ ] **Step 2: Regenerate l10n**

Run: `flutter gen-l10n`
Expected: no errors; `lib/core/l10n/generated/app_localizations*.dart` regenerated with `accountSection` getter.

- [ ] **Step 3: Write the failing test**

Create `test/features/settings/ui/pages/settings_page_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/l10n/app_localizations_provider.dart';
import 'package:filmania/core/l10n/generated/app_localizations.dart';
import 'package:filmania/features/settings/ui/pages/settings_page.dart';

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SettingsPage()),
    ],
  );

  return ProviderScope(
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
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.text('Esci'), findsOneWidget);
  });
}
```

- [ ] **Step 4: Run test to verify it fails**

Run: `flutter test test/features/settings/ui/pages/settings_page_test.dart`
Expected: FAIL — `find.text('Esci')` finds nothing.

- [ ] **Step 5: Remove the sign-out button from `profile_page.dart`**

Delete lines 72-86 (the `const SizedBox(height: AppSpacing.xl),` immediately before `Center(...)` stays; only the `Center(child: OutlinedButton(...))` block is removed):

```dart
                const SizedBox(height: AppSpacing.xl),
                const _RecentActivitySection(),
                const SizedBox(height: AppSpacing.xl),
                const SizedBox(height: 120),
```

(This replaces the previous block that had the `Center(child: OutlinedButton(...))` between the two `SizedBox(height: AppSpacing.xl)` lines and before `SizedBox(height: 120)`.)

Since `ref.read(authProvider.notifier).logout()` was the only use of `authProvider` in `profile_page.dart`, check for other usages before removing the import:

Run: `grep -n "authProvider" lib/features/profile/ui/pages/profile_page.dart`
Expected: no remaining matches (only `authStateProvider`, a different provider, remains — keep that import). No import removal needed since `authProvider` was never separately imported (it lives in the same `auth_notifier.dart` file already imported for `authStateProvider`).

- [ ] **Step 6: Add the sign-out section to `settings_page.dart`**

Add import at the top (after line 6, `import '../../../../core/widgets/glassmorphic_app_bar.dart';`):

```dart
import '../../../auth/ui/providers/auth_notifier.dart';
```

Replace the closing of the `SliverChildListDelegate` list (currently ending at the `_SettingsSection` for `infoSection`, around lines 66-80) so the list gains a third section:

```dart
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

                const SizedBox(height: AppSpacing.xl),

                _SettingsSection(
                  title: l10n.accountSection,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Center(
                        child: OutlinedButton(
                          onPressed: () =>
                              ref.read(authProvider.notifier).logout(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colors.error,
                            side: BorderSide(
                              color: colors.error.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 12,
                            ),
                          ),
                          child: Text(l10n.signOut),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
```

- [ ] **Step 7: Run test to verify it passes**

Run: `flutter test test/features/settings/ui/pages/settings_page_test.dart`
Expected: PASS

- [ ] **Step 8: Run the full profile + settings test suite and static checks**

Run: `flutter test test/features/settings/ui/pages/settings_page_test.dart`
Run: `dart analyze`
Run: `dart format lib/features/profile/ui/pages/profile_page.dart lib/features/settings/ui/pages/settings_page.dart test/features/settings/ui/pages/settings_page_test.dart`

- [ ] **Step 9: Manual check**

Run the app: Profile page no longer shows "Esci"; Settings page shows a new "ACCOUNT" section at the bottom with the "Esci" button, and tapping it logs out (redirects to login per `app_router.dart`'s redirect logic).

- [ ] **Step 10: Commit**

```bash
git add lib/features/profile/ui/pages/profile_page.dart lib/features/settings/ui/pages/settings_page.dart lib/core/l10n/arb/app_it.arb lib/core/l10n/arb/app_en.arb lib/core/l10n/generated test/features/settings/ui/pages/settings_page_test.dart
git commit -m "feat: move sign-out button from Profile to a new Account section in Settings"
```

---

### Task 4: Fix hardcoded labels ("Profile" → "Profilo", "movie" → "film")

**Files:**
- Modify: `lib/features/home/ui/widgets/home_widgets.dart:1053`
- Modify: `lib/features/discover/ui/pages/discover_page.dart:204`

**Interfaces:**
- Consumes: nothing new.
- Produces: nothing consumed by later tasks.

- [ ] **Step 1: Edit `home_widgets.dart`**

```dart
        _NavBarItem(
          icon: Icons.person_outline_rounded,
          label: 'Profilo',
```
(replaces `label: 'Profile',` at line 1053, matching the existing hardcoded-Italian pattern used by `'Home'`, `'Scopri'`, `'Watchlist'` in the same widget)

- [ ] **Step 2: Edit `discover_page.dart`**

```dart
                      hintText: selectedMediaType == DiscoverMediaType.movie
                          ? 'Cerca film, attori, registi...'
                          : 'Cerca serie TV...',
```
(replaces `'Cerca movie, attori, registi...'` at line 204)

- [ ] **Step 3: Static checks**

Run: `dart analyze`
Run: `dart format lib/features/home/ui/widgets/home_widgets.dart lib/features/discover/ui/pages/discover_page.dart`

- [ ] **Step 4: Manual check**

Run the app: bottom nav's 4th tab reads "Profilo"; Discover's movie-search hint reads "Cerca film, attori, registi...".

- [ ] **Step 5: Commit**

```bash
git add lib/features/home/ui/widgets/home_widgets.dart lib/features/discover/ui/pages/discover_page.dart
git commit -m "fix: correct hardcoded Italian labels (Profilo, Cerca film)"
```

---

### Task 5: Reactive bookmark icon in `MediaGridCard`

**Files:**
- Modify: `lib/features/discover/ui/widgets/discover_widgets.dart:164-188`
- Test: `test/features/discover/ui/widgets/media_grid_card_test.dart`

**Interfaces:**
- Consumes: `isMediaInWatchlistProvider(int mediaId, MediaType mediaType)` → `AsyncValue<bool>`, family provider already defined in `lib/features/watchlist/ui/providers/watchlist_providers.dart` (used identically in `movie_details_page.dart:276-278`).
- Produces: nothing consumed by later tasks.

- [ ] **Step 1: Write the failing test**

Create `test/features/discover/ui/widgets/media_grid_card_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/discover/ui/widgets/discover_widgets.dart';
import 'package:filmania/features/watchlist/ui/providers/watchlist_providers.dart';
import 'package:filmania/features/watched/ui/providers/watched_providers.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';

Widget _wrap({required bool isInWatchlist}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      isMediaInWatchlistProvider(1, MediaType.movie)
          .overrideWith((ref) => Future.value(isInWatchlist)),
      isMediaWatchedProvider(mediaId: 1, mediaType: MediaType.movie)
          .overrideWith((ref) => Future.value(false)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: Scaffold(
        body: MediaGridCard(
          mediaId: 1,
          title: 'Test Movie',
          posterUrl: null,
          posterPath: null,
          releaseYear: '2024',
          voteAverage: 7.5,
          mediaType: MediaType.movie,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows outlined bookmark icon when not in watchlist', (tester) async {
    await tester.pumpWidget(_wrap(isInWatchlist: false));
    await tester.pump();

    expect(find.byIcon(Icons.bookmark_add_outlined), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_rounded), findsNothing);
  });

  testWidgets('shows filled bookmark icon when in watchlist', (tester) async {
    await tester.pumpWidget(_wrap(isInWatchlist: true));
    await tester.pump();

    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_add_outlined), findsNothing);
  });
}
```

Before writing this, confirm the exact name of the "is media watched" family provider used elsewhere in `MediaGridCard` via `WatchedButton`, since the test must override it too (otherwise the async provider will error in the test):

Run: `grep -rn "isMediaWatchedProvider\|watchedButton" lib/features/watched/ui/providers/watched_providers.dart lib/features/watched/ui/widgets/watched_button.dart`

If the provider family has a different name/signature than `isMediaWatchedProvider(mediaId:, mediaType:)`, adjust the override in the test to match exactly what `WatchedButton` consumes — do not guess silently; read the file first.

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/discover/ui/widgets/media_grid_card_test.dart`
Expected: FAIL — the bookmark icon is always `Icons.bookmark_add_outlined` regardless of watchlist state.

- [ ] **Step 3: Make the bookmark icon reactive**

In `lib/features/discover/ui/widgets/discover_widgets.dart`, change the `build` method signature is already `ConsumerWidget` (no change needed there). Replace the bookmark `GlassOverlay`/`IconButton` block (lines 160-188) with:

```dart
                    Builder(
                      builder: (context) {
                        final isInWatchlistAsync = ref.watch(
                          isMediaInWatchlistProvider(mediaId, mediaType),
                        );
                        final isInWatchlist = isInWatchlistAsync.value ?? false;

                        return GlassOverlay(
                          sigma: 10,
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withValues(alpha: 0.5),
                          child: IconButton(
                            style: IconButton.styleFrom(
                              minimumSize: const Size(32, 32),
                              fixedSize: const Size(32, 32),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                              maxWidth: 32,
                              maxHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              isInWatchlist
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_add_outlined,
                              color: isInWatchlist ? colors.primary : Colors.white,
                              size: 18,
                            ),
                            onPressed: () => showWatchlistPicker(
                              context,
                              ref,
                              mediaId: mediaId,
                              mediaTitle: title,
                              mediaType: mediaType,
                              posterPath: posterPath,
                            ),
                          ),
                        );
                      },
                    ),
```

Add `import 'package:flutter_riverpod/flutter_riverpod.dart';` is already present (`ConsumerWidget`); add the watchlist provider import at the top of the file (after line 10):

```dart
import '../../../watchlist/ui/providers/watchlist_providers.dart';
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/discover/ui/widgets/media_grid_card_test.dart`
Expected: PASS (2/2)

- [ ] **Step 5: Run the wider discover test suite (regression check) and static checks**

Run: `flutter test test/features/discover`
Run: `dart analyze`
Run: `dart format lib/features/discover/ui/widgets/discover_widgets.dart test/features/discover/ui/widgets/media_grid_card_test.dart`

- [ ] **Step 6: Manual check**

Run the app: open Home/Discover/Watchlist, add a title to a watchlist from its grid card, confirm the bookmark icon on that card fills in immediately without navigating away; remove it, confirm it reverts.

- [ ] **Step 7: Commit**

```bash
git add lib/features/discover/ui/widgets/discover_widgets.dart test/features/discover/ui/widgets/media_grid_card_test.dart
git commit -m "fix: MediaGridCard bookmark icon reflects real watchlist state"
```

---

### Task 6: Remove vote display from episode cards

**Files:**
- Modify: `lib/features/tv_series/ui/widgets/tv_series_widgets.dart:471-481`
- Modify: `test/features/tv_series/ui/widgets/episode_card_test.dart`

**Interfaces:**
- Consumes: nothing new.
- Produces: nothing consumed by later tasks. `TVEpisode.voteAverage` entity field is untouched (still present, just not rendered).

- [ ] **Step 1: Update the existing test to assert the vote icon is gone**

In `test/features/tv_series/ui/widgets/episode_card_test.dart`, add a new test at the end of `main()` (after the existing two tests, before the closing `}`):

```dart
  testWidgets('EpisodeCard does not show a vote star even when voteAverage > 0', (tester) async {
    await tester.pumpWidget(_wrap(isWatched: false));
    await tester.pump();

    expect(find.byIcon(Icons.star_rounded), findsNothing);
    expect(find.text('8.9'), findsNothing);
  });
```

(`_episode` at the top of the file already has `voteAverage: 8.9`, so this exercises the removed branch directly.)

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/tv_series/ui/widgets/episode_card_test.dart`
Expected: FAIL — `find.byIcon(Icons.star_rounded)` finds one widget (the vote block still renders).

- [ ] **Step 3: Remove the vote block**

In `lib/features/tv_series/ui/widgets/tv_series_widgets.dart`, in `_EpisodeCardNumberRow.build`, delete lines 471-481:

```dart
        if (episode.voteAverage > 0) ...[
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
          const SizedBox(width: 2),
          Text(
            episode.voteAverage.toStringAsFixed(1),
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceSecondary,
            ),
          ),
        ],
```

So the widget's children list ends with the `if (episode.runtime != null) ...[...]` block, i.e.:

```dart
        if (episode.runtime != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${episode.runtime} min',
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
```

Do not modify `TVEpisode` entity in `lib/features/tv_series/domain/entities/tv_episode.dart` — `voteAverage` stays.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/tv_series/ui/widgets/episode_card_test.dart`
Expected: PASS (3/3)

- [ ] **Step 5: Static checks**

Run: `dart analyze` — confirm no unused-import warning for `Colors.amber`'s usage removal (the `Icon`/`Colors.amber` literal is deleted inline, no separate import to clean up since `material.dart` is used broadly in the file).
Run: `dart format lib/features/tv_series/ui/widgets/tv_series_widgets.dart test/features/tv_series/ui/widgets/episode_card_test.dart`

- [ ] **Step 6: Manual check**

Run the app: open a TV series' episode list — episode rows show episode number, watched check, and runtime, but no star/vote number.

- [ ] **Step 7: Commit**

```bash
git add lib/features/tv_series/ui/widgets/tv_series_widgets.dart test/features/tv_series/ui/widgets/episode_card_test.dart
git commit -m "fix: remove vote display from episode cards"
```

---

## Final Verification

- [ ] Run `dart run build_runner build --delete-conflicting-outputs` (safety net — no Freezed/Riverpod providers were added in this plan, but confirms nothing else drifted).
- [ ] Run `dart analyze` — zero issues.
- [ ] Run `dart format --set-exit-if-changed .` — zero diffs.
- [ ] Run `flutter test` — full suite green.
- [ ] Manually re-walk sections A, B, C, E, H end-to-end on an emulator per the top-level instructions (app bar on Home/Discover/Watchlist/Profile/Settings/movie details/episode details/TV series details, Settings sign-out, bottom nav label, Discover search hint, watchlist bookmark reactivity, episode list vote removal).
