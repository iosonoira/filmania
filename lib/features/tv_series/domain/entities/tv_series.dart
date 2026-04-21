import 'package:freezed_annotation/freezed_annotation.dart';
import 'tv_season.dart';

part 'tv_series.freezed.dart';

@freezed
abstract class TVSeries with _$TVSeries {
  const factory TVSeries({
    required int id,
    required String name,
    required String overview,
    required String? posterPath,
    required String? backdropPath,
    required DateTime? firstAirDate,
    required double voteAverage,
    @Default([]) List<TVSeason> seasons,
  }) = _TVSeries;

  const TVSeries._();

  String? get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;

  String? get fullBackdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : null;
}
