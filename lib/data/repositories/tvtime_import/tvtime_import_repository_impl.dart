import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/domain/models/tvtime_import_progress.dart';
import 'package:filmania/domain/models/tvtime_matched_data.dart';
import 'package:filmania/data/repositories/tvtime_import/i_tvtime_import_repository.dart';
import 'package:filmania/data/services/tvtime/tvtime_archive_parser.dart';
import 'package:filmania/data/services/tvtime/tvtime_match_service.dart';
import 'package:filmania/data/services/supabase/tvtime_supabase_writer.dart';
import 'package:filmania/data/services/tmdb/tmdb_find_datasource.dart';

part 'tvtime_import_repository_impl.g.dart';

class TvTimeImportRepositoryImpl implements ITvTimeImportRepository {
  final TvTimeArchiveParser _parser;
  final TvTimeMatchService _matcher;
  final TvTimeSupabaseWriter _writer;

  TvTimeImportRepositoryImpl(this._parser, this._matcher, this._writer);

  @override
  Future<TvTimeMatchResult> parseAndMatch(
    Uint8List zipBytes, {
    required void Function(TvTimeImportProgress progress) onProgress,
  }) async {
    final raw = _parser.parse(zipBytes);
    return _matcher.matchAll(raw, onProgress: onProgress);
  }

  @override
  Future<void> confirmImport(
    TvTimeMatchResult matchResult, {
    required void Function(TvTimeImportProgress progress) onProgress,
  }) {
    return _writer.writeAll(matchResult, onProgress: onProgress);
  }
}

@riverpod
ITvTimeImportRepository tvTimeImportRepository(Ref ref) {
  return TvTimeImportRepositoryImpl(
    TvTimeArchiveParser(),
    TvTimeMatchService(ref.watch(tmdbFindDataSourceProvider)),
    ref.watch(tvTimeSupabaseWriterProvider),
  );
}
