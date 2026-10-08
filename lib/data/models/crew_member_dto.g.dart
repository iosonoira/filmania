// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CrewMemberDto _$CrewMemberDtoFromJson(Map<String, dynamic> json) =>
    _CrewMemberDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      job: json['job'] as String,
      department: json['department'] as String,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$CrewMemberDtoToJson(_CrewMemberDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'job': instance.job,
      'department': instance.department,
      'profile_path': instance.profilePath,
    };
