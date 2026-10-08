import 'package:filmania/domain/models/cast_member.dart';
import 'package:filmania/domain/models/credits.dart';
import 'package:filmania/domain/models/genre.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/domain/models/movie.dart';
import 'package:filmania/features/movies/domain/repositories/i_movies_repository.dart';
import 'package:filmania/domain/models/tv_episode.dart';
import 'package:filmania/domain/models/tv_season.dart';
import 'package:filmania/domain/models/tv_series.dart';
import 'package:filmania/features/tv_series/domain/repositories/i_tv_series_repository.dart';
import 'package:filmania/features/watched/data/datasources/i_watched_remote_datasource.dart';
import 'package:filmania/features/watched/data/models/watched_episode_dto.dart';
import 'package:filmania/features/watched/data/models/watched_item_dto.dart';
import 'package:filmania/features/watched/data/repositories/watched_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal fake covering only what [WatchedRepositoryImpl] calls. Every
/// unused member throws so the test fails loudly if the production code
/// starts relying on a method this fake doesn't implement.
class _FakeWatchedRemoteDataSource implements IWatchedRemoteDataSource {
  WatchedItemDto? lastMarkAsWatchedDto;
  int markAsWatchedCallCount = 0;
  int watchedEpisodesCount = 0;

  @override
  Future<void> markAsWatched(WatchedItemDto item) async {
    markAsWatchedCallCount++;
    lastMarkAsWatchedDto = item;
  }

  @override
  Future<void> markEpisodeAsWatched(WatchedEpisodeDto episode) async {}

  @override
  Future<int> getWatchedEpisodesCount({
    required String userId,
    required int seriesId,
  }) async {
    return watchedEpisodesCount;
  }

  @override
  Future<void> markEpisodesAsWatched(List<WatchedEpisodeDto> episodes) {
    throw UnimplementedError();
  }

  @override
  Future<void> markTVSeriesAsWatchedBatchRPC({
    required int seriesId,
    required String seriesTitle,
    required String? posterPath,
    required List<Map<String, int>> episodes,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeFromWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<WatchedItemDto>> watchUserWatchedItems(
    String userId,
    MediaType mediaType,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> markEpisodeAsUnwatched({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isEpisodeWatched({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<WatchedEpisodeDto>> watchWatchedEpisodes(
    String userId,
    int seriesId,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeAllEpisodesFromWatched({
    required String userId,
    required int seriesId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Map<int, int>> getWatchedEpisodesCountsForSeries({
    required String userId,
    required List<int> seriesIds,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> markSeriesAsDropped({
    required String userId,
    required int seriesId,
    required bool isDropped,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> markSeriesAsWatchLater({
    required String userId,
    required int seriesId,
    required bool isWatchLater,
  }) {
    throw UnimplementedError();
  }
}

/// Minimal fake covering only [getTVSeriesDetails], the only method
/// [WatchedRepositoryImpl.markEpisodeAsWatched] calls on this repository.
class _FakeTVSeriesRepository implements ITVSeriesRepository {
  _FakeTVSeriesRepository(this.series);

  final TVSeries series;

  @override
  Future<TVSeries> getTVSeriesDetails(int tvId) async => series;

  @override
  Future<List<TVSeries>> getTrendingTVSeries({int page = 1}) {
    throw UnimplementedError();
  }

  @override
  Future<List<TVSeries>> discoverTVSeries({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<TVSeries>> searchTVSeries(String query, {int page = 1}) {
    throw UnimplementedError();
  }

  @override
  Future<List<TVEpisode>> getSeasonEpisodes(int tvId, int seasonNumber) {
    throw UnimplementedError();
  }

  @override
  Future<TVEpisode> getTVEpisodeDetails(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<Credits> getTVSeriesCredits(int tvId) {
    throw UnimplementedError();
  }

  @override
  Future<List<CastMember>> getTVEpisodeCredits(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<List<TVSeries>> getTVSeriesRecommendations(int tvId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Genre>> getGenres() {
    throw UnimplementedError();
  }
}

/// Not exercised by markEpisodeAsWatched, but required by the constructor.
class _FakeMoviesRepository implements IMoviesRepository {
  @override
  Future<Movie> getMovieDetails(int movieId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> getTrendingMovies({int page = 1}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> discoverMovies({
    int page = 1,
    List<int> genreIds = const [],
    int? yearFrom,
    int? yearTo,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> searchMovies(String query, {int page = 1}) {
    throw UnimplementedError();
  }

  @override
  Future<Credits> getMovieCredits(int movieId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> getMovieRecommendations(int movieId) {
    throw UnimplementedError();
  }

  @override
  Future<List<Genre>> getGenres() {
    throw UnimplementedError();
  }
}

TVSeries _buildSeries({required int totalEpisodesInSeason}) {
  return TVSeries(
    id: 1,
    name: 'Breaking Bad',
    overview: '',
    posterPath: null,
    backdropPath: null,
    firstAirDate: null,
    voteAverage: 8.9,
    episodeRunTime: const [45],
    seasons: [
      TVSeason(
        id: 100,
        seasonNumber: 1,
        name: 'Season 1',
        episodeCount: totalEpisodesInSeason,
        posterPath: null,
        airDate: null,
      ),
      // A "specials" season (seasonNumber == 0) must be excluded from the
      // totalEpisodes calculation.
      const TVSeason(
        id: 99,
        seasonNumber: 0,
        name: 'Specials',
        episodeCount: 999,
        posterPath: null,
        airDate: null,
      ),
    ],
  );
}

void main() {
  group('WatchedRepositoryImpl.markEpisodeAsWatched — reset-on-watch', () {
    test(
      'resets isWatchLater to false when the series becomes complete',
      () async {
        final series = _buildSeries(totalEpisodesInSeason: 7);
        final remoteDS = _FakeWatchedRemoteDataSource()
          ..watchedEpisodesCount = 7; // watchedCount >= totalEpisodes (7)
        final tvRepo = _FakeTVSeriesRepository(series);
        final repository = WatchedRepositoryImpl(
          remoteDS,
          tvRepo,
          _FakeMoviesRepository(),
        );

        await repository.markEpisodeAsWatched(
          userId: 'user-1',
          seriesId: 1,
          seasonNumber: 1,
          episodeNumber: 7,
          seriesTitle: 'Breaking Bad',
        );

        expect(remoteDS.markAsWatchedCallCount, 1);
        expect(remoteDS.lastMarkAsWatchedDto, isNotNull);
        expect(remoteDS.lastMarkAsWatchedDto!.isWatchLater, isFalse);
      },
    );

    test(
      'resets isWatchLater to false when the series is still in progress',
      () async {
        final series = _buildSeries(totalEpisodesInSeason: 10);
        final remoteDS = _FakeWatchedRemoteDataSource()
          ..watchedEpisodesCount = 3; // watchedCount < totalEpisodes (10)
        final tvRepo = _FakeTVSeriesRepository(series);
        final repository = WatchedRepositoryImpl(
          remoteDS,
          tvRepo,
          _FakeMoviesRepository(),
        );

        await repository.markEpisodeAsWatched(
          userId: 'user-1',
          seriesId: 1,
          seasonNumber: 1,
          episodeNumber: 3,
          seriesTitle: 'Breaking Bad',
        );

        expect(remoteDS.markAsWatchedCallCount, 1);
        expect(remoteDS.lastMarkAsWatchedDto, isNotNull);
        expect(remoteDS.lastMarkAsWatchedDto!.isWatchLater, isFalse);
      },
    );
  });
}
