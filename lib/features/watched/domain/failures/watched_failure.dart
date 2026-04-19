sealed class WatchedFailure implements Exception {
  final String message;
  const WatchedFailure(this.message);
}

class WatchedGenericFailure extends WatchedFailure {
  const WatchedGenericFailure([super.msg = 'An unexpected error occurred.']);
}

class SupabaseWatchedFailure extends WatchedFailure {
  const SupabaseWatchedFailure(super.message);
}
