import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'discover_providers.g.dart';

enum DiscoverMediaType { movie, tv }

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
