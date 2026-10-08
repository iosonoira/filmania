/// Fasi dell'operazione di import, usate per pilotare la UI e la progress bar.
enum TvTimeImportPhase {
  /// Estrazione zip e parsing dei CSV.
  parsingArchive,

  /// Matching TMDB dei film (imdb_id/tvdb_id -> tmdb_id).
  matchingMovies,

  /// Matching TMDB delle serie (tvdb_id -> tmdb_id), una chiamata per serie.
  matchingSeries,

  /// Recupero del runtime (minuti) da TMDB per film e serie importati,
  /// usato per popolare `runtime_minutes` prima della scrittura.
  fetchingRuntimes,

  /// Scrittura su Supabase (watched_items, watched_episodes, watchlists, watchlist_items).
  writingData,
}
