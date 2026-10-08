// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credits_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreditsDto _$CreditsDtoFromJson(Map<String, dynamic> json) => _CreditsDto(
  cast:
      (json['cast'] as List<dynamic>?)
          ?.map((e) => CastMemberDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  crew:
      (json['crew'] as List<dynamic>?)
          ?.map((e) => CrewMemberDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CreditsDtoToJson(_CreditsDto instance) =>
    <String, dynamic>{'cast': instance.cast, 'crew': instance.crew};
