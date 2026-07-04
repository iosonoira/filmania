import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:filmania/core/utils/logger.dart';
import '../../domain/entities/tvtime_raw_export.dart';
import '../../domain/failures/tvtime_import_failure.dart';

/// Estrae e parsifica l'export zip di TV Time (Chrome extension "TV Time Out
/// by Refract" / richiesta GDPR). Nessuna scrittura su disco: tutto in memoria.
class TvTimeArchiveParser {
  TvTimeRawExport parse(Uint8List zipBytes) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(zipBytes);
    } catch (e) {
      AppLogger.error(
        'TvTime zip decode failed',
        tag: 'TvTimeParser',
        exception: e,
      );
      throw const TvTimeInvalidArchiveFailure(
        'Il file selezionato non è uno zip valido.',
      );
    }

    final moviesFile = _findFile(
      archive,
      RegExp(r'tvtime-movies-.*\.csv$', caseSensitive: false),
    );
    final episodesFile = _findFile(
      archive,
      RegExp(r'tvtime-series-episodes-.*\.csv$', caseSensitive: false),
    );
    final listsFile = _findFile(
      archive,
      RegExp(r'tvtime-lists-.*\.csv$', caseSensitive: false),
    );

    if (moviesFile == null || episodesFile == null || listsFile == null) {
      final missing = [
        if (moviesFile == null) 'tvtime-movies-*.csv',
        if (episodesFile == null) 'tvtime-series-episodes-*.csv',
        if (listsFile == null) 'tvtime-lists-*.csv',
      ].join(', ');
      throw TvTimeInvalidArchiveFailure(
        'File mancanti nello zip: $missing. Verifica di aver selezionato l\'export completo di TV Time.',
      );
    }

    return TvTimeRawExport(
      movies: _parseMovies(moviesFile),
      episodes: _parseEpisodes(episodesFile),
      lists: _parseLists(listsFile),
    );
  }

  ArchiveFile? _findFile(Archive archive, RegExp pattern) {
    for (final file in archive.files) {
      if (file.isFile && pattern.hasMatch(file.name)) return file;
    }
    return null;
  }

  List<List<dynamic>> _decodeCsv(ArchiveFile file) {
    final content = utf8.decode(
      file.content as List<int>,
      allowMalformed: true,
    );
    return const CsvToListConverter(eol: '\n').convert(content);
  }

  /// Converte le righe CSV in mappe header->valore, saltando righe malformate
  /// (conteggio loggato, mai un crash sull'intero import per una riga sola).
  List<Map<String, String>> _rowsAsMaps(List<List<dynamic>> rows) {
    if (rows.isEmpty) return [];
    final header = rows.first.map((h) => h.toString().trim()).toList();
    final result = <Map<String, String>>[];
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length != header.length) {
        AppLogger.error(
          'TvTime CSV riga malformata saltata: indice $i',
          tag: 'TvTimeParser',
        );
        continue;
      }
      result.add({
        for (var j = 0; j < header.length; j++) header[j]: row[j].toString(),
      });
    }
    return result;
  }

  List<TvTimeRawMovieRow> _parseMovies(ArchiveFile file) {
    return _rowsAsMaps(_decodeCsv(file)).map((r) {
      return TvTimeRawMovieRow(
        uuid: r['uuid'] ?? '',
        imdbId: r['imdb_id'] ?? '',
        tvdbId: r['tvdb_id'] ?? '',
        title: r['title'] ?? '',
        isWatched: r['is_watched']?.trim().toLowerCase() == 'true',
        watchedAt: (r['watched_at'] ?? '').isEmpty ? null : r['watched_at'],
        createdAt: (r['created_at'] ?? '').isEmpty ? null : r['created_at'],
      );
    }).toList();
  }

  List<TvTimeRawEpisodeRow> _parseEpisodes(ArchiveFile file) {
    final result = <TvTimeRawEpisodeRow>[];
    for (final r in _rowsAsMaps(_decodeCsv(file))) {
      final season = int.tryParse(r['season'] ?? '');
      final episode = int.tryParse(r['episode'] ?? '');
      if (season == null || episode == null) continue; // riga malformata, salta
      result.add(
        TvTimeRawEpisodeRow(
          seriesTvdbId: r['series_tvdb_id'] ?? '',
          seriesTitleHint: r['title'] ?? '',
          season: season,
          episode: episode,
          isWatched: r['is_watched']?.trim().toLowerCase() == 'true',
          watchedAt: (r['watched_at'] ?? '').isEmpty ? null : r['watched_at'],
        ),
      );
    }
    return result;
  }

  List<TvTimeRawListRow> _parseLists(ArchiveFile file) {
    return _rowsAsMaps(_decodeCsv(file)).map((r) {
      return TvTimeRawListRow(
        listName: (r['list_name'] ?? '').trim(),
        itemType: (r['item_type'] ?? '').trim(),
        uuid: r['uuid'] ?? '',
        tvdbId: r['tvdb_id'] ?? '',
        nameHint: r['name'] ?? '',
      );
    }).toList();
  }
}
