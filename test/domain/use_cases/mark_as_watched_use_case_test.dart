import 'package:filmania/data/repositories/movies/i_movies_repository.dart';
import 'package:filmania/data/repositories/tv_series/i_tv_series_repository.dart';
import 'package:filmania/data/repositories/watched/i_watched_repository.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/domain/models/movie.dart';
import 'package:filmania/domain/models/tv_season.dart';
import 'package:filmania/domain/models/tv_series.dart';
import 'package:filmania/domain/models/watched_item.dart';
import 'package:filmania/domain/use_cases/mark_as_watched_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

// The fakes implement only what [MarkAsWatchedUseCase] calls; every other
// member throws through noSuchMethod, so a test fails loudly if the use case
// starts relying on something not covered here.

/// Records the writes the use case makes.
class _FakeWatchedRepository implements IWatchedRepository {
  WatchedItem? movieItem;
  WatchedItem? seriesItem;
  TVSeries? seriesPassed;
  int episodeWrites = 0;

  @override
  Future<void> markMovieAsWatched(WatchedItem item) async => movieItem = item;

  @override
  Future<void> markSeriesAsWatched(WatchedItem item, TVSeries series) async {
    seriesItem = item;
    seriesPassed = series;
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
    episodeWrites++;
    seriesPassed = series;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// A null [series] simulates a TMDB failure.
class _FakeTVSeriesRepository implements ITVSeriesRepository {
  _FakeTVSeriesRepository(this.series);

  final TVSeries? series;

  @override
  Future<TVSeries> getTVSeriesDetails(int tvId) async {
    final result = series;
    if (result == null) throw Exception('TMDB unavailable');
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// A null [runtime] simulates a TMDB failure.
class _FakeMoviesRepository implements IMoviesRepository {
  _FakeMoviesRepository({this.runtime});

  final int? runtime;
  int detailsCallCount = 0;

  @override
  Future<Movie> getMovieDetails(int movieId) async {
    detailsCallCount++;
    final result = runtime;
    if (result == null) throw Exception('TMDB unavailable');
    return Movie(
      id: movieId,
      title: 'Heat',
      overview: '',
      posterPath: null,
      backdropPath: null,
      releaseDate: null,
      voteAverage: 8.3,
      runtime: result,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

const _series = TVSeries(
  id: 1,
  name: 'Breaking Bad',
  overview: '',
  posterPath: null,
  backdropPath: null,
  firstAirDate: null,
  voteAverage: 8.9,
  episodeRunTime: [45],
  seasons: [
    TVSeason(
      id: 100,
      seasonNumber: 1,
      name: 'Season 1',
      episodeCount: 7,
      posterPath: null,
      airDate: null,
    ),
  ],
);

WatchedItem _item(MediaType type, {int? runtime}) => WatchedItem(
  id: '',
  userId: 'user-1',
  mediaId: 1,
  mediaTitle: 'Title',
  mediaType: type,
  watchedAt: DateTime(2026, 10, 8),
  runtimeMinutes: runtime,
);

MarkAsWatchedUseCase _useCase(
  _FakeWatchedRepository watched, {
  TVSeries? series,
  _FakeMoviesRepository? movies,
}) => MarkAsWatchedUseCase(
  watched: watched,
  movies: movies ?? _FakeMoviesRepository(),
  tvSeries: _FakeTVSeriesRepository(series),
);

void main() {
  group('MarkAsWatchedUseCase.markMedia', () {
    test('passes the TMDB series details to the watched repository', () async {
      final watched = _FakeWatchedRepository();

      await _useCase(watched, series: _series).markMedia(_item(MediaType.tv));

      expect(watched.seriesItem?.mediaId, 1);
      expect(watched.seriesPassed, _series);
      expect(watched.movieItem, isNull);
    });

    test('fills a missing movie runtime from TMDB', () async {
      final watched = _FakeWatchedRepository();

      await _useCase(
        watched,
        movies: _FakeMoviesRepository(runtime: 170),
      ).markMedia(_item(MediaType.movie));

      expect(watched.movieItem?.runtimeMinutes, 170);
    });

    test('keeps a known runtime without asking TMDB', () async {
      final watched = _FakeWatchedRepository();
      final movies = _FakeMoviesRepository(runtime: 170);

      await _useCase(
        watched,
        movies: movies,
      ).markMedia(_item(MediaType.movie, runtime: 120));

      expect(watched.movieItem?.runtimeMinutes, 120);
      expect(movies.detailsCallCount, 0);
    });

    test('still stores the movie when the TMDB lookup fails', () async {
      final watched = _FakeWatchedRepository();

      await _useCase(watched).markMedia(_item(MediaType.movie));

      expect(watched.movieItem, isNotNull);
      expect(watched.movieItem?.runtimeMinutes, isNull);
    });
  });

  group('MarkAsWatchedUseCase.markEpisode', () {
    Future<void> markFirstEpisode(MarkAsWatchedUseCase useCase) =>
        useCase.markEpisode(
          userId: 'user-1',
          seriesId: 1,
          seasonNumber: 1,
          episodeNumber: 1,
          seriesTitle: 'Breaking Bad',
        );

    test('passes the TMDB series details to the watched repository', () async {
      final watched = _FakeWatchedRepository();

      await markFirstEpisode(_useCase(watched, series: _series));

      expect(watched.episodeWrites, 1);
      expect(watched.seriesPassed, _series);
    });

    test('writes nothing when the series details cannot be fetched', () async {
      final watched = _FakeWatchedRepository();

      await expectLater(markFirstEpisode(_useCase(watched)), throwsException);

      expect(watched.episodeWrites, 0);
    });
  });
}
