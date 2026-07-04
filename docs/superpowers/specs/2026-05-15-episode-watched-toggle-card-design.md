# Design: Episode Watched Toggle from Episode Card

**Date:** 2026-05-15  
**Status:** Approved

---

## Problem

Users can mark an episode as watched only from the episode details page (`TVEpisodeDetailsPage`). The episode list inside `TVSeriesDetailsPage` shows watched state visually (checkmark badge, colored border, check icon in row) but provides no way to toggle it without navigating away.

---

## Goal

Add a tap target directly on each `EpisodeCard` that toggles the watched state — matching the visual language already present in the card.

---

## Interaction Design

- **Tap on card body** → navigates to episode details (unchanged)
- **Tap on trailing icon** → toggles watched/unwatched (new)

### Icon spec

| State | Icon | Color |
|---|---|---|
| Not watched | `Icons.check_circle_outline_rounded` | `AppColors.of(context).onSurfaceSecondary` |
| Watched | `Icons.check_circle_rounded` | `AppColors.of(context).primary` |

Icons are intentionally consistent with those already rendered in `_EpisodeCardThumbnail` (`check_rounded` badge) and `_EpisodeCardNumberRow` (`check_circle_rounded`).

The button background uses `AppColors.primary.withValues(alpha: 0.14)` when watched, transparent when not — same tint pattern used in `WatchedEpisodeButton`.

---

## Architecture

### Files changed

#### 1. `lib/features/watched/ui/widgets/watched_episode_button.dart`

`WatchedEpisodeButton` with `isIconOnly: true` currently renders `Icons.visibility` / `Icons.visibility_outlined`. These are appropriate for the details page but inconsistent with the check-based iconography of the episode list.

**Change:** In the `isIconOnly` branch, replace icons with `Icons.check_circle_rounded` (watched) and `Icons.check_circle_outline_rounded` (not watched). No other changes to logic or API.

#### 2. `lib/features/tv_series/ui/widgets/tv_series_widgets.dart`

**`EpisodeCard`**  
Add two required parameters: `seriesTitle: String` and `seriesPosterPath: String?`.  
Add `WatchedEpisodeButton(isIconOnly: true, ...)` as the trailing element of the card's `Row`, before the existing trailing `SizedBox`.

**`_EpisodesListContent`**  
Add `seriesTitle: String` and `seriesPosterPath: String?` parameters. Thread them into `EpisodeCard`.

**`_EpisodesList`**  
Add `seriesTitle` and `seriesPosterPath` parameters. Thread into `_EpisodesListContent`.

**`EpisodesSection`**  
Add `seriesTitle: String` and `seriesPosterPath: String?` parameters. Thread into `_EpisodesList`.

#### 3. `lib/features/tv_series/ui/pages/tv_series_details_page.dart`

`_TVSeriesDetailsContent` already holds the full `TVSeries` object.  
Pass `series.name` and `series.posterPath` to `EpisodesSection`.

---

## Data Flow

```
_TVSeriesDetailsContent (has TVSeries)
  └─ EpisodesSection(seriesTitle, seriesPosterPath)
       └─ _EpisodesList(seriesTitle, seriesPosterPath)
            └─ _EpisodesListContent(seriesTitle, seriesPosterPath)
                 └─ EpisodeCard(seriesTitle, seriesPosterPath)
                      └─ WatchedEpisodeButton(isIconOnly: true,
                           seriesId: tvId,
                           seasonNumber: episode.seasonNumber,
                           episodeNumber: episode.episodeNumber,
                           seriesTitle: seriesTitle,
                           seriesPosterPath: seriesPosterPath)
```

---

## State / Provider impact

`WatchedEpisodeButton` already handles all invalidations on toggle:
- `isEpisodeWatchedProvider`
- `watchedEpisodesProvider(seriesId)`
- `isMediaWatchedProvider(mediaId, mediaType)`
- `watchedItemsProvider(MediaType.tv)`

No new providers needed.

---

## Layout constraints

Card height is fixed at 90px. `WatchedEpisodeButton(isIconOnly: true)` renders as `IconButton` (48×48 tap target, 36px icon area) — fits within the card's `Row` without affecting height. The `Expanded` info section absorbs the width reduction.

---

## Out of scope

- Episode details page (`TVEpisodeDetailsPage`) — already has the full `WatchedEpisodeButton` with label
- Watched list page — unaffected
- Movie cards — separate feature, not related
