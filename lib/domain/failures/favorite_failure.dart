sealed class FavoriteFailure implements Exception {
  final String message;
  const FavoriteFailure(this.message);
}

class FavoriteGenericFailure extends FavoriteFailure {
  const FavoriteGenericFailure([super.msg = 'An unexpected error occurred.']);
}

class SupabaseFavoriteFailure extends FavoriteFailure {
  const SupabaseFavoriteFailure(super.message);
}
