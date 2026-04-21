import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../domain/entities/watched_item.dart';
import '../../domain/repositories/i_watched_repository.dart';
import '../../../tv_series/domain/repositories/i_tv_series_repository.dart';
import '../../../tv_series/data/repositories/tv_series_repository_impl.dart';
import '../datasources/i_watched_remote_datasource.dart';
import '../datasources/watched_remote_datasource_impl.dart';
import '../models/watched_episode_dto.dart';
import '../models/watched_item_dto.dart';

part 'watched_repository_impl.g.dart';

class WatchedRepositoryImpl implements IWatchedRepository {
  final IWatchedRemoteDataSource _remoteDS;
  final ITVSeriesRepository _tvRepo;

  WatchedRepositoryImpl(this._remoteDS, this._tvRepo);

  @override
  Future<void> markAsWatched(WatchedItem item) async {
    if (item.mediaType == MediaType.tv) {
      // 1. Get series details to know all episodes
      final series = await _tvRepo.getTVSeriesDetails(item.mediaId);

      // 2. Collect episodes for the RPC
      final episodes = <Map<String, int>>[];
      for (final season in series.seasons) {
        if (season.seasonNumber == 0) continue; // Skip specials
        for (int i = 1; i <= season.episodeCount; i++) {
          episodes.add({'s': season.seasonNumber, 'e': i});
        }
      }

      // 3. Call the RPC (Handles both items and episodes in one go)
      await _remoteDS.markTVSeriesAsWatchedBatchRPC(
        seriesId: item.mediaId,
        seriesTitle: item.mediaTitle,
        posterPath: item.posterPath,
        episodes: episodes,
      );
      return; // RPC handles everything, no need for Step 4
    }

    // 4. For Movies (or fallback), mark the series itself
    final dto = WatchedItemDto.fromEntity(item);
    await _remoteDS.markAsWatched(dto);
  }

  @override
  Future<void> removeFromWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    if (mediaType == MediaType.tv) {
      // Delete all episode records for this series
      await _remoteDS.removeAllEpisodesFromWatched(userId: userId, seriesId: mediaId);
    }
    await _remoteDS.removeFromWatched(
      userId: userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
  }

  @override
  Stream<List<WatchedItem>> watchUserWatchedItems(String userId, MediaType mediaType) {
    return _remoteDS.watchUserWatchedItems(userId, mediaType).map(
          (dtos) => dtos.map((dto) => dto.toEntity()).toList(),
        );
  }

  @override
  Future<bool> isWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    return _remoteDS.isWatched(
      userId: userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
  }

  @override
  Future<void> markEpisodeAsWatched({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
    required String seriesTitle,
    String? seriesPosterPath,
  }) async {
    // 1. Mark this episode as watched
    final episodeDto = WatchedEpisodeDto(
      userId: userId,
      seriesId: seriesId,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
      watchedAt: DateTime.now(),
    );
    await _remoteDS.markEpisodeAsWatched(episodeDto);

    // 2. Refresh count and check if all episodes are watched
    final series = await _tvRepo.getTVSeriesDetails(seriesId);
    final totalEpisodes = series.seasons
        .where((s) => s.seasonNumber > 0)
        .fold(0, (sum, s) => sum + s.episodeCount);

    final watchedCount = await _remoteDS.getWatchedEpisodesCount(
      userId: userId,
      seriesId: seriesId,
    );

    if (watchedCount >= totalEpisodes) {
      // Mark as complete in watched_items (already there or new)
      final seriesDto = WatchedItemDto(
        userId: userId,
        mediaId: seriesId,
        mediaTitle: seriesTitle,
        mediaType: MediaType.tv.name,
        posterPath: seriesPosterPath,
        watchedAt: DateTime.now(),
      );
      await _remoteDS.markAsWatched(seriesDto);
    } else {
      // Ensure series IS in watched_items so it appears in the list
      // even if not all episodes are seen
      final seriesDto = WatchedItemDto(
        userId: userId,
        mediaId: seriesId,
        mediaTitle: seriesTitle,
        mediaType: MediaType.tv.name,
        posterPath: seriesPosterPath,
        watchedAt: DateTime.now(),
      );
      await _remoteDS.markAsWatched(seriesDto);
    }
  }

  @override
  Future<void> markEpisodeAsUnwatched({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
  }) async {
    // 1. Unmark episode
    await _remoteDS.markEpisodeAsUnwatched(
      userId: userId,
      seriesId: seriesId,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
    );

    // 2. Remove from watched_items because it's no longer a COMPLETE series
    await _remoteDS.removeFromWatched(
      userId: userId,
      mediaId: seriesId,
      mediaType: MediaType.tv,
    );
  }

  @override
  Future<bool> isEpisodeWatched({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
  }) async {
    return _remoteDS.isEpisodeWatched(
      userId: userId,
      seriesId: seriesId,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
    );
  }

  @override
  Future<int> getWatchedEpisodesCount({
    required String userId,
    required int seriesId,
  }) async {
    return _remoteDS.getWatchedEpisodesCount(
      userId: userId,
      seriesId: seriesId,
    );
  }

  @override
  Stream<List<String>> watchWatchedEpisodes(String userId, int seriesId) {
    return _remoteDS.watchWatchedEpisodes(userId, seriesId).map(
          (dtos) => dtos.map((e) => 's${e.seasonNumber}e${e.episodeNumber}').toList(),
        );
  }
}

@riverpod
IWatchedRepository watchedRepository(Ref ref) {
  return WatchedRepositoryImpl(
    ref.watch(watchedRemoteDataSourceProvider),
    ref.watch(tvSeriesRepositoryProvider),
  );
}
