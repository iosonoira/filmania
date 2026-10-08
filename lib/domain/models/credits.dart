import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmania/domain/models/cast_member.dart';
import 'package:filmania/domain/models/crew_member.dart';

part 'credits.freezed.dart';

@freezed
abstract class Credits with _$Credits {
  const factory Credits({
    required List<CastMember> cast,
    required List<CrewMember> crew,
  }) = _Credits;
}
