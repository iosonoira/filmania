// test/data/services/tmdb/tv_series_query_params_test.dart
import 'package:filmania/data/services/tmdb/tv_series_remote_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildTVDiscoverQueryParams', () {
    test('with no filters returns only page and sort_by', () {
      final params = buildTVDiscoverQueryParams(page: 1);

      expect(params, {'page': 1, 'sort_by': 'popularity.desc'});
    });

    test('with genre filter joins ids with a pipe (OR semantics)', () {
      final params = buildTVDiscoverQueryParams(page: 1, genreIds: [10759, 35]);

      expect(params['with_genres'], '10759|35');
    });

    test('omits with_genres when genreIds is empty', () {
      final params = buildTVDiscoverQueryParams(page: 1);

      expect(params.containsKey('with_genres'), isFalse);
    });

    test('with year range sets first_air_date bounds', () {
      final params = buildTVDiscoverQueryParams(
        page: 1,
        yearFrom: 2015,
        yearTo: 2020,
      );

      expect(params['first_air_date.gte'], '2015-01-01');
      expect(params['first_air_date.lte'], '2020-12-31');
    });

    test('omits year keys when null', () {
      final params = buildTVDiscoverQueryParams(page: 1);

      expect(params.containsKey('first_air_date.gte'), isFalse);
      expect(params.containsKey('first_air_date.lte'), isFalse);
    });
  });
}
