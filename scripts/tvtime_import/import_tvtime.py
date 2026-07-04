#!/usr/bin/env python3
"""
Import dei dati di TV Time (export della Chrome extension "TV Time Out by Refract")
nello schema Supabase di Filmania.

COSA FA
-------
1. Legge i CSV dell'export TV Time: serie, film, episodi, liste.
2. Mappa gli ID esterni (TheTVDB per le serie, IMDb/TVDB per i film) su ID TMDB,
   perché lo schema Filmania usa TMDB come chiave (media_id / series_id).
   La mappatura viene cachata in tmdb_id_cache.json per non rifare le chiamate
   TMDB ad ogni run.
3. Fa login su Supabase con le TUE credenziali reali dell'account Filmania
   (Supabase Auth email+password) — così le policy RLS (auth.uid() = user_id)
   valgono automaticamente, senza bisogno della service_role key.
4. Scrive (upsert, quindi idempotente e ri-eseguibile) in:
   - watched_items      (film visti)
   - watched_episodes   (episodi visti)
   - watchlists + watchlist_items  (le liste "Serie TV" / "Film" di TV Time)

IMPORTANTE — SCHEMA DB
-----------------------
Le colonne usate qui rispecchiano lo schema SQL documentato nei commenti dei
datasource Flutter (lib/features/watched/.../*_impl.dart e
lib/features/watchlist/.../*_impl.dart). Non ho accesso diretto al database
Supabase reale (nessuna migration/CLI nel repo), quindi PRIMA di lanciare con
--apply verifica in Supabase Studio che le tabelle esistano con queste colonne
esatte. Se manca qualcosa lo script fallirà in modo esplicito riga per riga
(non silenzioso), ma è meglio controllare prima.

USO
---
    cd scripts/tvtime_import
    pip install -r requirements.txt

    # 1) DRY RUN (default): nessuna scrittura, solo report di cosa verrebbe importato
    #    e quali film/serie non sono stati mappati su TMDB
    python import_tvtime.py --source "C:\\Users\\Matteo\\Downloads\\gdpr-data\\tvtime-export-2026-07-03"

    # 2) Controlla unmapped_report.json e tmdb_id_cache.json

    # 3) SCRITTURA REALE su Supabase (chiede email+password del tuo account Filmania)
    python import_tvtime.py --source "C:\\Users\\Matteo\\Downloads\\gdpr-data\\tvtime-export-2026-07-03" --apply

Flag utili:
    --limit N          processa solo i primi N film e N serie (per un test veloce)
    --skip-movies       salta l'import dei film
    --skip-episodes      salta l'import degli episodi
    --skip-lists         salta l'import delle watchlist
"""

from __future__ import annotations

import argparse
import csv
import getpass
import json
import re
import sys
import time
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

import requests

SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parent.parent  # .../filmania
ENV_FILE = REPO_ROOT / ".env"
CACHE_FILE = SCRIPT_DIR / "tmdb_id_cache.json"
UNMAPPED_REPORT = SCRIPT_DIR / "unmapped_report.json"
IMPORT_REPORT = SCRIPT_DIR / "import_report.json"

TMDB_BASE = "https://api.themoviedb.org/3"
BATCH_SIZE = 400


# --------------------------------------------------------------------------- #
# .env parsing (riusa le stesse chiavi che l'app Flutter legge via Envied)
# --------------------------------------------------------------------------- #
def load_env(path: Path) -> dict[str, str]:
    if not path.exists():
        sys.exit(f"Non trovo {path}. Lo script deve stare in scripts/tvtime_import/ dentro il repo filmania.")
    env: dict[str, str] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, _, value = line.partition("=")
        env[key.strip()] = value.strip().strip('"').strip("'")
    required = ["SUPABASE_URL", "SUPABASE_ANON_KEY", "TMDB_API_KEY"]
    missing = [k for k in required if k not in env or not env[k]]
    if missing:
        sys.exit(f"Mancano queste chiavi in {path}: {missing}")
    return env


# --------------------------------------------------------------------------- #
# TMDB: mapping ID esterni -> ID TMDB, con cache locale
# --------------------------------------------------------------------------- #
class TmdbMapper:
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.cache: dict[str, dict] = {}
        self.unmapped: list[dict] = []
        if CACHE_FILE.exists():
            self.cache = json.loads(CACHE_FILE.read_text(encoding="utf-8"))

    def save_cache(self):
        CACHE_FILE.write_text(json.dumps(self.cache, indent=2, ensure_ascii=False), encoding="utf-8")

    def _find(self, external_id: str, source: str) -> dict | None:
        # TMDB_API_KEY in .env è un Read Access Token v4 (JWT), va passato come
        # Bearer header — stesso schema usato da TmdbAuthInterceptor nell'app Flutter.
        # Non è una v3 api_key da query string.
        url = f"{TMDB_BASE}/find/{external_id}"
        headers = {"Authorization": f"Bearer {self.api_key}"}
        params = {"external_source": source}
        for attempt in range(3):
            resp = requests.get(url, params=params, headers=headers, timeout=15)
            if resp.status_code == 429:
                time.sleep(2 * (attempt + 1))
                continue
            resp.raise_for_status()
            return resp.json()
        return None

    def resolve_series(self, tvdb_id: str, title_hint: str) -> dict | None:
        """Mappa un tvdb_id di serie -> {tmdb_id, poster_path, title}."""
        cache_key = f"tv:tvdb:{tvdb_id}"
        if cache_key in self.cache:
            return self.cache[cache_key] or None

        data = self._find(tvdb_id, "tvdb_id")
        result = None
        if data and data.get("tv_results"):
            r = data["tv_results"][0]
            result = {"tmdb_id": r["id"], "poster_path": r.get("poster_path"), "title": r.get("name")}
        self.cache[cache_key] = result
        if result is None:
            self.unmapped.append({"type": "series", "tvdb_id": tvdb_id, "title": title_hint})
        return result

    def resolve_movie(self, imdb_id: str, tvdb_id: str, title_hint: str) -> dict | None:
        """Mappa un film -> {tmdb_id, poster_path, title}. Prova prima imdb_id, poi tvdb_id."""
        cache_key = f"movie:imdb:{imdb_id}:tvdb:{tvdb_id}"
        if cache_key in self.cache:
            return self.cache[cache_key] or None

        result = None
        if imdb_id:
            data = self._find(imdb_id, "imdb_id")
            if data and data.get("movie_results"):
                r = data["movie_results"][0]
                result = {"tmdb_id": r["id"], "poster_path": r.get("poster_path"), "title": r.get("title")}
        if result is None and tvdb_id:
            data = self._find(tvdb_id, "tvdb_id")
            if data and data.get("movie_results"):
                r = data["movie_results"][0]
                result = {"tmdb_id": r["id"], "poster_path": r.get("poster_path"), "title": r.get("title")}

        self.cache[cache_key] = result
        if result is None:
            self.unmapped.append({"type": "movie", "imdb_id": imdb_id, "tvdb_id": tvdb_id, "title": title_hint})
        return result


# --------------------------------------------------------------------------- #
# Parsing date TV Time -> ISO8601 UTC (timestamptz)
# --------------------------------------------------------------------------- #
def parse_tvtime_date(raw: str | None) -> str | None:
    if not raw:
        return None
    raw = raw.strip()
    if not raw:
        return None
    # Formati osservati nell'export: "2019-12-29T19:44:36Z" e "2022-11-27 13:43:35"
    try:
        if raw.endswith("Z"):
            dt = datetime.strptime(raw, "%Y-%m-%dT%H:%M:%SZ").replace(tzinfo=timezone.utc)
        elif "T" in raw:
            dt = datetime.fromisoformat(raw.replace("Z", "+00:00"))
            if dt.tzinfo is None:
                dt = dt.replace(tzinfo=timezone.utc)
        else:
            dt = datetime.strptime(raw, "%Y-%m-%d %H:%M:%S").replace(tzinfo=timezone.utc)
        return dt.isoformat()
    except ValueError:
        return None


def read_csv(path: Path) -> list[dict]:
    with path.open(encoding="utf-8") as f:
        return list(csv.DictReader(f))


# --------------------------------------------------------------------------- #
# Costruzione righe da importare
# --------------------------------------------------------------------------- #
def build_watched_movies(movies: list[dict], mapper: TmdbMapper, limit: int | None) -> list[dict]:
    rows = []
    watched = [m for m in movies if m.get("is_watched") == "true"]
    if limit:
        watched = watched[:limit]
    for m in watched:
        mapped = mapper.resolve_movie(m.get("imdb_id", ""), m.get("tvdb_id", ""), m.get("title", ""))
        if not mapped:
            continue
        watched_at = parse_tvtime_date(m.get("watched_at") or m.get("created_at"))
        rows.append(
            {
                "media_id": mapped["tmdb_id"],
                "media_title": mapped["title"] or m.get("title"),
                "media_type": "movie",
                "poster_path": mapped["poster_path"],
                "watched_at": watched_at,
            }
        )
    return rows


def build_watched_episodes(episodes: list[dict], mapper: TmdbMapper, series_limit_ids: set | None) -> list[dict]:
    rows = []
    for e in episodes:
        if e.get("is_watched") != "true":
            continue
        tvdb_series_id = e.get("series_tvdb_id")
        if series_limit_ids is not None and tvdb_series_id not in series_limit_ids:
            continue
        mapped = mapper.resolve_series(tvdb_series_id, e.get("title", ""))
        if not mapped:
            continue
        watched_at = parse_tvtime_date(e.get("watched_at"))
        if not watched_at:
            continue
        try:
            season = int(e["season"])
            episode = int(e["episode"])
        except (KeyError, ValueError):
            continue
        rows.append(
            {
                "series_id": mapped["tmdb_id"],
                "season_number": season,
                "episode_number": episode,
                "watched_at": watched_at,
            }
        )
    return rows


def build_watchlists(lists_rows: list[dict], movies_by_uuid: dict[str, dict], mapper: TmdbMapper) -> dict[str, list[dict]]:
    """Ritorna {nome_lista: [righe watchlist_items]}."""
    grouped: dict[str, list[dict]] = defaultdict(list)
    for row in lists_rows:
        list_name = row["list_name"].strip()
        item_type = row["item_type"].strip()

        if item_type == "series":
            mapped = mapper.resolve_series(row.get("tvdb_id", ""), row.get("name", ""))
            media_type = "tv"
        elif item_type == "movie":
            movie = movies_by_uuid.get(row.get("uuid", ""))
            if not movie:
                continue
            mapped = mapper.resolve_movie(movie.get("imdb_id", ""), movie.get("tvdb_id", ""), row.get("name", ""))
            media_type = "movie"
        else:
            continue

        if not mapped:
            continue

        grouped[list_name].append(
            {
                "media_id": mapped["tmdb_id"],
                "media_title": mapped["title"] or row.get("name"),
                "media_type": media_type,
                "poster_path": mapped["poster_path"],
            }
        )
    return grouped


# --------------------------------------------------------------------------- #
# Supabase: upsert in batch
# --------------------------------------------------------------------------- #
def chunked(items: list, size: int):
    for i in range(0, len(items), size):
        yield items[i : i + size]


def upsert_watched_items(client, user_id: str, rows: list[dict]) -> int:
    count = 0
    for batch in chunked(rows, BATCH_SIZE):
        payload = [{**r, "user_id": user_id} for r in batch]
        client.table("watched_items").upsert(payload, on_conflict="user_id,media_id,media_type").execute()
        count += len(batch)
        print(f"  watched_items: {count}/{len(rows)}")
    return count


def upsert_watched_episodes(client, user_id: str, rows: list[dict]) -> int:
    count = 0
    for batch in chunked(rows, BATCH_SIZE):
        payload = [{**r, "user_id": user_id} for r in batch]
        client.table("watched_episodes").upsert(
            payload, on_conflict="user_id,series_id,season_number,episode_number"
        ).execute()
        count += len(batch)
        print(f"  watched_episodes: {count}/{len(rows)}")
    return count


def get_or_create_watchlist(client, user_id: str, name: str) -> str:
    existing = (
        client.table("watchlists").select("id").eq("user_id", user_id).eq("name", name).limit(1).execute()
    )
    if existing.data:
        return existing.data[0]["id"]
    created = client.table("watchlists").insert({"user_id": user_id, "name": name}).execute()
    return created.data[0]["id"]


def upsert_watchlist_items(client, watchlist_id: str, rows: list[dict]) -> int:
    count = 0
    for batch in chunked(rows, BATCH_SIZE):
        payload = [{**r, "watchlist_id": watchlist_id} for r in batch]
        client.table("watchlist_items").upsert(
            payload, on_conflict="watchlist_id,media_id,media_type"
        ).execute()
        count += len(batch)
        print(f"  watchlist_items ({watchlist_id}): {count}/{len(rows)}")
    return count


# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
def main():
    parser = argparse.ArgumentParser(description="Importa i dati TV Time in Supabase per Filmania.")
    parser.add_argument("--source", required=True, help="Percorso della cartella export TV Time (tvtime-export-YYYY-MM-DD)")
    parser.add_argument("--apply", action="store_true", help="Scrive davvero su Supabase (default: dry-run)")
    parser.add_argument("--limit", type=int, default=None, help="Limita a N film / N serie (per test veloci)")
    parser.add_argument("--skip-movies", action="store_true")
    parser.add_argument("--skip-episodes", action="store_true")
    parser.add_argument("--skip-lists", action="store_true")
    args = parser.parse_args()

    source = Path(args.source)
    if not source.exists():
        sys.exit(f"Cartella non trovata: {source}")

    env = load_env(ENV_FILE)
    mapper = TmdbMapper(env["TMDB_API_KEY"])

    # trova i file per data (il nome include la data dell'export)
    def find_one(pattern: str) -> Path:
        matches = list(source.glob(pattern))
        if not matches:
            sys.exit(f"Non trovo nessun file che matcha {pattern} in {source}")
        return matches[0]

    movies_csv = read_csv(find_one("tvtime-movies-*.csv"))
    series_episodes_csv = read_csv(find_one("tvtime-series-episodes-*.csv"))
    lists_csv = read_csv(find_one("tvtime-lists-*.csv"))
    movies_by_uuid = {m["uuid"]: m for m in movies_csv}

    print(f"Caricati: {len(movies_csv)} film, {len(series_episodes_csv)} righe episodi, {len(lists_csv)} righe liste.")

    series_limit_ids = None
    watched_movie_rows: list[dict] = []
    watched_episode_rows: list[dict] = []
    watchlists_grouped: dict[str, list[dict]] = {}

    if not args.skip_movies:
        print("\nMappatura film su TMDB (imdb_id -> tmdb_id)...")
        watched_movie_rows = build_watched_movies(movies_csv, mapper, args.limit)
        mapper.save_cache()
        print(f"  -> {len(watched_movie_rows)} film mappati e pronti.")

    if not args.skip_episodes:
        print("\nMappatura serie su TMDB (tvdb_id -> tmdb_id) e costruzione episodi visti...")
        if args.limit:
            distinct_series = list({e["series_tvdb_id"] for e in series_episodes_csv})[: args.limit]
            series_limit_ids = set(distinct_series)
        watched_episode_rows = build_watched_episodes(series_episodes_csv, mapper, series_limit_ids)
        mapper.save_cache()
        print(f"  -> {len(watched_episode_rows)} episodi mappati e pronti.")

    if not args.skip_lists:
        print("\nCostruzione watchlist da tvtime-lists...")
        watchlists_grouped = build_watchlists(lists_csv, movies_by_uuid, mapper)
        mapper.save_cache()
        for name, rows in watchlists_grouped.items():
            print(f"  -> lista '{name}': {len(rows)} elementi mappati.")

    if mapper.unmapped:
        UNMAPPED_REPORT.write_text(json.dumps(mapper.unmapped, indent=2, ensure_ascii=False), encoding="utf-8")
        print(f"\n{len(mapper.unmapped)} elementi NON mappati su TMDB -> dettagli in {UNMAPPED_REPORT.name}")

    summary = {
        "watched_movies": len(watched_movie_rows),
        "watched_episodes": len(watched_episode_rows),
        "watchlists": {name: len(rows) for name, rows in watchlists_grouped.items()},
        "unmapped": len(mapper.unmapped),
    }
    IMPORT_REPORT.write_text(json.dumps(summary, indent=2, ensure_ascii=False), encoding="utf-8")
    print("\n=== RIEPILOGO ===")
    print(json.dumps(summary, indent=2, ensure_ascii=False))

    if not args.apply:
        print("\nDRY-RUN completato. Nessuna scrittura su Supabase.")
        print("Controlla import_report.json e (se presente) unmapped_report.json, poi rilancia con --apply.")
        return

    # --- scrittura reale ---
    try:
        from supabase import create_client
    except ImportError:
        sys.exit("Manca il pacchetto 'supabase'. Esegui: pip install -r requirements.txt")

    client = create_client(env["SUPABASE_URL"], env["SUPABASE_ANON_KEY"])

    print("\nLogin su Supabase (credenziali del tuo account Filmania).")
    email = input("Email: ").strip()
    password = getpass.getpass("Password: ")
    auth_response = client.auth.sign_in_with_password({"email": email, "password": password})
    if not auth_response.user:
        sys.exit("Login fallito.")
    user_id = auth_response.user.id
    print(f"Login OK. user_id = {user_id}")

    if watched_movie_rows:
        print("\nScrittura watched_items...")
        upsert_watched_items(client, user_id, watched_movie_rows)

    if watched_episode_rows:
        print("\nScrittura watched_episodes...")
        upsert_watched_episodes(client, user_id, watched_episode_rows)

    if watchlists_grouped:
        print("\nScrittura watchlists + watchlist_items...")
        for name, rows in watchlists_grouped.items():
            watchlist_id = get_or_create_watchlist(client, user_id, name)
            upsert_watchlist_items(client, watchlist_id, rows)

    print("\nImport completato.")


if __name__ == "__main__":
    main()
