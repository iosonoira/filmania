import 'package:filmania/data/models/person_combined_credits_dto.dart';
import 'package:filmania/data/models/person_dto.dart';

abstract interface class IPersonRemoteDataSource {
  Future<PersonDto> getPersonDetails(int personId);
  Future<PersonCombinedCreditsDto> getPersonCombinedCredits(int personId);
}
