# Import dati TV Time → Supabase (Filmania)

Script one-off per importare la tua cronologia TV Time (export della Chrome extension
"TV Time Out by Refract") nelle tabelle Supabase usate da Filmania.

Non fa parte dell'app Flutter — è un tool locale, da eseguire una volta (o poche volte,
è idempotente grazie agli `upsert`), non va deployato né richiamato dall'app.

## Perché serve un mapping ID

Filmania identifica film e serie con **ID TMDB** (perché l'app pesca poster/metadati da
TMDB). TV Time invece esporta ID **TheTVDB** (serie) e **IMDb** (film). Lo script chiama
l'endpoint `/find/{external_id}` di TMDB per ogni film/serie distinti e cachea il
risultato in `tmdb_id_cache.json`, così un secondo run è quasi istantaneo e non rifà le
chiamate già fatte.

Alcuni titoli (soprattutto anime o produzioni di nicchia) potrebbero non avere un
corrispondente TMDB — finiscono in `unmapped_report.json` invece di essere scartati in
silenzio. Controllalo dopo ogni run.

## Prima di iniziare — verifica lo schema Supabase

Le colonne usate da questo script replicano lo schema SQL documentato nei commenti dei
datasource Flutter (`lib/features/watched/.../*_impl.dart`,
`lib/features/watchlist/.../*_impl.dart`), **non** una introspezione diretta del
database (questo ambiente non aveva accesso al progetto Supabase reale). Prima di
lanciare con `--apply`, apri Supabase Studio → Table Editor e controlla che esistano
esattamente:

- `watched_items(id, user_id, media_id, media_title, media_type, poster_path, watched_at)` con `UNIQUE(user_id, media_id, media_type)`
- `watched_episodes(id, user_id, series_id, season_number, episode_number, watched_at)` con `UNIQUE(user_id, series_id, season_number, episode_number)`
- `watchlists(id, user_id, name, created_at)`
- `watchlist_items(id, watchlist_id, media_id, media_title, media_type, poster_path, added_at)` con `UNIQUE(watchlist_id, media_id, media_type)`
- **RLS abilitata** su tutte e quattro, con policy che permettono `SELECT/INSERT` a `auth.uid() = user_id` (per `watchlist_items` la policy tipicamente controlla `user_id` tramite join su `watchlists`, verifica come l'hai implementata tu).

Se una tabella non esiste ancora, crea prima la migration (puoi copiare lo schema SQL
dai commenti nei file dei datasource citati sopra).

## Setup

```bash
cd scripts/tvtime_import
pip install -r requirements.txt
```

Lo script legge automaticamente `SUPABASE_URL`, `SUPABASE_ANON_KEY` e `TMDB_API_KEY`
dal file `.env` nella root del repo filmania (le stesse chiavi che usa l'app Flutter via
Envied) — non serve duplicarle.

## Uso

### 1. Dry-run (default, nessuna scrittura)

```bash
python import_tvtime.py --source "C:\Users\Matteo\Downloads\gdpr-data\tvtime-export-2026-07-03"
```

Produce:
- `tmdb_id_cache.json` — mapping TVDB/IMDb → TMDB (riusabile)
- `unmapped_report.json` — titoli non trovati su TMDB (se presenti)
- `import_report.json` — conteggio di cosa verrebbe importato

Controlla questi file prima di procedere. Se `unmapped_report.json` è corposo, puoi
aggiungere manualmente i mapping mancanti direttamente in `tmdb_id_cache.json` (stessa
struttura) e rilanciare.

### 2. Test veloce su un sottoinsieme

```bash
python import_tvtime.py --source "..." --limit 10 --apply
```

Importa solo i primi 10 film e le prime 10 serie — utile per verificare che lo schema
Supabase sia corretto prima di lanciare l'import completo.

### 3. Import completo

```bash
python import_tvtime.py --source "..." --apply
```

Ti chiede **email e password del tuo account Filmania** (Supabase Auth) al momento
dell'esecuzione — non vengono mai salvate su disco né passate come argomento. Lo script
fa login come te, quindi ogni riga scritta rispetta le policy RLS esistenti (nessuna
service_role key necessaria).

Flag aggiuntivi: `--skip-movies`, `--skip-episodes`, `--skip-lists` per importare solo
una parte.

## Cosa importa

| Origine TV Time | Destinazione Supabase |
|---|---|
| `tvtime-movies-*.csv` (film con `is_watched=true`) | `watched_items` (`media_type='movie'`) |
| `tvtime-series-episodes-*.csv` (episodi con `is_watched=true`) | `watched_episodes` |
| `tvtime-lists-*.csv` (liste "Serie TV" / "Film") | `watchlists` + `watchlist_items` |

Non importa: rating/emozioni, commenti, amici, dati account/dispositivi — quei dati
vivono nell'export GDPR ufficiale, non in questo, e Filmania non ha ancora tabelle
equivalenti.

## Idempotenza

Tutte le scritture usano `upsert` sugli stessi vincoli `UNIQUE` definiti nello schema,
quindi rilanciare lo script più volte (es. dopo aver corretto `unmapped_report.json`)
non crea duplicati.
