import 'package:filmania/features/person/domain/entities/person.dart';
import 'package:filmania/features/person/domain/entities/person_credit.dart';

abstract class IPersonRepository {
  Future<Person> getPersonDetails(int personId);
  Future<List<PersonCredit>> getPersonCombinedCredits(int personId);
}
