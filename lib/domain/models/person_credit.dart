import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:filmania/domain/models/media_type.dart';

part 'person_credit.freezed.dart';

@freezed
abstract class PersonCredit with _$PersonCredit {
  const factory PersonCredit({
    required int mediaId,
    required String title,
    required String? posterPath,
    required int? releaseYear,
    required double voteAverage,
    required MediaType mediaType,
  }) = _PersonCredit;

  const PersonCredit._();

  String? get fullPosterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : null;
}
