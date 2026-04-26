// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchlistItemDto _$WatchlistItemDtoFromJson(Map<String, dynamic> json) =>
    _WatchlistItemDto(
      id: json['id'] as String,
      watchlistId: json['watchlist_id'] as String,
      mediaId: (json['media_id'] as num).toInt(),
      title: json['media_title'] as String,
      mediaType:
          $enumDecodeNullable(_$MediaTypeEnumMap, json['media_type']) ??
          MediaType.movie,
      posterPath: json['poster_path'] as String?,
      addedAt: DateTime.parse(json['added_at'] as String),
    );

Map<String, dynamic> _$WatchlistItemDtoToJson(_WatchlistItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'watchlist_id': instance.watchlistId,
      'media_id': instance.mediaId,
      'media_title': instance.title,
      'media_type': _$MediaTypeEnumMap[instance.mediaType]!,
      'poster_path': instance.posterPath,
      'added_at': instance.addedAt.toIso8601String(),
    };

const _$MediaTypeEnumMap = {MediaType.movie: 'movie', MediaType.tv: 'tv'};
