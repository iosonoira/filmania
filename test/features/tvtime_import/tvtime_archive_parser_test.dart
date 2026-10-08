import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:filmania/features/tvtime_import/data/datasources/tvtime_archive_parser.dart';
import 'package:filmania/domain/failures/tvtime_import_failure.dart';

Uint8List _buildZip(Map<String, String> csvByFilename) {
  final archive = Archive();
  csvByFilename.forEach((name, content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  });
  return Uint8List.fromList(ZipEncoder().encode(archive)!);
}

void main() {
  final parser = TvTimeArchiveParser();

  test('parsifica un export valido con tutte e 3 le CSV', () {
    final zipBytes = _buildZip({
      'tvtime-movies-2026-07-01.csv':
          'uuid,imdb_id,tvdb_id,title,is_watched,watched_at,created_at\n'
          'u1,tt0111161,,The Shawshank Redemption,true,2020-01-01T00:00:00Z,2019-01-01T00:00:00Z\n',
      'tvtime-series-episodes-2026-07-01.csv':
          'series_tvdb_id,title,season,episode,is_watched,watched_at\n'
          '81189,Breaking Bad,1,1,true,2020-02-01T00:00:00Z\n',
      'tvtime-lists-2026-07-01.csv':
          'list_name,item_type,uuid,tvdb_id,name\n'
          'Da vedere,series,,81189,Breaking Bad\n',
    });

    final result = parser.parse(zipBytes);

    expect(result.movies, hasLength(1));
    expect(result.movies.first.imdbId, 'tt0111161');
    expect(result.episodes, hasLength(1));
    expect(result.episodes.first.seriesTvdbId, '81189');
    expect(result.lists, hasLength(1));
    expect(result.lists.first.listName, 'Da vedere');
    expect(result.series, isEmpty); // no tvtime-series-*.csv file
  });

  test('parsifica tvtime-series-*.csv con status e tvdb_id', () {
    final zipBytes = _buildZip({
      'tvtime-movies-2026-07-01.csv':
          'uuid,imdb_id,tvdb_id,title,is_watched,watched_at,created_at\n',
      'tvtime-series-episodes-2026-07-01.csv':
          'series_tvdb_id,title,season,episode,is_watched,watched_at\n',
      'tvtime-lists-2026-07-01.csv': 'list_name,item_type,uuid,tvdb_id,name\n',
      'tvtime-series-2026-07-01.csv':
          'uuid,tvdb_id,imdb_id,title,status,created_at\n'
          'u1,81189,tt0944947,,stopped,2025-01-01T00:00:00Z\n'
          'u2,1399,tt0903747,,continuing,2024-01-01T00:00:00Z\n',
    });

    final result = parser.parse(zipBytes);

    expect(result.series, hasLength(2));
    expect(result.series[0].tvdbId, '81189');
    expect(result.series[0].status, 'stopped');
    expect(result.series[1].tvdbId, '1399');
    expect(result.series[1].status, 'continuing');
  });

  test('lancia TvTimeInvalidArchiveFailure se manca un CSV richiesto', () {
    final zipBytes = _buildZip({
      'tvtime-movies-2026-07-01.csv':
          'uuid,imdb_id,tvdb_id,title,is_watched,watched_at,created_at\n',
    });

    expect(
      () => parser.parse(zipBytes),
      throwsA(isA<TvTimeInvalidArchiveFailure>()),
    );
  });

  test('salta righe malformate senza lanciare eccezioni', () {
    final zipBytes = _buildZip({
      'tvtime-movies-2026-07-01.csv':
          'uuid,imdb_id,tvdb_id,title,is_watched,watched_at,created_at\n'
          'u1,tt0111161,,Titolo Valido,true,2020-01-01T00:00:00Z,2019-01-01T00:00:00Z\n',
      'tvtime-series-episodes-2026-07-01.csv':
          'series_tvdb_id,title,season,episode,is_watched,watched_at\n'
          '81189,Riga Rotta,NON_UN_NUMERO,1,true,2020-02-01T00:00:00Z\n',
      'tvtime-lists-2026-07-01.csv': 'list_name,item_type,uuid,tvdb_id,name\n',
    });

    final result = parser.parse(zipBytes);
    expect(result.episodes, isEmpty); // riga con season non numerico, scartata
  });

  test('parsifica il file opzionale tvtime-series-*.csv (status serie)', () {
    final zipBytes = _buildZip({
      'tvtime-movies-2026-07-01.csv':
          'uuid,imdb_id,tvdb_id,title,is_watched,watched_at,created_at\n',
      'tvtime-series-episodes-2026-07-01.csv':
          'series_tvdb_id,title,season,episode,is_watched,watched_at\n',
      'tvtime-lists-2026-07-01.csv': 'list_name,item_type,uuid,tvdb_id,name\n',
      'tvtime-series-2026-07-01.csv':
          'uuid,tvdb_id,imdb_id,title,status,created_at\n'
          's1,81189,,Breaking Bad,stopped,2020-01-01T00:00:00Z\n',
    });

    final result = parser.parse(zipBytes);

    expect(result.series, hasLength(1));
    expect(result.series.first.tvdbId, '81189');
    expect(result.series.first.status, 'stopped');
  });

  test('funziona anche senza il file opzionale tvtime-series-*.csv', () {
    final zipBytes = _buildZip({
      'tvtime-movies-2026-07-01.csv':
          'uuid,imdb_id,tvdb_id,title,is_watched,watched_at,created_at\n',
      'tvtime-series-episodes-2026-07-01.csv':
          'series_tvdb_id,title,season,episode,is_watched,watched_at\n',
      'tvtime-lists-2026-07-01.csv': 'list_name,item_type,uuid,tvdb_id,name\n',
    });

    final result = parser.parse(zipBytes);

    expect(result.series, isEmpty);
  });

  test(
    'scarta la riga special quando collide con una regular entrambe watched',
    () {
      final zipBytes = _buildZip({
        'tvtime-movies-2026-07-01.csv':
            'uuid,imdb_id,tvdb_id,title,is_watched,watched_at,created_at\n',
        'tvtime-series-episodes-2026-07-01.csv':
            'series_tvdb_id,title,season,episode,is_watched,watched_at,special\n'
            '352408,Slime,1,1,true,2021-01-12T19:27:37Z,false\n'
            '352408,Slime,1,1,true,2025-01-08T21:53:28Z,true\n',
        'tvtime-lists-2026-07-01.csv':
            'list_name,item_type,uuid,tvdb_id,name\n',
      });

      final result = parser.parse(zipBytes);

      expect(result.episodes, hasLength(1));
      expect(result.episodes.first.special, isFalse);
      expect(result.episodes.first.watchedAt, '2021-01-12T19:27:37Z');
    },
  );

  test('non deduplica se solo una delle due righe collidenti è watched', () {
    final zipBytes = _buildZip({
      'tvtime-movies-2026-07-01.csv':
          'uuid,imdb_id,tvdb_id,title,is_watched,watched_at,created_at\n',
      'tvtime-series-episodes-2026-07-01.csv':
          'series_tvdb_id,title,season,episode,is_watched,watched_at,special\n'
          '352408,Slime,1,1,true,2021-01-12T19:27:37Z,false\n'
          '352408,Slime,1,1,false,,true\n',
      'tvtime-lists-2026-07-01.csv': 'list_name,item_type,uuid,tvdb_id,name\n',
    });

    final result = parser.parse(zipBytes);

    expect(
      result.episodes,
      hasLength(2),
    ); // nessuna collisione reale, entrambe tenute
  });

  test(
    'parsifica special=false quando la colonna special è assente (retrocompatibilità)',
    () {
      final zipBytes = _buildZip({
        'tvtime-movies-2026-07-01.csv':
            'uuid,imdb_id,tvdb_id,title,is_watched,watched_at,created_at\n',
        'tvtime-series-episodes-2026-07-01.csv':
            'series_tvdb_id,title,season,episode,is_watched,watched_at\n'
            '81189,Breaking Bad,1,1,true,2020-02-01T00:00:00Z\n',
        'tvtime-lists-2026-07-01.csv':
            'list_name,item_type,uuid,tvdb_id,name\n',
      });

      final result = parser.parse(zipBytes);

      expect(result.episodes, hasLength(1));
      expect(result.episodes.first.special, isFalse);
    },
  );
}
