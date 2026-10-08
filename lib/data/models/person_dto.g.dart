// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonDto _$PersonDtoFromJson(Map<String, dynamic> json) => _PersonDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  biography: json['biography'] as String?,
  birthday: json['birthday'] as String?,
  placeOfBirth: json['place_of_birth'] as String?,
  profilePath: json['profile_path'] as String?,
);

Map<String, dynamic> _$PersonDtoToJson(_PersonDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'biography': instance.biography,
      'birthday': instance.birthday,
      'place_of_birth': instance.placeOfBirth,
      'profile_path': instance.profilePath,
    };
