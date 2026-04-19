import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/domain/enums/media_type.dart';
import '../../domain/entities/watched_item.dart';
import '../../domain/repositories/i_watched_repository.dart';
import '../datasources/i_watched_remote_datasource.dart';
import '../datasources/watched_remote_datasource_impl.dart';
import '../models/watched_item_dto.dart';

part 'watched_repository_impl.g.dart';

class WatchedRepositoryImpl implements IWatchedRepository {
  final IWatchedRemoteDataSource _remoteDS;

  WatchedRepositoryImpl(this._remoteDS);

  @override
  Future<void> markAsWatched(WatchedItem item) async {
    final dto = WatchedItemDto.fromEntity(item);
    await _remoteDS.markAsWatched(dto);
  }

  @override
  Future<void> removeFromWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    await _remoteDS.removeFromWatched(
      userId: userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
  }

  @override
  Stream<List<WatchedItem>> watchUserWatchedItems(String userId, MediaType mediaType) {
    return _remoteDS.watchUserWatchedItems(userId, mediaType).map(
          (dtos) => dtos.map((dto) => dto.toEntity()).toList(),
        );
  }

  @override
  Future<bool> isWatched({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    return _remoteDS.isWatched(
      userId: userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
  }
}

@riverpod
IWatchedRepository watchedRepository(Ref ref) {
  return WatchedRepositoryImpl(ref.watch(watchedRemoteDataSourceProvider));
}
