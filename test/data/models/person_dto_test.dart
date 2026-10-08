import 'package:filmania/data/models/person_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PersonDto', () {
    test('fromJson parses all fields', () {
      final dto = PersonDto.fromJson({
        'id': 138,
        'name': 'Quentin Tarantino',
        'biography': 'American filmmaker.',
        'birthday': '1963-03-27',
        'place_of_birth': 'Knoxville, Tennessee, USA',
        'profile_path': '/abc.jpg',
      });

      expect(dto.id, 138);
      expect(dto.name, 'Quentin Tarantino');
      expect(dto.biography, 'American filmmaker.');
      expect(dto.birthday, '1963-03-27');
      expect(dto.placeOfBirth, 'Knoxville, Tennessee, USA');
      expect(dto.profilePath, '/abc.jpg');
    });

    test(
      'toEntity parses birthday into a DateTime and builds fullProfileUrl',
      () {
        const dto = PersonDto(
          id: 138,
          name: 'Quentin Tarantino',
          biography: 'American filmmaker.',
          birthday: '1963-03-27',
          placeOfBirth: 'Knoxville, Tennessee, USA',
          profilePath: '/abc.jpg',
        );

        final entity = dto.toEntity();

        expect(entity.birthday, DateTime(1963, 3, 27));
        expect(
          entity.fullProfileUrl,
          'https://image.tmdb.org/t/p/w500/abc.jpg',
        );
      },
    );

    test(
      'toEntity defaults biography to empty string and birthday to null when absent',
      () {
        const dto = PersonDto(id: 1, name: 'Unknown');

        final entity = dto.toEntity();

        expect(entity.biography, '');
        expect(entity.birthday, isNull);
        expect(entity.fullProfileUrl, isNull);
      },
    );
  });
}
