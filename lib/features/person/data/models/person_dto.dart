import 'package:filmania/features/person/domain/entities/person.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_dto.freezed.dart';
part 'person_dto.g.dart';

@freezed
abstract class PersonDto with _$PersonDto {
  const factory PersonDto({
    required int id,
    required String name,
    String? biography,
    String? birthday,
    @JsonKey(name: 'place_of_birth') String? placeOfBirth,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _PersonDto;

  factory PersonDto.fromJson(Map<String, dynamic> json) =>
      _$PersonDtoFromJson(json);

  const PersonDto._();

  Person toEntity() {
    return Person(
      id: id,
      name: name,
      biography: biography ?? '',
      birthday: birthday != null ? DateTime.tryParse(birthday!) : null,
      placeOfBirth: placeOfBirth,
      profilePath: profilePath,
    );
  }
}
