// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStatsDto _$UserStatsDtoFromJson(Map<String, dynamic> json) =>
    _UserStatsDto(
      moviesWatchedCount: (json['movies_watched_count'] as num).toInt(),
      tvSeriesWatchedCount: (json['tv_series_watched_count'] as num).toInt(),
      episodesWatchedCount: (json['episodes_watched_count'] as num).toInt(),
      totalWatchTimeMinutes: (json['total_watch_time_minutes'] as num).toInt(),
      moviesWatchTimeMinutes: (json['movies_watch_time_minutes'] as num)
          .toInt(),
      tvWatchTimeMinutes: (json['tv_watch_time_minutes'] as num).toInt(),
      lastUpdatedAt: json['last_updated_at'] == null
          ? null
          : DateTime.parse(json['last_updated_at'] as String),
    );

Map<String, dynamic> _$UserStatsDtoToJson(_UserStatsDto instance) =>
    <String, dynamic>{
      'movies_watched_count': instance.moviesWatchedCount,
      'tv_series_watched_count': instance.tvSeriesWatchedCount,
      'episodes_watched_count': instance.episodesWatchedCount,
      'total_watch_time_minutes': instance.totalWatchTimeMinutes,
      'movies_watch_time_minutes': instance.moviesWatchTimeMinutes,
      'tv_watch_time_minutes': instance.tvWatchTimeMinutes,
      'last_updated_at': instance.lastUpdatedAt?.toIso8601String(),
    };
