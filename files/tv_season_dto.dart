import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/tv_season.dart';

part 'tv_season_dto.freezed.dart';
part 'tv_season_dto.g.dart';

@freezed
abstract class TVSeasonDto with _$TVSeasonDto {
  const factory TVSeasonDto({
    required int id,
    @JsonKey(name: 'season_number') required int seasonNumber,
    required String name,
    @JsonKey(name: 'episode_count') int? episodeCount,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'air_date') String? airDate,
  }) = _TVSeasonDto;

  factory TVSeasonDto.fromJson(Map<String, dynamic> json) =>
      _$TVSeasonDtoFromJson(json);

  const TVSeasonDto._();

  TVSeason toEntity() => TVSeason(
    id: id,
    seasonNumber: seasonNumber,
    name: name,
    episodeCount: episodeCount ?? 0,
    posterPath: posterPath,
    airDate: airDate,
  );
}
