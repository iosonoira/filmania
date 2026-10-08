import 'package:filmania/data/services/tmdb/tmdb_client.dart';
import 'package:filmania/features/person/data/datasources/i_person_remote_datasource.dart';
import 'package:filmania/features/person/data/datasources/person_remote_datasource_impl.dart';
import 'package:filmania/features/person/domain/entities/person.dart';
import 'package:filmania/features/person/domain/entities/person_credit.dart';
import 'package:filmania/features/person/domain/repositories/i_person_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'person_repository_impl.g.dart';

class PersonRepositoryImpl implements IPersonRepository {
  final IPersonRemoteDataSource _remoteDataSource;

  const PersonRepositoryImpl(this._remoteDataSource);

  @override
  Future<Person> getPersonDetails(int personId) async {
    final dto = await _remoteDataSource.getPersonDetails(personId);
    return dto.toEntity();
  }

  @override
  Future<List<PersonCredit>> getPersonCombinedCredits(int personId) async {
    final dto = await _remoteDataSource.getPersonCombinedCredits(personId);
    return dto.toEntity();
  }
}

@riverpod
IPersonRemoteDataSource personRemoteDataSource(Ref ref) {
  return PersonRemoteDataSourceImpl(ref.watch(tmdbClientProvider));
}

@riverpod
IPersonRepository personRepository(Ref ref) {
  return PersonRepositoryImpl(ref.watch(personRemoteDataSourceProvider));
}
