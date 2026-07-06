import '../entities/watched_item.dart';
import '../../../../core/domain/enums/media_type.dart';

abstract class IWatchedRepository {
  Future<void> markAsWatched(WatchedItem item);
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
}
