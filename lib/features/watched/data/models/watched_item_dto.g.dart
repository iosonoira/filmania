// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watched_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchedItemDto _$WatchedItemDtoFromJson(Map<String, dynamic> json) =>
    _WatchedItemDto(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String,
      mediaId: (json['media_id'] as num).toInt(),
      mediaTitle: json['media_title'] as String,
      mediaType: json['media_type'] as String,
      posterPath: json['poster_path'] as String?,
      watchedAt: json['watched_at'] == null
          ? null
          : DateTime.parse(json['watched_at'] as String),
      runtimeMinutes: (json['runtime_minutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WatchedItemDtoToJson(_WatchedItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'media_id': instance.mediaId,
      'media_title': instance.mediaTitle,
      'media_type': instance.mediaType,
      'poster_path': instance.posterPath,
      'watched_at': instance.watchedAt?.toIso8601String(),
      'runtime_minutes': instance.runtimeMinutes,
    };
