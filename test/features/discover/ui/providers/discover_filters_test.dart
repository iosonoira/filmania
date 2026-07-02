import 'package:filmania/features/discover/ui/providers/discover_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DiscoverFilters', () {
    test('isActive is false with no filters', () {
      const filters = DiscoverFilters();
      expect(filters.isActive, isFalse);
    });

    test('isActive is true when a genre is selected', () {
      const filters = DiscoverFilters(genreIds: {28});
      expect(filters.isActive, isTrue);
    });

    test('isActive is true when a year bound is set', () {
      const filters = DiscoverFilters(yearFrom: 2000);
      expect(filters.isActive, isTrue);
    });

    test('genreIdsKey sorts ids and joins with a comma', () {
      const filters = DiscoverFilters(genreIds: {28, 12, 16});
      expect(filters.genreIdsKey, '12,16,28');
    });

    test('genreIdsKey is empty when no genres are selected', () {
      const filters = DiscoverFilters();
      expect(filters.genreIdsKey, '');
    });
  });

  group('MovieDiscoverFilters', () {
    test('toggleGenre adds an id that is not yet selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(movieDiscoverFiltersProvider.notifier).toggleGenre(28);

      expect(container.read(movieDiscoverFiltersProvider).genreIds, {28});
    });

    test('toggleGenre removes an id that is already selected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(movieDiscoverFiltersProvider.notifier);

      notifier.toggleGenre(28);
      notifier.toggleGenre(28);

      expect(container.read(movieDiscoverFiltersProvider).genreIds, isEmpty);
    });

    test('clear resets genres and year range to defaults', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(movieDiscoverFiltersProvider.notifier);
      notifier.toggleGenre(28);
      notifier.setYearRange(2000, 2020);

      notifier.clear();

      expect(
        container.read(movieDiscoverFiltersProvider),
        const DiscoverFilters(),
      );
    });
  });

  group('TvDiscoverFilters', () {
    test('is independent from MovieDiscoverFilters', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(movieDiscoverFiltersProvider.notifier).toggleGenre(28);

      expect(container.read(tvDiscoverFiltersProvider).genreIds, isEmpty);
    });
  });
}
