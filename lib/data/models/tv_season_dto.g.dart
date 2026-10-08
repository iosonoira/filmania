// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_season_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TVSeasonDto _$TVSeasonDtoFromJson(Map<String, dynamic> json) => _TVSeasonDto(
  id: (json['id'] as num).toInt(),
  seasonNumber: (json['season_number'] as num).toInt(),
  name: json['name'] as String,
  episodeCount: (json['episode_count'] as num?)?.toInt(),
  posterPath: json['poster_path'] as String?,
  airDate: json['air_date'] as String?,
);

Map<String, dynamic> _$TVSeasonDtoToJson(_TVSeasonDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'season_number': instance.seasonNumber,
      'name': instance.name,
      'episode_count': instance.episodeCount,
      'poster_path': instance.posterPath,
      'air_date': instance.airDate,
    };
