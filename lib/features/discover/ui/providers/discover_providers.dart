import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discover_providers.g.dart';

@riverpod
class MovieSearchQuery extends _$MovieSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}
