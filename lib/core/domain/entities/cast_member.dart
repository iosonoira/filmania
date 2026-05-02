import 'package:freezed_annotation/freezed_annotation.dart';

part 'cast_member.freezed.dart';

@freezed
abstract class CastMember with _$CastMember {
  const factory CastMember({
    required int id,
    required String name,
    required String character,
    required String? profilePath,
  }) = _CastMember;

  const CastMember._();

  String? get fullProfileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : null;
}
