import '../entities/watched_item.dart';
import '../../../../core/domain/enums/media_type.dart';

abstract class IWatchedRepository {
  Future<void> markAsWatched(WatchedItem item);
  Future<void> removeFromWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
  Stream<List<WatchedItem>> watchUserWatchedItems(String userId, MediaType mediaType);
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
}
