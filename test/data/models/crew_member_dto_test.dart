import 'package:filmania/data/models/crew_member_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CrewMemberDto', () {
    test('fromJson parses id, name, job, department, profile_path', () {
      final dto = CrewMemberDto.fromJson({
        'id': 138,
        'name': 'Quentin Tarantino',
        'job': 'Director',
        'department': 'Directing',
        'profile_path': '/abc.jpg',
      });

      expect(dto.id, 138);
      expect(dto.name, 'Quentin Tarantino');
      expect(dto.job, 'Director');
      expect(dto.department, 'Directing');
      expect(dto.profilePath, '/abc.jpg');
    });

    test('toEntity maps to CrewMember with the same fields', () {
      const dto = CrewMemberDto(
        id: 138,
        name: 'Quentin Tarantino',
        job: 'Director',
        department: 'Directing',
        profilePath: '/abc.jpg',
      );

      final entity = dto.toEntity();

      expect(entity.id, 138);
      expect(entity.job, 'Director');
      expect(entity.fullProfileUrl, 'https://image.tmdb.org/t/p/w185/abc.jpg');
    });

    test('fullProfileUrl is null when profilePath is null', () {
      const dto = CrewMemberDto(
        id: 1,
        name: 'X',
        job: 'Producer',
        department: 'Production',
        profilePath: null,
      );

      expect(dto.toEntity().fullProfileUrl, isNull);
    });
  });
}
