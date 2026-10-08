import 'package:filmania/data/models/genre_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GenreDto', () {
    test('fromJson parses id and name', () {
      final dto = GenreDto.fromJson({'id': 28, 'name': 'Azione'});

      expect(dto.id, 28);
      expect(dto.name, 'Azione');
    });

    test('toEntity maps to Genre with the same fields', () {
      const dto = GenreDto(id: 28, name: 'Azione');

      final entity = dto.toEntity();

      expect(entity.id, 28);
      expect(entity.name, 'Azione');
    });
  });
}
