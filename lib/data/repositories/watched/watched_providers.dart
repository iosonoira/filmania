import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/domain/models/media_type.dart';
import 'package:filmania/domain/models/watched_item.dart';
import 'package:filmania/data/repositories/watched/watched_repository_impl.dart';
import 'package:filmania/data/repositories/auth/auth_providers.dart';

part 'watched_providers.g.dart';

@riverpod
Stream<List<WatchedItem>> watchedItems(Ref ref, MediaType mediaType) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  final repo = ref.watch(watchedRepositoryProvider);
  return repo.watchUserWatchedItems(user.id, mediaType);
}

@riverpod
Future<bool> isEpisodeWatched(
  Ref ref, {
  required int seriesId,
  required int seasonNumber,
  required int episodeNumber,
}) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;

  final repo = ref.watch(watchedRepositoryProvider);
  return repo.isEpisodeWatched(
    userId: user.id,
    seriesId: seriesId,
    seasonNumber: seasonNumber,
    episodeNumber: episodeNumber,
  );
}

@riverpod
Stream<List<String>> watchedEpisodes(Ref ref, int seriesId) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  final repo = ref.watch(watchedRepositoryProvider);
  return repo.watchWatchedEpisodes(user.id, seriesId);
}
