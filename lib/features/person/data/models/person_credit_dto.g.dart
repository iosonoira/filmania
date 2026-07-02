// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_credit_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonCreditDto _$PersonCreditDtoFromJson(Map<String, dynamic> json) =>
    _PersonCreditDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      name: json['name'] as String?,
      posterPath: json['poster_path'] as String?,
      releaseDate: json['release_date'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['media_type']),
    );

Map<String, dynamic> _$PersonCreditDtoToJson(_PersonCreditDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'name': instance.name,
      'poster_path': instance.posterPath,
      'release_date': instance.releaseDate,
      'first_air_date': instance.firstAirDate,
      'vote_average': instance.voteAverage,
      'media_type': _$MediaTypeEnumMap[instance.mediaType]!,
    };

const _$MediaTypeEnumMap = {MediaType.movie: 'movie', MediaType.tv: 'tv'};
