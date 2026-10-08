// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoriteItemDto _$FavoriteItemDtoFromJson(Map<String, dynamic> json) =>
    _FavoriteItemDto(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String,
      mediaId: (json['media_id'] as num).toInt(),
      mediaTitle: json['media_title'] as String,
      mediaType: json['media_type'] as String,
      posterPath: json['poster_path'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FavoriteItemDtoToJson(_FavoriteItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'media_id': instance.mediaId,
      'media_title': instance.mediaTitle,
      'media_type': instance.mediaType,
      'poster_path': instance.posterPath,
      'created_at': instance.createdAt?.toIso8601String(),
    };
