import 'package:filmania/domain/models/watched_item.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/domain/models/tv_series.dart';

/// Writes and reads the user's watched list only. The TMDB data a write
/// needs (movie runtime, the series' episode list) is passed in by the
/// caller — see `MarkAsWatchedUseCase` — because the Flutter architecture
/// guide keeps repositories unaware of each other.
abstract class IWatchedRepository {
  /// Stores [item] as given: a missing runtime stays missing.
  Future<void> markMovieAsWatched(WatchedItem item);

  /// Marks every episode of [series] (specials excluded) and the series itself.
  Future<void> markSeriesAsWatched(WatchedItem item, TVSeries series);
  Future<void> removeFromWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
  Stream<List<WatchedItem>> watchUserWatchedItems(
    String userId,
    MediaType mediaType,
  );
  Future<bool> isWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });

  // Episode methods
  Future<void> markEpisodeAsWatched({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
    required String seriesTitle,
    String? seriesPosterPath,
    int? runtimeMinutes,
    required TVSeries series,
  });
  Future<void> markEpisodeAsUnwatched({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
  });
  Future<bool> isEpisodeWatched({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
  });
  Stream<List<String>> watchWatchedEpisodes(String userId, int seriesId);

  Future<int> getWatchedEpisodesCount({
    required String userId,
    required int seriesId,
  });

  /// Ritorna il conteggio di episodi visti per ciascuna serie in [seriesIds],
  /// in un'unica query invece di una chiamata per serie (evita l'N+1 verso
  /// Supabase quando serve categorizzare molte serie in un colpo solo — vedi
  /// `categorizedTvSeries`). Le serie senza episodi visti semplicemente non
  /// compaiono come chiave nella mappa risultante: trattarle come conteggio 0.
  Future<Map<int, int>> getWatchedEpisodesCountsForSeries({
    required String userId,
    required List<int> seriesIds,
  });

  Future<void> markSeriesAsDropped({
    required String userId,
    required int seriesId,
    required bool isDropped,
  });

  Future<void> markSeriesAsWatchLater({
    required String userId,
    required int seriesId,
    required bool isWatchLater,
  });
}
