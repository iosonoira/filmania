import 'dart:typed_data';
import 'package:filmania/domain/models/tvtime_import_progress.dart';
import 'package:filmania/domain/models/tvtime_matched_data.dart';

abstract class ITvTimeImportRepository {
  /// Estrae lo zip, parsifica i CSV e matcha tutto su TMDB.
  /// [onProgress] viene chiamato ripetutamente durante parsing e matching.
  /// Non scrive nulla su Supabase — solo lettura/matching.
  Future<TvTimeMatchResult> parseAndMatch(
    Uint8List zipBytes, {
    required void Function(TvTimeImportProgress progress) onProgress,
  });

  /// Scrive su Supabase il risultato già matchato (dopo conferma utente).
  /// [onProgress] viene chiamato durante la scrittura a batch.
  Future<void> confirmImport(
    TvTimeMatchResult matchResult, {
    required void Function(TvTimeImportProgress progress) onProgress,
  });
}
