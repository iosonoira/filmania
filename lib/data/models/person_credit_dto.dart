import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/domain/models/person_credit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_credit_dto.freezed.dart';
part 'person_credit_dto.g.dart';

@freezed
abstract class PersonCreditDto with _$PersonCreditDto {
  const factory PersonCreditDto({
    required int id,
    String? title,
    String? name,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    @JsonKey(name: 'first_air_date') String? firstAirDate,
    @JsonKey(name: 'vote_average') double? voteAverage,
    @JsonKey(name: 'media_type') required MediaType mediaType,
  }) = _PersonCreditDto;

  factory PersonCreditDto.fromJson(Map<String, dynamic> json) =>
      _$PersonCreditDtoFromJson(json);

  const PersonCreditDto._();

  PersonCredit toEntity() {
    final dateStr = releaseDate ?? firstAirDate;
    return PersonCredit(
      mediaId: id,
      title: title ?? name ?? '',
      posterPath: posterPath,
      releaseYear: dateStr != null ? DateTime.tryParse(dateStr)?.year : null,
      voteAverage: voteAverage ?? 0.0,
      mediaType: mediaType,
    );
  }
}
