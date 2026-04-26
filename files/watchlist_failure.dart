sealed class WatchlistFailure implements Exception {
  final String message;
  const WatchlistFailure(this.message);

  @override
  String toString() => message;
}

class SupabaseFailure extends WatchlistFailure {
  const SupabaseFailure([super.message = 'Si è verificato un errore con il database.']);
}

class WatchlistGenericFailure extends WatchlistFailure {
  const WatchlistGenericFailure([super.message = 'Si è verificato un errore imprevisto nella watchlist.']);
}
