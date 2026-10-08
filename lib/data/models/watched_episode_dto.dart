import 'package:freezed_annotation/freezed_annotation.dart';

part 'watched_episode_dto.freezed.dart';
part 'watched_episode_dto.g.dart';

@freezed
abstract class WatchedEpisodeDto with _$WatchedEpisodeDto {
  const WatchedEpisodeDto._();

  const factory WatchedEpisodeDto({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'series_id') required int seriesId,
    @JsonKey(name: 'season_number') required int seasonNumber,
    @JsonKey(name: 'episode_number') required int episodeNumber,
    @JsonKey(name: 'watched_at') DateTime? watchedAt,
    @JsonKey(name: 'runtime_minutes') int? runtimeMinutes,
  }) = _WatchedEpisodeDto;

  factory WatchedEpisodeDto.fromJson(Map<String, dynamic> json) =>
      _$WatchedEpisodeDtoFromJson(json);
}
