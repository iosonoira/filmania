import 'package:flutter/foundation.dart';

/// Identifies one TV episode inside a multi-select selection [Set].
///
/// Equality is scoped to [seriesId] + [seasonNumber] + [episodeNumber] only,
/// while [seriesTitle]/[seriesPosterPath]/[runtimeMinutes] ride along so bulk
/// actions (mark watched) can call `markEpisodeAsWatched` without an extra
/// look-up per selected episode.
@immutable
class EpisodeSelectionItem {
  const EpisodeSelectionItem({
    required this.seriesId,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.seriesTitle,
    this.seriesPosterPath,
    this.runtimeMinutes,
  });

  final int seriesId;
  final int seasonNumber;
  final int episodeNumber;
  final String seriesTitle;
  final String? seriesPosterPath;
  final int? runtimeMinutes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EpisodeSelectionItem &&
          other.seriesId == seriesId &&
          other.seasonNumber == seasonNumber &&
          other.episodeNumber == episodeNumber);

  @override
  int get hashCode => Object.hash(seriesId, seasonNumber, episodeNumber);
}
