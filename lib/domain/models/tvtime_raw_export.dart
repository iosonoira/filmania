import 'package:freezed_annotation/freezed_annotation.dart';

part 'tvtime_raw_export.freezed.dart';

/// Una riga grezza di `tvtime-movies-*.csv`, PRIMA del matching TMDB.
@freezed
abstract class TvTimeRawMovieRow with _$TvTimeRawMovieRow {
  const factory TvTimeRawMovieRow({
    required String uuid,
    required String imdbId,
    required String tvdbId,
    required String title,
    required bool isWatched,
    String? watchedAt,
    String? createdAt,
  }) = _TvTimeRawMovieRow;
}

/// Una riga grezza di `tvtime-series-episodes-*.csv`, PRIMA del matching TMDB.
@freezed
abstract class TvTimeRawEpisodeRow with _$TvTimeRawEpisodeRow {
  const factory TvTimeRawEpisodeRow({
    required String seriesTvdbId,
    required String seriesTitleHint,
    required int season,
    required int episode,
    required bool isWatched,
    // `special=true` indica che questa riga è una entry TVDB "special"
    // (recap/OVA/extra) che collide sullo stesso (season, episode) di un
    // episodio regolare nello stesso export. Vedi TvTimeArchiveParser per
    // il dedup che usa questo campo.
    required bool special,
    String? watchedAt,
  }) = _TvTimeRawEpisodeRow;
}

/// Una riga grezza di `tvtime-lists-*.csv`, PRIMA del matching TMDB.
@freezed
abstract class TvTimeRawListRow with _$TvTimeRawListRow {
  const factory TvTimeRawListRow({
    required String listName,
    required String itemType, // "movie" | "series"
    required String uuid,
    required String tvdbId,
    required String nameHint,
  }) = _TvTimeRawListRow;
}

/// Una riga grezza di `tvtime-series-*.csv` (metadati/status delle serie,
/// file DIVERSO da `tvtime-series-episodes-*.csv`), PRIMA del matching TMDB.
@freezed
abstract class TvTimeRawSeriesRow with _$TvTimeRawSeriesRow {
  const factory TvTimeRawSeriesRow({
    required String tvdbId,
    required String status, // es. "stopped", "up_to_date", "continuing", ...
  }) = _TvTimeRawSeriesRow;
}

/// Contenuto grezzo completo estratto dallo zip, prima del matching.
@freezed
abstract class TvTimeRawExport with _$TvTimeRawExport {
  const factory TvTimeRawExport({
    required List<TvTimeRawMovieRow> movies,
    required List<TvTimeRawEpisodeRow> episodes,
    required List<TvTimeRawListRow> lists,
    @Default([]) List<TvTimeRawSeriesRow> series,
  }) = _TvTimeRawExport;
}
