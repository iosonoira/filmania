# Episode Watched Toggle from Card — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a tap-to-toggle "watched" icon button to each `EpisodeCard` in the TV series episode list, so users don't need to open the episode details page to mark an episode as seen.

**Architecture:** `WatchedEpisodeButton` (existing widget with full toggle logic) is reused in `isIconOnly` mode inside `EpisodeCard`. Its icons are updated to `check_circle_rounded` / `check_circle_outline_rounded` for visual consistency with the check iconography already in the card. `seriesTitle` and `seriesPosterPath` are threaded from `_TVSeriesDetailsContent` down through `EpisodesSection → _EpisodesList → _EpisodesListContent → EpisodeCard`.

**Tech Stack:** Flutter, Riverpod 3.0 (`@riverpod` codegen), `flutter_test`, `WatchedEpisodeButton` (existing)

---

## File Map

| Action | File |
|---|---|
| Modify | `lib/features/watched/ui/widgets/watched_episode_button.dart` |
| Modify | `lib/features/tv_series/ui/widgets/tv_series_widgets.dart` |
| Modify | `lib/features/tv_series/ui/pages/tv_series_details_page.dart` |
| Create | `test/features/watched/ui/widgets/watched_episode_button_icon_test.dart` |
| Create | `test/features/tv_series/ui/widgets/episode_card_test.dart` |

---

## Task 1: Update `WatchedEpisodeButton` icons in `isIconOnly` mode

**Files:**
- Modify: `lib/features/watched/ui/widgets/watched_episode_button.dart`
- Create: `test/features/watched/ui/widgets/watched_episode_button_icon_test.dart`

- [ ] **Step 1: Create the test file**

```dart
// test/features/watched/ui/widgets/watched_episode_button_icon_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/features/watched/ui/widgets/watched_episode_button.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/watched/ui/providers/watched_providers.dart';

Widget _buildSubject({bool isWatched = false}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      isEpisodeWatchedProvider(
        seriesId: 1,
        seasonNumber: 1,
        episodeNumber: 1,
      ).overrideWith((ref) => Future.value(isWatched)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: const Scaffold(
        body: Center(
          child: WatchedEpisodeButton(
            isIconOnly: true,
            seriesId: 1,
            seasonNumber: 1,
            episodeNumber: 1,
            seriesTitle: 'Test Series',
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('isIconOnly shows check_circle_outline_rounded when not watched', (tester) async {
    await tester.pumpWidget(_buildSubject(isWatched: false));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
  });

  testWidgets('isIconOnly shows check_circle_rounded when watched', (tester) async {
    await tester.pumpWidget(_buildSubject(isWatched: true));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsNothing);
  });
}
```

- [ ] **Step 2: Run test — expect FAIL (wrong icons)**

```
flutter test test/features/watched/ui/widgets/watched_episode_button_icon_test.dart -v
```

Expected: FAIL — finds `Icons.visibility` / `Icons.visibility_outlined`, not check icons.

- [ ] **Step 3: Update icons in `watched_episode_button.dart`**

Find the `isIconOnly` branch (lines ~96–104) and replace:

```dart
// BEFORE
if (isIconOnly) {
  return IconButton(
    icon: Icon(
      isWatched ? Icons.visibility : Icons.visibility_outlined,
      color: isWatched ? colors.primary : colors.onSurfaceSecondary,
    ),
    onPressed: toggleWatched,
  );
}

// AFTER
if (isIconOnly) {
  return IconButton(
    icon: Icon(
      isWatched ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
      color: isWatched ? colors.primary : colors.onSurfaceSecondary,
    ),
    onPressed: toggleWatched,
  );
}
```

- [ ] **Step 4: Run test — expect PASS**

```
flutter test test/features/watched/ui/widgets/watched_episode_button_icon_test.dart -v
```

Expected: 2 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/watched/ui/widgets/watched_episode_button.dart test/features/watched/ui/widgets/watched_episode_button_icon_test.dart
git commit -m "fix: use check icons in WatchedEpisodeButton isIconOnly mode"
```

---

## Task 2: Add params + toggle button to `EpisodeCard` widget tree

**Files:**
- Modify: `lib/features/tv_series/ui/widgets/tv_series_widgets.dart`
- Create: `test/features/tv_series/ui/widgets/episode_card_test.dart`

- [ ] **Step 1: Create the test file**

```dart
// test/features/tv_series/ui/widgets/episode_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:filmania/core/theme/app_theme.dart';
import 'package:filmania/features/tv_series/ui/widgets/tv_series_widgets.dart';
import 'package:filmania/features/tv_series/domain/entities/tv_episode.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/watched/ui/providers/watched_providers.dart';

const _episode = TVEpisode(
  id: 101,
  episodeNumber: 1,
  seasonNumber: 1,
  name: 'Winter Is Coming',
  overview: 'The story begins.',
  stillPath: null,
  voteAverage: 8.9,
  airDate: '2011-04-17',
  runtime: 62,
);

Widget _wrap({bool isWatched = false}) {
  return ProviderScope(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(null)),
      watchedEpisodesProvider(1).overrideWith(
        (ref) => Stream.value(isWatched ? ['s1e1'] : []),
      ),
      isEpisodeWatchedProvider(
        seriesId: 1,
        seasonNumber: 1,
        episodeNumber: 1,
      ).overrideWith((ref) => Future.value(isWatched)),
    ],
    child: MaterialApp(
      theme: AppTheme.dark(),
      home: Scaffold(
        body: EpisodeCard(
          episode: _episode,
          tvId: 1,
          seriesTitle: 'Game of Thrones',
          seriesPosterPath: null,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('EpisodeCard renders a toggle button when episode is not watched', (tester) async {
    await tester.pumpWidget(_wrap(isWatched: false));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
  });

  testWidgets('EpisodeCard renders a filled check icon when episode is watched', (tester) async {
    await tester.pumpWidget(_wrap(isWatched: true));
    await tester.pump();
    expect(find.byIcon(Icons.check_circle_rounded), findsWidgets);
  });
}
```

- [ ] **Step 2: Run test — expect FAIL (no toggle button in card yet)**

```
flutter test test/features/tv_series/ui/widgets/episode_card_test.dart -v
```

Expected: FAIL — `EpisodeCard` constructor has no `seriesTitle`/`seriesPosterPath` params yet.

- [ ] **Step 3: Add `seriesTitle` and `seriesPosterPath` to `EpisodesSection`**

In `tv_series_widgets.dart`, update `EpisodesSection`:

```dart
class EpisodesSection extends ConsumerWidget {
  final int tvId;
  final List<TVSeason> seasons;
  final String seriesTitle;
  final String? seriesPosterPath;

  const EpisodesSection({
    super.key,
    required this.tvId,
    required this.seasons,
    required this.seriesTitle,
    this.seriesPosterPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainSeasons = seasons.where((s) => s.seasonNumber > 0).toList();
    if (mainSeasons.isEmpty) return const SizedBox.shrink();

    final selectedSeason = ref.watch(selectedSeasonProvider(tvId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _EpisodesSectionHeader(
          tvId: tvId,
          seasons: mainSeasons,
          selectedSeason: selectedSeason,
        ),
        const SizedBox(height: AppSpacing.md),
        _EpisodesList(
          tvId: tvId,
          seasonNumber: selectedSeason,
          seriesTitle: seriesTitle,
          seriesPosterPath: seriesPosterPath,
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Add `seriesTitle` and `seriesPosterPath` to `_EpisodesList`**

```dart
class _EpisodesList extends ConsumerWidget {
  final int tvId;
  final int seasonNumber;
  final String seriesTitle;
  final String? seriesPosterPath;

  const _EpisodesList({
    required this.tvId,
    required this.seasonNumber,
    required this.seriesTitle,
    this.seriesPosterPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodesAsync = ref.watch(seasonEpisodesProvider(tvId, seasonNumber));

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: episodesAsync.when(
        data: (episodes) => _EpisodesListContent(
          key: ValueKey('season_$seasonNumber'),
          episodes: episodes,
          tvId: tvId,
          seriesTitle: seriesTitle,
          seriesPosterPath: seriesPosterPath,
        ),
        loading: () => _EpisodesLoadingSkeleton(
          key: ValueKey('loading_$seasonNumber'),
        ),
        error: (err, _) => Padding(
          key: ValueKey('error_$seasonNumber'),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AppErrorView(
            error: err,
            compact: true,
            onRetry: () =>
                ref.invalidate(seasonEpisodesProvider(tvId, seasonNumber)),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Add `seriesTitle` and `seriesPosterPath` to `_EpisodesListContent`**

```dart
class _EpisodesListContent extends StatelessWidget {
  final List<TVEpisode> episodes;
  final int tvId;
  final String seriesTitle;
  final String? seriesPosterPath;

  const _EpisodesListContent({
    super.key,
    required this.episodes,
    required this.tvId,
    required this.seriesTitle,
    this.seriesPosterPath,
  });

  @override
  Widget build(BuildContext context) {
    if (episodes.isEmpty) {
      return const _EpisodesEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: episodes.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) => EpisodeCard(
        key: ValueKey('episode_${episodes[index].id}'),
        episode: episodes[index],
        tvId: tvId,
        seriesTitle: seriesTitle,
        seriesPosterPath: seriesPosterPath,
      ),
    );
  }
}
```

- [ ] **Step 6: Add `seriesTitle`, `seriesPosterPath` to `EpisodeCard` and add `WatchedEpisodeButton`**

Add the import at the top of `tv_series_widgets.dart` (after existing imports):

```dart
import '../../../watched/ui/widgets/watched_episode_button.dart';
```

Replace the full `EpisodeCard` class:

```dart
class EpisodeCard extends ConsumerWidget {
  final TVEpisode episode;
  final int tvId;
  final String seriesTitle;
  final String? seriesPosterPath;

  const EpisodeCard({
    super.key,
    required this.episode,
    required this.tvId,
    required this.seriesTitle,
    this.seriesPosterPath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final watchedEpisodes = ref.watch(watchedEpisodesProvider(tvId)).value ?? [];
    final isWatched = watchedEpisodes.contains('s${episode.seasonNumber}e${episode.episodeNumber}');

    return Semantics(
      label: 'Episodio ${episode.episodeNumber}: ${episode.name}',
      button: true,
      child: GestureDetector(
        onTap: () {
          context.push(
            AppRoutes.tvEpisodeDetails
                .replaceFirst(':id', tvId.toString())
                .replaceFirst(':seasonNumber', episode.seasonNumber.toString())
                .replaceFirst(':episodeNumber', episode.episodeNumber.toString()),
          );
        },
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.md),
            border: Border.all(
              color: isWatched
                  ? colors.primary.withValues(alpha: 0.3)
                  : colors.onSurfaceSecondary.withValues(alpha: 0.1),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              _EpisodeCardThumbnail(episode: episode, isWatched: isWatched),
              const SizedBox(width: AppSpacing.md),
              _EpisodeCardInfo(episode: episode, isWatched: isWatched),
              WatchedEpisodeButton(
                isIconOnly: true,
                seriesId: tvId,
                seasonNumber: episode.seasonNumber,
                episodeNumber: episode.episodeNumber,
                seriesTitle: seriesTitle,
                seriesPosterPath: seriesPosterPath,
                runtimeMinutes: episode.runtime,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

Note: The trailing `SizedBox(width: AppSpacing.sm)` is removed — `IconButton` has its own 8px internal padding which provides adequate spacing from the card edge.

- [ ] **Step 7: Run test — expect PASS**

```
flutter test test/features/tv_series/ui/widgets/episode_card_test.dart -v
```

Expected: 2 tests PASS.

- [ ] **Step 8: Run full test suite**

```
flutter test -v
```

Expected: all tests PASS.

- [ ] **Step 9: Commit**

```bash
git add lib/features/tv_series/ui/widgets/tv_series_widgets.dart test/features/tv_series/ui/widgets/episode_card_test.dart
git commit -m "feat: add watched toggle button to EpisodeCard"
```

---

## Task 3: Pass `seriesTitle` and `seriesPosterPath` from `TVSeriesDetailsPage`

**Files:**
- Modify: `lib/features/tv_series/ui/pages/tv_series_details_page.dart`

- [ ] **Step 1: Update `EpisodesSection` call in `_TVSeriesDetailsContent`**

Find the `EpisodesSection` call in `_TVSeriesDetailsContent.build()` (around line 248) and update:

```dart
// BEFORE
SliverToBoxAdapter(
  child: EpisodesSection(tvId: series.id, seasons: series.seasons),
),

// AFTER
SliverToBoxAdapter(
  child: EpisodesSection(
    tvId: series.id,
    seasons: series.seasons,
    seriesTitle: series.name,
    seriesPosterPath: series.posterPath,
  ),
),
```

- [ ] **Step 2: Verify no analysis errors**

```
flutter analyze lib/features/tv_series/
```

Expected: `No issues found!`

- [ ] **Step 3: Run full test suite**

```
flutter test -v
```

Expected: all tests PASS.

- [ ] **Step 4: Commit**

```bash
git add lib/features/tv_series/ui/pages/tv_series_details_page.dart
git commit -m "feat: wire seriesTitle/posterPath into EpisodesSection"
```

---

## Manual Smoke Test

After all tasks complete:

1. Run `flutter run`
2. Navigate to any TV series detail page
3. Verify: each episode card shows `check_circle_outline_rounded` icon (grey) on the trailing right
4. Tap the icon on any episode → icon becomes `check_circle_rounded` (violet), card border turns violet, thumbnail shows checkmark badge
5. Tap again → reverts to not-watched state
6. Tap the card body (not the icon) → navigates to episode details (unchanged)
7. Navigate to episode details page → `WatchedEpisodeButton` full label version still works
