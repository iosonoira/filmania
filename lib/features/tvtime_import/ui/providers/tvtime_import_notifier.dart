import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/features/tvtime_import/data/repositories/tvtime_import_repository_impl.dart';
import 'package:filmania/features/tvtime_import/domain/failures/tvtime_import_failure.dart';
import 'package:filmania/features/tvtime_import/ui/providers/tvtime_import_state.dart';

part 'tvtime_import_notifier.g.dart';

@riverpod
class TvTimeImportNotifier extends _$TvTimeImportNotifier {
  @override
  TvTimeImportState build() => const TvTimeImportState.idle();

  Future<void> processZip(Uint8List zipBytes) async {
    final repo = ref.read(tvTimeImportRepositoryProvider);
    try {
      final result = await repo.parseAndMatch(
        zipBytes,
        onProgress: (p) => state = TvTimeImportState.processing(p),
      );
      state = TvTimeImportState.ready(result);
    } on TvTimeImportFailure catch (f) {
      state = TvTimeImportState.error(f);
    } catch (_) {
      state = const TvTimeImportState.error(TvTimeGenericImportFailure());
    }
  }

  Future<void> confirmImport() async {
    final current = state;
    if (current is! TvTimeImportReady) return;
    final repo = ref.read(tvTimeImportRepositoryProvider);
    try {
      await repo.confirmImport(
        current.matchResult,
        onProgress: (p) => state = TvTimeImportState.writing(p),
      );
      state = TvTimeImportState.done(current.matchResult);
    } on TvTimeImportFailure catch (f) {
      state = TvTimeImportState.error(f);
    } catch (_) {
      state = const TvTimeImportState.error(TvTimeGenericImportFailure());
    }
  }

  void reset() => state = const TvTimeImportState.idle();
}
