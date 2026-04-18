import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_episode.freezed.dart';

@freezed
abstract class TVEpisode with _$TVEpisode {
  const factory TVEpisode({
    required int id,
    required int episodeNumber,
    required int seasonNumber,
    required String name,
    required String overview,
    required String? stillPath,
    required double voteAverage,
    required String? airDate,
    required int? runtime,
  }) = _TVEpisode;

  const TVEpisode._();

  String? get fullStillUrl =>
      stillPath != null ? 'https://image.tmdb.org/t/p/w300$stillPath' : null;
}
