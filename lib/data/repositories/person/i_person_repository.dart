import 'package:filmania/domain/models/person.dart';
import 'package:filmania/domain/models/person_credit.dart';

abstract class IPersonRepository {
  Future<Person> getPersonDetails(int personId);
  Future<List<PersonCredit>> getPersonCombinedCredits(int personId);
}
