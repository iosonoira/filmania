// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watched_episode_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchedEpisodeDto _$WatchedEpisodeDtoFromJson(Map<String, dynamic> json) =>
    _WatchedEpisodeDto(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      seriesId: (json['series_id'] as num).toInt(),
      seasonNumber: (json['season_number'] as num).toInt(),
      episodeNumber: (json['episode_number'] as num).toInt(),
      watchedAt: json['watched_at'] == null
          ? null
          : DateTime.parse(json['watched_at'] as String),
      runtimeMinutes: (json['runtime_minutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WatchedEpisodeDtoToJson(_WatchedEpisodeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'series_id': instance.seriesId,
      'season_number': instance.seasonNumber,
      'episode_number': instance.episodeNumber,
      'watched_at': instance.watchedAt?.toIso8601String(),
      'runtime_minutes': instance.runtimeMinutes,
    };
