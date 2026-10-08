import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/domain/models/media_type.dart';

part 'discover_providers.freezed.dart';
part 'discover_providers.g.dart';

/// Alias for backward compatibility within the discover UI layer.
typedef DiscoverMediaType = MediaType;

@riverpod
class SelectedMediaType extends _$SelectedMediaType {
  @override
  DiscoverMediaType build() => DiscoverMediaType.movie;

  void set(DiscoverMediaType type) => state = type;
}

@riverpod
class MovieSearchQuery extends _$MovieSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
class DebouncedSearchQuery extends _$DebouncedSearchQuery {
  Timer? _timer;

  @override
  String build() {
    ref.onDispose(() => _timer?.cancel());
    return '';
  }

  void update(String query) {
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 400), () {
      if (ref.mounted) state = query;
    });
  }
}

@freezed
abstract class DiscoverFilters with _$DiscoverFilters {
  const factory DiscoverFilters({
    @Default(<int>{}) Set<int> genreIds,
    int? yearFrom,
    int? yearTo,
  }) = _DiscoverFilters;

  const DiscoverFilters._();

  bool get isActive =>
      genreIds.isNotEmpty || yearFrom != null || yearTo != null;

  String get genreIdsKey {
    if (genreIds.isEmpty) return '';
    final sorted = genreIds.toList()..sort();
    return sorted.join(',');
  }
}

@riverpod
class MovieDiscoverFilters extends _$MovieDiscoverFilters {
  @override
  DiscoverFilters build() => const DiscoverFilters();

  void toggleGenre(int id) {
    final updated = Set<int>.from(state.genreIds);
    if (!updated.remove(id)) updated.add(id);
    state = state.copyWith(genreIds: updated);
  }

  void setYearRange(int? from, int? to) {
    state = state.copyWith(yearFrom: from, yearTo: to);
  }

  void clear() => state = const DiscoverFilters();
}

@riverpod
class TvDiscoverFilters extends _$TvDiscoverFilters {
  @override
  DiscoverFilters build() => const DiscoverFilters();

  void toggleGenre(int id) {
    final updated = Set<int>.from(state.genreIds);
    if (!updated.remove(id)) updated.add(id);
    state = state.copyWith(genreIds: updated);
  }

  void setYearRange(int? from, int? to) {
    state = state.copyWith(yearFrom: from, yearTo: to);
  }

  void clear() => state = const DiscoverFilters();
}
