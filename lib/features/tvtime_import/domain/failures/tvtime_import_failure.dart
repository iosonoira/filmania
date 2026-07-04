/// Failure specifici della feature di import TV Time.
///
/// Questa feature NON dipende da `WatchedFailure`/`WatchlistFailure` di altre
/// feature (vedi regola "no cross-feature imports" in CLAUDE.md) — ha un
/// proprio sealed class, stesso pattern usato altrove nel repo.
sealed class TvTimeImportFailure implements Exception {
  final String message;
  const TvTimeImportFailure(this.message);
}

/// Lo zip selezionato non contiene i 3 CSV attesi, oppure non è un export
/// TV Time valido (nomi file non matchano i pattern attesi).
class TvTimeInvalidArchiveFailure extends TvTimeImportFailure {
  const TvTimeInvalidArchiveFailure([
    super.message = 'Il file selezionato non è un export TV Time valido.',
  ]);
}

/// Errore di rete durante il matching TMDB (dopo aver esaurito i retry).
class TvTimeTmdbMatchFailure extends TvTimeImportFailure {
  const TvTimeTmdbMatchFailure(super.message);
}

/// Errore Supabase durante la scrittura finale.
class TvTimeSupabaseWriteFailure extends TvTimeImportFailure {
  const TvTimeSupabaseWriteFailure(super.message);
}

/// Fallback generico, stesso pattern di `WatchedGenericFailure`.
class TvTimeGenericImportFailure extends TvTimeImportFailure {
  const TvTimeGenericImportFailure([
    super.message = 'Si è verificato un errore imprevisto durante l\'import.',
  ]);
}
