import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/tvtime_import_phase.dart';

part 'tvtime_import_progress.freezed.dart';

@freezed
abstract class TvTimeImportProgress with _$TvTimeImportProgress {
  const factory TvTimeImportProgress({
    required TvTimeImportPhase phase,
    required int current,
    required int total,
  }) = _TvTimeImportProgress;
}
