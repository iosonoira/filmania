import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/tv_episode.dart';

part 'tv_episode_dto.freezed.dart';
part 'tv_episode_dto.g.dart';

@freezed
abstract class TVEpisodeDto with _$TVEpisodeDto {
  const factory TVEpisodeDto({
    required int id,
    @JsonKey(name: 'episode_number') required int episodeNumber,
    @JsonKey(name: 'season_number') required int seasonNumber,
    required String name,
    required String overview,
    @JsonKey(name: 'still_path') String? stillPath,
    @JsonKey(name: 'vote_average') double? voteAverage,
    @JsonKey(name: 'air_date') String? airDate,
    int? runtime,
  }) = _TVEpisodeDto;

  factory TVEpisodeDto.fromJson(Map<String, dynamic> json) =>
      _$TVEpisodeDtoFromJson(json);

  const TVEpisodeDto._();

  TVEpisode toEntity() => TVEpisode(
    id: id,
    episodeNumber: episodeNumber,
    seasonNumber: seasonNumber,
    name: name,
    overview: overview,
    stillPath: stillPath,
    voteAverage: voteAverage ?? 0.0,
    airDate: airDate,
    runtime: runtime,
  );
}
