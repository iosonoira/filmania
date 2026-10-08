import 'package:filmania/data/models/credits_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreditsDto', () {
    test('fromJson parses both cast and crew arrays', () {
      final dto = CreditsDto.fromJson({
        'cast': [
          {
            'id': 1,
            'name': 'Actor One',
            'character': 'Hero',
            'profile_path': null,
          },
        ],
        'crew': [
          {
            'id': 2,
            'name': 'Director One',
            'job': 'Director',
            'department': 'Directing',
            'profile_path': null,
          },
        ],
      });

      expect(dto.cast, hasLength(1));
      expect(dto.crew, hasLength(1));
      expect(dto.cast.first.character, 'Hero');
      expect(dto.crew.first.job, 'Director');
    });

    test('fromJson defaults to empty lists when keys are missing', () {
      final dto = CreditsDto.fromJson(<String, dynamic>{});

      expect(dto.cast, isEmpty);
      expect(dto.crew, isEmpty);
    });

    test('toEntity maps cast and crew to their entities', () {
      final dto = CreditsDto.fromJson({
        'cast': [
          {
            'id': 1,
            'name': 'Actor One',
            'character': 'Hero',
            'profile_path': null,
          },
        ],
        'crew': [
          {
            'id': 2,
            'name': 'Director One',
            'job': 'Director',
            'department': 'Directing',
            'profile_path': null,
          },
        ],
      });

      final entity = dto.toEntity();

      expect(entity.cast.single.name, 'Actor One');
      expect(entity.crew.single.name, 'Director One');
    });
  });
}
