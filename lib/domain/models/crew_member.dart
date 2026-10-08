import 'package:freezed_annotation/freezed_annotation.dart';

part 'crew_member.freezed.dart';

@freezed
abstract class CrewMember with _$CrewMember {
  const factory CrewMember({
    required int id,
    required String name,
    required String job,
    required String department,
    required String? profilePath,
  }) = _CrewMember;

  const CrewMember._();

  String? get fullProfileUrl => profilePath != null
      ? 'https://image.tmdb.org/t/p/w185$profilePath'
      : null;
}
