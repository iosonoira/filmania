import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_season.g.dart';

@Riverpod(keepAlive: true)
class SelectedSeason extends _$SelectedSeason {
  @override
  int build(int tvId) => 1;

  void select(int seasonNumber) => state = seasonNumber;
}
