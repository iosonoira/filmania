import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/tvtime_import_progress.dart';
import '../../domain/entities/tvtime_matched_data.dart';
import '../../domain/failures/tvtime_import_failure.dart';

part 'tvtime_import_state.freezed.dart';

@freezed
sealed class TvTimeImportState with _$TvTimeImportState {
  const factory TvTimeImportState.idle() = TvTimeImportIdle;
  const factory TvTimeImportState.processing(TvTimeImportProgress progress) =
      TvTimeImportProcessing;
  const factory TvTimeImportState.ready(TvTimeMatchResult matchResult) =
      TvTimeImportReady;
  const factory TvTimeImportState.writing(TvTimeImportProgress progress) =
      TvTimeImportWriting;
  const factory TvTimeImportState.done(TvTimeMatchResult matchResult) =
      TvTimeImportDone;
  const factory TvTimeImportState.error(TvTimeImportFailure failure) =
      TvTimeImportError;
}
