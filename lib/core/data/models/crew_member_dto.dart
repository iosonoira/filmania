import 'package:filmania/domain/models/crew_member.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'crew_member_dto.freezed.dart';
part 'crew_member_dto.g.dart';

@freezed
abstract class CrewMemberDto with _$CrewMemberDto {
  const factory CrewMemberDto({
    required int id,
    required String name,
    required String job,
    required String department,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _CrewMemberDto;

  factory CrewMemberDto.fromJson(Map<String, dynamic> json) =>
      _$CrewMemberDtoFromJson(json);

  const CrewMemberDto._();

  CrewMember toEntity() {
    return CrewMember(
      id: id,
      name: name,
      job: job,
      department: department,
      profilePath: profilePath,
    );
  }
}
