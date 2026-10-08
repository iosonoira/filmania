// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchlistDto _$WatchlistDtoFromJson(Map<String, dynamic> json) =>
    _WatchlistDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$WatchlistDtoToJson(_WatchlistDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'created_at': instance.createdAt.toIso8601String(),
    };
