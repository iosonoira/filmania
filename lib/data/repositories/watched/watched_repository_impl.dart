import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/domain/models/watched_item.dart';
import 'package:filmania/domain/models/tv_series.dart';
import 'package:filmania/data/repositories/watched/i_watched_repository.dart';
import 'package:filmania/data/services/supabase/i_watched_remote_datasource.dart';
import 'package:filmania/data/services/supabase/watched_remote_datasource_impl.dart';
import 'package:filmania/data/models/watched_episode_dto.dart';
import 'package:filmania/data/models/watched_item_dto.dart';

part 'watched_repository_impl.g.dart';

class WatchedRepositoryImpl implements IWatchedRepository {
  final IWatchedRemoteDataSource _remoteDS;

  WatchedRepositoryImpl(this._remoteDS);

  @override
  Future<void> markMovieAsWatched(WatchedItem item) {
    return _remoteDS.markAsWatched(WatchedItemDto.fromEntity(item));
  }

  @override
  Future<void> markSeriesAsWatched(WatchedItem item, TVSeries series) async {
    // 1. Use the series details to know all episodes and runtimes
    final avgRuntime = series.episodeRunTime.isNotEmpty
        ? series.episodeRunTime.first
        : 0;

    // 2. Prepare episodes for batch upsert with runtime
    final episodes = <WatchedEpisodeDto>[];
    for (final season in series.seasons) {
      if (season.seasonNumber == 0) continue; // Skip specials
      for (int i = 1; i <= season.episodeCount; i++) {
        episodes.add(
          WatchedEpisodeDto(
            userId: item.userId,
            seriesId: item.mediaId,
            seasonNumber: season.seasonNumber,
            episodeNumber: i,
            runtimeMinutes: avgRuntime,
            watchedAt: DateTime.now(),
          ),
        );
      }
    }

    // 3. Mark episodes as watched (batch)
    if (episodes.isNotEmpty) {
      await _remoteDS.markEpisodesAsWatched(episodes);
    }

    // 4. Mark the series itself in watched_items with total calculated runtime
    final totalRuntime = episodes.length * avgRuntime;
    final seriesDto = WatchedItemDto.fromEntity(
      item.copyWith(runtimeMinutes: totalRuntime > 0 ? totalRuntime : null),
    );
    await _remoteDS.markAsWatched(seriesDto);
  }

  @override
  Future<void> removeFromWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    if (mediaType == MediaType.tv) {
      // Delete all episode records for this series
      await _remoteDS.removeAllEpisodesFromWatched(
        userId: userId,
        seriesId: mediaId,
      );
    }
    await _remoteDS.removeFromWatched(
      userId: userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
  }

  @override
  Stream<List<WatchedItem>> watchUserWatchedItems(
    String userId,
    MediaType mediaType,
  ) {
    return _remoteDS
        .watchUserWatchedItems(userId, mediaType)
        .map((dtos) => dtos.map((dto) => dto.toEntity()).toList());
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
    int? runtimeMinutes,
    required TVSeries series,
  }) async {
    // 1. Mark this episode as watched
    final episodeDto = WatchedEpisodeDto(
      userId: userId,
      seriesId: seriesId,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
      watchedAt: DateTime.now(),
      runtimeMinutes: runtimeMinutes,
    );
    await _remoteDS.markEpisodeAsWatched(episodeDto);

    // 2. Refresh count and check if all episodes are watched
    final totalEpisodes = series.seasons
        .where((s) => s.seasonNumber > 0)
        .fold(0, (sum, s) => sum + s.episodeCount);

    final watchedCount = await _remoteDS.getWatchedEpisodesCount(
      userId: userId,
      seriesId: seriesId,
    );

    if (watchedCount >= totalEpisodes) {
      final avgRuntime = series.episodeRunTime.isNotEmpty
          ? series.episodeRunTime.first
          : 0;
      final totalRuntime =
          (watchedCount > 0 ? watchedCount : totalEpisodes) * avgRuntime;

      // Mark as complete in watched_items. isWatchLater is explicitly reset
      // here (not left to the DTO default) because this is the single
      // write path shared by both the per-episode toggle and the bulk
      // "mark watched" action: any new episode watched must clear a
      // previous "watch later" postponement.
      final seriesDto = WatchedItemDto(
        userId: userId,
        mediaId: seriesId,
        mediaTitle: seriesTitle,
        mediaType: MediaType.tv.name,
        posterPath: seriesPosterPath,
        watchedAt: DateTime.now(),
        runtimeMinutes: totalRuntime > 0 ? totalRuntime : null,
        isWatchLater: false,
      );
      await _remoteDS.markAsWatched(seriesDto);
    } else {
      // Update the series item but don't mark as full runtime yet
      // (or we could sum the episodes seen so far). isWatchLater is
      // explicitly reset here for the same reason as the branch above.
      final seriesDto = WatchedItemDto(
        userId: userId,
        mediaId: seriesId,
        mediaTitle: seriesTitle,
        mediaType: MediaType.tv.name,
        posterPath: seriesPosterPath,
        watchedAt: DateTime.now(),
        isWatchLater: false,
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
  Future<Map<int, int>> getWatchedEpisodesCountsForSeries({
    required String userId,
    required List<int> seriesIds,
  }) async {
    return _remoteDS.getWatchedEpisodesCountsForSeries(
      userId: userId,
      seriesIds: seriesIds,
    );
  }

  @override
  Stream<List<String>> watchWatchedEpisodes(String userId, int seriesId) {
    return _remoteDS
        .watchWatchedEpisodes(userId, seriesId)
        .map(
          (dtos) =>
              dtos.map((e) => 's${e.seasonNumber}e${e.episodeNumber}').toList(),
        );
  }

  @override
  Future<void> markSeriesAsDropped({
    required String userId,
    required int seriesId,
    required bool isDropped,
  }) {
    return _remoteDS.markSeriesAsDropped(
      userId: userId,
      seriesId: seriesId,
      isDropped: isDropped,
    );
  }

  @override
  Future<void> markSeriesAsWatchLater({
    required String userId,
    required int seriesId,
    required bool isWatchLater,
  }) {
    return _remoteDS.markSeriesAsWatchLater(
      userId: userId,
      seriesId: seriesId,
      isWatchLater: isWatchLater,
    );
  }
}

@riverpod
IWatchedRepository watchedRepository(Ref ref) {
  return WatchedRepositoryImpl(ref.watch(watchedRemoteDataSourceProvider));
}
