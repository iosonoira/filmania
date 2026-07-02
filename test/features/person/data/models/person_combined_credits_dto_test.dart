import 'package:filmania/core/domain/enums/media_type.dart';
import 'package:filmania/features/person/data/models/person_combined_credits_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PersonCombinedCreditsDto', () {
    test('toEntity merges cast and crew, most recent first', () {
      final dto = PersonCombinedCreditsDto.fromJson({
        'cast': [
          {
            'id': 1,
            'title': 'Older Movie',
            'release_date': '2000-01-01',
            'vote_average': 7.0,
            'media_type': 'movie',
          },
        ],
        'crew': [
          {
            'id': 2,
            'name': 'Newer Show',
            'first_air_date': '2020-01-01',
            'vote_average': 8.0,
            'media_type': 'tv',
          },
        ],
      });

      final credits = dto.toEntity();

      expect(credits, hasLength(2));
      expect(credits.first.title, 'Newer Show');
      expect(credits.first.mediaType, MediaType.tv);
      expect(credits.last.title, 'Older Movie');
    });

    test('toEntity deduplicates the same media appearing in both cast and crew', () {
      final dto = PersonCombinedCreditsDto.fromJson({
        'cast': [
          {
            'id': 1,
            'title': 'Actor-Director Movie',
            'release_date': '2010-01-01',
            'media_type': 'movie',
          },
        ],
        'crew': [
          {
            'id': 1,
            'title': 'Actor-Director Movie',
            'release_date': '2010-01-01',
            'media_type': 'movie',
          },
        ],
      });

      final credits = dto.toEntity();

      expect(credits, hasLength(1));
    });

    test('fromJson defaults to empty lists when keys are missing', () {
      final dto = PersonCombinedCreditsDto.fromJson(<String, dynamic>{});

      expect(dto.toEntity(), isEmpty);
    });
  });
}
