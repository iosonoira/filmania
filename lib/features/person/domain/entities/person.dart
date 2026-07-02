import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';

@freezed
abstract class Person with _$Person {
  const factory Person({
    required int id,
    required String name,
    required String biography,
    required DateTime? birthday,
    required String? placeOfBirth,
    required String? profilePath,
  }) = _Person;

  const Person._();

  String? get fullProfileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w500$profilePath' : null;
}
