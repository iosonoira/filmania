import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmania/data/models/cast_member_dto.dart';
import 'package:filmania/data/models/crew_member_dto.dart';
import 'package:filmania/domain/models/credits.dart';

part 'credits_dto.freezed.dart';
part 'credits_dto.g.dart';

@freezed
abstract class CreditsDto with _$CreditsDto {
  const factory CreditsDto({
    @Default([]) List<CastMemberDto> cast,
    @Default([]) List<CrewMemberDto> crew,
  }) = _CreditsDto;

  factory CreditsDto.fromJson(Map<String, dynamic> json) =>
      _$CreditsDtoFromJson(json);

  const CreditsDto._();

  Credits toEntity() {
    return Credits(
      cast: cast.map((dto) => dto.toEntity()).toList(),
      crew: crew.map((dto) => dto.toEntity()).toList(),
    );
  }
}
