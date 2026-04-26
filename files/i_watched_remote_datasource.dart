import '../models/watched_episode_dto.dart';
import '../models/watched_item_dto.dart';
import '../../../../core/domain/enums/media_type.dart';

abstract class IWatchedRemoteDataSource {
  Future<void> markAsWatched(WatchedItemDto item);
  Future<void> markTVSeriesAsWatchedBatchRPC({
    required int seriesId,
    required String seriesTitle,
    required String? posterPath,
    required List<Map<String, int>> episodes,
  });
  Future<void> removeFromWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });
  Stream<List<WatchedItemDto>> watchUserWatchedItems(String userId, MediaType mediaType);
  Future<bool> isWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  });

  // Episode methods
  Future<void> markEpisodeAsWatched(WatchedEpisodeDto episode);
  Future<void> markEpisodesAsWatched(List<WatchedEpisodeDto> episodes);
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
  Stream<List<WatchedEpisodeDto>> watchWatchedEpisodes(String userId, int seriesId);

  Future<void> removeAllEpisodesFromWatched({
    required String userId,
    required int seriesId,
  });

  Future<int> getWatchedEpisodesCount({
    required String userId,
    required int seriesId,
  });
}
