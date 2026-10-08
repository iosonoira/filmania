// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_combined_credits_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonCombinedCreditsDto _$PersonCombinedCreditsDtoFromJson(
  Map<String, dynamic> json,
) => _PersonCombinedCreditsDto(
  cast:
      (json['cast'] as List<dynamic>?)
          ?.map((e) => PersonCreditDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  crew:
      (json['crew'] as List<dynamic>?)
          ?.map((e) => PersonCreditDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PersonCombinedCreditsDtoToJson(
  _PersonCombinedCreditsDto instance,
) => <String, dynamic>{'cast': instance.cast, 'crew': instance.crew};
