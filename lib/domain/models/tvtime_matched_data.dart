import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmania/domain/models/media_type.dart';

part 'tvtime_matched_data.freezed.dart';

@freezed
abstract class TvTimeMatchedMovie with _$TvTimeMatchedMovie {
  const factory TvTimeMatchedMovie({
    required int tmdbId,
    required String title,
    String? posterPath,
    DateTime? watchedAt,
  }) = _TvTimeMatchedMovie;
}

@freezed
abstract class TvTimeMatchedEpisode with _$TvTimeMatchedEpisode {
  const factory TvTimeMatchedEpisode({
    required int seriesTmdbId,
    required String seriesTitle,
    String? seriesPosterPath,
    required int seasonNumber,
    required int episodeNumber,
    DateTime? watchedAt,
    @Default(false) bool isDropped,
    @Default(false) bool isWatchLater,
  }) = _TvTimeMatchedEpisode;
}

@freezed
abstract class TvTimeMatchedListItem with _$TvTimeMatchedListItem {
  const factory TvTimeMatchedListItem({
    required int tmdbId,
    required String title,
    required MediaType mediaType,
    String? posterPath,
  }) = _TvTimeMatchedListItem;
}

@freezed
abstract class TvTimeMatchedList with _$TvTimeMatchedList {
  const factory TvTimeMatchedList({
    required String name,
    required List<TvTimeMatchedListItem> items,
  }) = _TvTimeMatchedList;
}

/// Un elemento che NON è stato trovato su TMDB (imdb_id/tvdb_id senza match).
@freezed
abstract class UnmatchedTvTimeItem with _$UnmatchedTvTimeItem {
  const factory UnmatchedTvTimeItem({
    required String type, // "movie" | "series"
    required String title,
    required String reason,
  }) = _UnmatchedTvTimeItem;
}

/// Risultato completo del matching: usato SIA per mostrare la preview
/// (conteggi calcolati dai .length delle liste) SIA per scrivere davvero su
/// Supabase dopo la conferma — un solo oggetto, niente doppio modello.
@freezed
abstract class TvTimeMatchResult with _$TvTimeMatchResult {
  const factory TvTimeMatchResult({
    required List<TvTimeMatchedMovie> movies,
    required List<TvTimeMatchedEpisode> episodes,
    required List<TvTimeMatchedList> lists,
    required List<UnmatchedTvTimeItem> unmatched,
  }) = _TvTimeMatchResult;
}
