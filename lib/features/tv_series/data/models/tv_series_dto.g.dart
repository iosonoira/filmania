// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_series_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TVSeriesDto _$TVSeriesDtoFromJson(Map<String, dynamic> json) => _TVSeriesDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  overview: json['overview'] as String,
  posterPath: json['poster_path'] as String?,
  backdropPath: json['backdrop_path'] as String?,
  firstAirDate: json['first_air_date'] as String?,
  voteAverage: (json['vote_average'] as num?)?.toDouble(),
  episodeRunTime:
      (json['episode_run_time'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  seasons:
      (json['seasons'] as List<dynamic>?)
          ?.map((e) => TVSeasonDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TVSeriesDtoToJson(_TVSeriesDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'first_air_date': instance.firstAirDate,
      'vote_average': instance.voteAverage,
      'episode_run_time': instance.episodeRunTime,
      'seasons': instance.seasons,
    };
