import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/domain/models/favorite_item.dart';
import 'package:filmania/data/repositories/favorites/favorites_repository_impl.dart';
import 'package:filmania/data/repositories/auth/auth_providers.dart';

part 'favorites_providers.g.dart';

@riverpod
Stream<List<FavoriteItem>> favorites(Ref ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  final repo = ref.watch(favoritesRepositoryProvider);
  return repo.watchUserFavorites(user.id);
}

@riverpod
Future<bool> isMediaFavorite(
  Ref ref, {
  required int mediaId,
  required MediaType mediaType,
}) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;

  final repo = ref.watch(favoritesRepositoryProvider);
  return repo.isFavorite(
    userId: user.id,
    mediaId: mediaId,
    mediaType: mediaType,
  );
}
