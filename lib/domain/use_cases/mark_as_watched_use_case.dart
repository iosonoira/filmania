import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/data/repositories/movies/i_movies_repository.dart';
import 'package:filmania/data/repositories/movies/movies_repository_impl.dart';
import 'package:filmania/data/repositories/tv_series/i_tv_series_repository.dart';
import 'package:filmania/data/repositories/tv_series/tv_series_repository_impl.dart';
import 'package:filmania/data/repositories/watched/i_watched_repository.dart';
import 'package:filmania/data/repositories/watched/watched_repository_impl.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/domain/models/watched_item.dart';

part 'mark_as_watched_use_case.g.dart';

/// Marking something as watched needs TMDB data (a movie's runtime, a
/// series' episode list) on top of the user's watched list. The Flutter
/// architecture guide keeps repositories unaware of each other and puts
/// logic repeated across view models in a use case: the watched button,
/// the episode button and the bulk actions all go through here.
class MarkAsWatchedUseCase {
  MarkAsWatchedUseCase({
    required IWatchedRepository watched,
    required IMoviesRepository movies,
    required ITVSeriesRepository tvSeries,
  }) : _watched = watched,
       _movies = movies,
       _tvSeries = tvSeries;

  final IWatchedRepository _watched;
  final IMoviesRepository _movies;
  final ITVSeriesRepository _tvSeries;

  /// Marks a movie, or a whole series with all its episodes.
  ///
  /// A movie without a runtime gets it from TMDB on a best-effort basis:
  /// if the lookup fails it is stored without one rather than not at all.
  Future<void> markMedia(WatchedItem item) async {
    if (item.mediaType == MediaType.tv) {
      final series = await _tvSeries.getTVSeriesDetails(item.mediaId);
      return _watched.markSeriesAsWatched(item, series);
    }

    var runtime = item.runtimeMinutes;
    if (runtime == null) {
      try {
        runtime = (await _movies.getMovieDetails(item.mediaId)).runtime;
      } catch (_) {
        // Fallback to null if fetch fails
      }
    }
    return _watched.markMovieAsWatched(item.copyWith(runtimeMinutes: runtime));
  }

  /// Marks one episode and updates the series' progress.
  ///
  /// The series details are fetched before anything is written, so a TMDB
  /// failure leaves the watched list untouched instead of half-updated.
  Future<void> markEpisode({
    required String userId,
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
    required String seriesTitle,
    String? seriesPosterPath,
    int? runtimeMinutes,
  }) async {
    final series = await _tvSeries.getTVSeriesDetails(seriesId);
    return _watched.markEpisodeAsWatched(
      userId: userId,
      seriesId: seriesId,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
      seriesTitle: seriesTitle,
      seriesPosterPath: seriesPosterPath,
      runtimeMinutes: runtimeMinutes,
      series: series,
    );
  }
}

@riverpod
MarkAsWatchedUseCase markAsWatchedUseCase(Ref ref) {
  return MarkAsWatchedUseCase(
    watched: ref.watch(watchedRepositoryProvider),
    movies: ref.watch(moviesRepositoryProvider),
    tvSeries: ref.watch(tvSeriesRepositoryProvider),
  );
}
