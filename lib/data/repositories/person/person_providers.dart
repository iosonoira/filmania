import 'package:filmania/data/repositories/person/person_repository_impl.dart';
import 'package:filmania/domain/models/person.dart';
import 'package:filmania/domain/models/person_credit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'person_providers.g.dart';

@riverpod
Future<Person> personDetails(Ref ref, int personId) {
  final repository = ref.watch(personRepositoryProvider);
  return repository.getPersonDetails(personId);
}

@riverpod
Future<List<PersonCredit>> personFilmography(Ref ref, int personId) {
  final repository = ref.watch(personRepositoryProvider);
  return repository.getPersonCombinedCredits(personId);
}
