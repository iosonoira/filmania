// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_episode_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TVEpisodeDto _$TVEpisodeDtoFromJson(Map<String, dynamic> json) =>
    _TVEpisodeDto(
      id: (json['id'] as num).toInt(),
      episodeNumber: (json['episode_number'] as num).toInt(),
      seasonNumber: (json['season_number'] as num).toInt(),
      name: json['name'] as String,
      overview: json['overview'] as String,
      stillPath: json['still_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      airDate: json['air_date'] as String?,
      runtime: (json['runtime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TVEpisodeDtoToJson(_TVEpisodeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'episode_number': instance.episodeNumber,
      'season_number': instance.seasonNumber,
      'name': instance.name,
      'overview': instance.overview,
      'still_path': instance.stillPath,
      'vote_average': instance.voteAverage,
      'air_date': instance.airDate,
      'runtime': instance.runtime,
    };
