import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_season.freezed.dart';

@freezed
abstract class TVSeason with _$TVSeason {
  const factory TVSeason({
    required int id,
    required int seasonNumber,
    required String name,
    required int episodeCount,
    required String? posterPath,
    required String? airDate,
  }) = _TVSeason;

  const TVSeason._();

  String? get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w185$posterPath' : null;
}
