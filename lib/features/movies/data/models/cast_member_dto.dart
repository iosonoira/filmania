import 'package:filmania/features/movies/domain/entities/movie_credits.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cast_member_dto.freezed.dart';
part 'cast_member_dto.g.dart';

@freezed
abstract class CastMemberDto with _$CastMemberDto {
  const factory CastMemberDto({
    required int id,
    required String name,
    required String character,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _CastMemberDto;

  factory CastMemberDto.fromJson(Map<String, dynamic> json) => _$CastMemberDtoFromJson(json);

  const CastMemberDto._();

  CastMember toEntity() {
    return CastMember(
      id: id,
      name: name,
      character: character,
      profilePath: profilePath,
    );
  }
}
