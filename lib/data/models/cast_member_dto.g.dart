// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CastMemberDto _$CastMemberDtoFromJson(Map<String, dynamic> json) =>
    _CastMemberDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      character: json['character'] as String,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$CastMemberDtoToJson(_CastMemberDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'character': instance.character,
      'profile_path': instance.profilePath,
    };
