/// Fasi dell'operazione di import, usate per pilotare la UI e la progress bar.
enum TvTimeImportPhase {
  /// Estrazione zip e parsing dei CSV.
  parsingArchive,

  /// Matching TMDB dei film (imdb_id/tvdb_id -> tmdb_id).
  matchingMovies,

  /// Matching TMDB delle serie (tvdb_id -> tmdb_id), una chiamata per serie.
  matchingSeries,

  /// Scrittura su Supabase (watched_items, watched_episodes, watchlists, watchlist_items).
  writingData,
}
