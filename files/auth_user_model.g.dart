// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserDto _$AuthUserDtoFromJson(Map<String, dynamic> json) => AuthUserDto(
  id: json['id'] as String,
  email: json['email'] as String,
  displayName: json['display_name'] as String?,
  photoUrl: json['photo_url'] as String?,
);

Map<String, dynamic> _$AuthUserDtoToJson(AuthUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'display_name': instance.displayName,
      'photo_url': instance.photoUrl,
    };
