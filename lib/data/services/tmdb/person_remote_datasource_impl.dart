import 'package:dio/dio.dart';
import 'package:filmania/data/services/network_failure.dart';
import 'package:filmania/data/services/tmdb/i_person_remote_datasource.dart';
import 'package:filmania/data/models/person_combined_credits_dto.dart';
import 'package:filmania/data/models/person_dto.dart';

class PersonRemoteDataSourceImpl implements IPersonRemoteDataSource {
  final Dio _client;

  const PersonRemoteDataSourceImpl(this._client);

  @override
  Future<PersonDto> getPersonDetails(int personId) async {
    try {
      final response = await _client.get('person/$personId');
      return PersonDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }

  @override
  Future<PersonCombinedCreditsDto> getPersonCombinedCredits(
    int personId,
  ) async {
    try {
      final response = await _client.get('person/$personId/combined_credits');
      return PersonCombinedCreditsDto.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkFailure.fromDioException(e);
    }
  }
}
