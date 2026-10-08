import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:csv/csv.dart';
import 'package:filmania/utils/logger.dart';
import 'package:filmania/features/tvtime_import/domain/entities/tvtime_raw_export.dart';
import 'package:filmania/features/tvtime_import/domain/failures/tvtime_import_failure.dart';

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
    // File dei metadati/status delle serie (es. "stopped" = interrotta).
    // Il pattern esclude esplicitamente "tvtime-series-episodes-*.csv" con
    // una negative lookahead, così non collide col pattern sopra.
    // OPZIONALE: se assente, nessuna serie viene marcata interrotta
    // dall'import (comportamento identico a oggi), nessun errore sollevato.
    final seriesMetaFile = _findFile(
      archive,
      RegExp(r'^tvtime-series-(?!episodes-).*\.csv$', caseSensitive: false),
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
      series: seriesMetaFile == null ? [] : _parseSeriesMeta(seriesMetaFile),
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
          special: (r['special'] ?? '').trim().toLowerCase() == 'true',
          watchedAt: (r['watched_at'] ?? '').isEmpty ? null : r['watched_at'],
        ),
      );
    }
    return _dedupeCollidingEpisodes(result);
  }

  /// Deduplica episodi che collidono sullo stesso `(seriesTvdbId, season,
  /// episode)` con più righe `isWatched=true` — capita quando TV Time/TVDB
  /// assegna lo stesso numero di stagione/episodio sia a un episodio
  /// regolare sia a una entry "special" (recap/OVA/extra, `special=true`)
  /// con un `tvdb_id` diverso. Non deduplicato, questo causa
  /// `PostgrestException ... ON CONFLICT DO UPDATE ... affect row a second
  /// time` sull'upsert `UNIQUE(user_id, series_id, season, episode)` in
  /// `watched_episodes`.
  ///
  /// Regola (decisa esplicitamente, non un'euristica): quando una riga
  /// regular (`special=false`) e una riga special (`special=true`) sono
  /// entrambe `isWatched=true` per lo stesso slot, la riga regular vince
  /// sempre — la special viene scartata e loggata.
  ///
  /// Caso limite non osservato in export reali ma gestito per non violare
  /// comunque il vincolo Supabase: se un gruppo ha ≥2 righe watched=true e
  /// NESSUNA di queste è regular (es. due entry special diverse collidono
  /// tra loro), viene tenuta solo la prima riga watched incontrata nel CSV
  /// e le altre vengono scartate e loggate.
  List<TvTimeRawEpisodeRow> _dedupeCollidingEpisodes(
    List<TvTimeRawEpisodeRow> rows,
  ) {
    final byKey = <String, List<TvTimeRawEpisodeRow>>{};
    for (final row in rows) {
      final key = '${row.seriesTvdbId}|${row.season}|${row.episode}';
      byKey.putIfAbsent(key, () => []).add(row);
    }

    final result = <TvTimeRawEpisodeRow>[];
    for (final group in byKey.values) {
      final watchedCount = group.where((r) => r.isWatched).length;
      if (watchedCount < 2) {
        result.addAll(group);
        continue;
      }

      final hasWatchedRegular = group.any((r) => r.isWatched && !r.special);
      if (hasWatchedRegular) {
        for (final row in group) {
          if (row.isWatched && row.special) {
            AppLogger.error(
              'TvTime episodio special scartato per collisione season/episode '
              'con una riga regular watched: series=${row.seriesTvdbId} '
              'S${row.season}E${row.episode}',
              tag: 'TvTimeParser',
            );
            continue;
          }
          result.add(row);
        }
      } else {
        var firstWatchedKept = false;
        for (final row in group) {
          if (row.isWatched) {
            if (firstWatchedKept) {
              AppLogger.error(
                'TvTime episodio scartato per collisione season/episode senza '
                'riga regular disponibile: series=${row.seriesTvdbId} '
                'S${row.season}E${row.episode}',
                tag: 'TvTimeParser',
              );
              continue;
            }
            firstWatchedKept = true;
          }
          result.add(row);
        }
      }
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

  /// Legge `tvtime-series-*.csv` (metadati/status delle serie, NON gli
  /// episodi). Lo `status` viene usato per due mapping: "stopped" →
  /// isDropped, "watch_later" → isWatchLater (vedi TvTimeMatchService). Gli
  /// altri valori (`up_to_date`, `not_started_yet`, `continuing`) non
  /// servono, la categoria viene già calcolata altrove dal conteggio episodi.
  List<TvTimeRawSeriesRow> _parseSeriesMeta(ArchiveFile file) {
    return _rowsAsMaps(_decodeCsv(file)).map((r) {
      return TvTimeRawSeriesRow(
        tvdbId: r['tvdb_id'] ?? '',
        status: (r['status'] ?? '').trim(),
      );
    }).toList();
  }
}
