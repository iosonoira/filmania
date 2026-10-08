import 'package:filmania/data/models/person_credit_dto.dart';
import 'package:filmania/domain/models/person_credit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_combined_credits_dto.freezed.dart';
part 'person_combined_credits_dto.g.dart';

@freezed
abstract class PersonCombinedCreditsDto with _$PersonCombinedCreditsDto {
  const factory PersonCombinedCreditsDto({
    @Default([]) List<PersonCreditDto> cast,
    @Default([]) List<PersonCreditDto> crew,
  }) = _PersonCombinedCreditsDto;

  factory PersonCombinedCreditsDto.fromJson(Map<String, dynamic> json) =>
      _$PersonCombinedCreditsDtoFromJson(json);

  const PersonCombinedCreditsDto._();

  List<PersonCredit> toEntity() {
    final seenKeys = <String>{};
    final credits = <PersonCredit>[];

    for (final dto in [...cast, ...crew]) {
      final key = '${dto.mediaType.name}_${dto.id}';
      if (seenKeys.add(key)) {
        credits.add(dto.toEntity());
      }
    }

    credits.sort((a, b) => (b.releaseYear ?? 0).compareTo(a.releaseYear ?? 0));
    return credits;
  }
}
