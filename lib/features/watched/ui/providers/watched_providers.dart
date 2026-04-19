import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../../auth/ui/providers/auth_notifier.dart';
import '../../domain/entities/watched_item.dart';
import '../../data/repositories/watched_repository_impl.dart';

part 'watched_providers.g.dart';

@riverpod
Stream<List<WatchedItem>> watchedItems(Ref ref, MediaType mediaType) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);

  final repo = ref.watch(watchedRepositoryProvider);
  return repo.watchUserWatchedItems(user.id, mediaType);
}

@riverpod
Future<bool> isMediaWatched(Ref ref, {required int mediaId, required MediaType mediaType}) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return false;

  final repo = ref.watch(watchedRepositoryProvider);
  return repo.isWatched(userId: user.id, mediaId: mediaId, mediaType: mediaType);
}
