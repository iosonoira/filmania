// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchlistItemDto _$WatchlistItemDtoFromJson(Map<String, dynamic> json) =>
    _WatchlistItemDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mediaId: (json['movie_id'] as num).toInt(),
      title: json['movie_title'] as String,
      mediaType:
          $enumDecodeNullable(_$DiscoverMediaTypeEnumMap, json['media_type']) ??
          DiscoverMediaType.movie,
      posterPath: json['poster_path'] as String?,
      addedAt: DateTime.parse(json['added_at'] as String),
    );

Map<String, dynamic> _$WatchlistItemDtoToJson(_WatchlistItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'movie_id': instance.mediaId,
      'movie_title': instance.title,
      'media_type': _$DiscoverMediaTypeEnumMap[instance.mediaType]!,
      'poster_path': instance.posterPath,
      'added_at': instance.addedAt.toIso8601String(),
    };

const _$DiscoverMediaTypeEnumMap = {
  DiscoverMediaType.movie: 'movie',
  DiscoverMediaType.tv: 'tv',
};
