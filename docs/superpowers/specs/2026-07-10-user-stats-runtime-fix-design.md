# Design: fix statistiche tempo profilo (P7)

Data: 2026-07-10
Backlog: P7 in wiki/projects/filmania/backlog.md (second-brain)

## Problema

Statistiche "tempo passato" nel profilo utente sbagliate (conteggio corretto, minuti no).

Causa (diagnosi gia' confermata):

1. `get_user_stats` (RPC Postgres) legge da cache `user_stats`, popolata da
   `recalculate_user_stats(p_user_id)` che somma `runtime_minutes` da
   `watched_items`/`watched_episodes`.
2. `TvTimeSupabaseWriter` non scrive mai `runtime_minutes`. 722 film +
   7885 episodi importati da TV Time hanno runtime NULL -> 0 minuti nella
   somma pur contati correttamente nel `COUNT(*)`.
3. Bug strutturale piu' ampio: `recalculate_user_stats` viene chiamata
   solo se non esiste ancora una riga `user_stats` per l'utente (lazy,
   dentro `get_user_stats`). Nessun trigger, nessuna chiamata client.
   Una volta calcolata la prima volta la riga resta congelata per
   sempre, anche per i normali "segna visto" futuri.

## Design

### 1. Trigger Postgres per refresh `user_stats`

Nuova migrazione SQL (applicata manualmente in SQL Editor, come da
convenzione del progetto).

- Funzione trigger `trg_refresh_user_stats()`: legge `DISTINCT user_id`
  dalla transition table dello statement e chiama
  `recalculate_user_stats(user_id)` per ognuno.
- Per ciascuna delle tabelle `watched_items` e `watched_episodes`, due
  trigger statement-level (Postgres non supporta un'unica transition
  table condivisa tra INSERT/UPDATE/DELETE):
  - `AFTER INSERT OR UPDATE ... REFERENCING NEW TABLE AS new_rows FOR EACH STATEMENT`
  - `AFTER DELETE ... REFERENCING OLD TABLE AS old_rows FOR EACH STATEMENT`
- Statement-level (non row-level) per evitare che l'import bulk (batch
  upsert da 400 righe) scateni migliaia di ricalcoli: con batch da 400,
  ~20 statement per 7885 episodi -> ~20 firing invece di 7885.
  `markAsWatched`/unmark singoli -> 1 firing, comportamento invariato.
- `get_user_stats` resta invariata (fallback lazy per utenti mai
  calcolati); il trigger tiene la cache fresca per tutti gli scenari
  successivi (markAsWatched, bulk actions, import, unmark).

### 2. Scrittura `runtime_minutes` durante import TV Time

Nuovo datasource locale alla feature `tvtime_import`,
`TmdbDetailsDataSource` (stesso pattern di `TmdbFindDataSource` gia'
presente: Dio condiviso via `tmdbClientProvider`, retry su 429). Nessuna
dipendenza cross-feature da `movies`/`tv_series` (coerente con ADR
0001-tvtime-import-architecture).

- `getMovieRuntime(tmdbId) -> int?`: GET `movie/{id}`, legge `runtime`.
- `getSeriesEpisodeRuntime(tmdbId) -> int?`: GET `tv/{id}`, legge
  `episode_run_time.first`.

Modifiche a `TvTimeSupabaseWriter`:

- `_writeMovies`: prima del batch upsert, fetch runtime per ogni
  `tmdbId` unico (`mapWithConcurrency`, concorrenza 5, stesso valore
  gia' usato in `tvtime_match_service.dart`), aggiunge `runtime_minutes`
  al payload.
- `_writeEpisodes` + `_writeSeriesWatchedItems`: fetch
  `episode_run_time.first` una volta per `seriesTmdbId` unico. Ogni riga
  episodio -> `runtime_minutes = avgRuntime`. Riga serie in
  `watched_items` -> `runtime_minutes = avgRuntime * numero episodi di
  quella serie nel batch` (stesso calcolo usato in
  `watched_repository_impl.markAsWatched`).
- Fetch fallita per un singolo id -> `runtime_minutes` resta null per
  quell'item, non blocca l'import (stesso fallback silenzioso gia' in
  uso per i film in `markAsWatched`).

### 3. Backfill dati gia' importati

Nessun codice extra. Dopo il deploy del fix (migrazione + writer
aggiornato), re-eseguire l'import TV Time con il file di export
originale dall'app. L'upsert su chiavi naturali (`user_id, media_id,
media_type` / `user_id, series_id, season_number, episode_number`)
sovrascrive le 722 + 7885 righe esistenti popolando `runtime_minutes`.
Il trigger statement-level scatta durante il re-import e ricalcola
`user_stats` automaticamente: nessun passo di recalc manuale finale.

## Fuori scope

- Non si tocca `get_user_stats` ne' la logica di aggregazione esistente
  in `recalculate_user_stats` (solo si aggiunge chi la chiama).
- Non si introduce un backfill script separato: si riusa il flusso di
  import esistente.
