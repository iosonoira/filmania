import 'package:filmania/features/movies/data/datasources/movies_remote_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildMovieDiscoverQueryParams', () {
    test('with no filters returns only page and sort_by', () {
      final params = buildMovieDiscoverQueryParams(page: 1);

      expect(params, {'page': 1, 'sort_by': 'popularity.desc'});
    });

    test('with genre filter joins ids with a pipe (OR semantics)', () {
      final params = buildMovieDiscoverQueryParams(page: 1, genreIds: [28, 12]);

      expect(params['with_genres'], '28|12');
    });

    test('omits with_genres when genreIds is empty', () {
      final params = buildMovieDiscoverQueryParams(page: 1);

      expect(params.containsKey('with_genres'), isFalse);
    });

    test('with year range sets primary_release_date bounds', () {
      final params = buildMovieDiscoverQueryParams(
        page: 1,
        yearFrom: 2000,
        yearTo: 2010,
      );

      expect(params['primary_release_date.gte'], '2000-01-01');
      expect(params['primary_release_date.lte'], '2010-12-31');
    });

    test('omits year keys when null', () {
      final params = buildMovieDiscoverQueryParams(page: 1);

      expect(params.containsKey('primary_release_date.gte'), isFalse);
      expect(params.containsKey('primary_release_date.lte'), isFalse);
    });
  });
}
