import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import '../../domain/entities/watchlist_item.dart';
import '../../domain/repositories/i_watchlist_repository.dart';
import '../datasources/i_watchlist_remote_datasource.dart';
import '../datasources/watchlist_remote_datasource_impl.dart';
import '../models/watchlist_item_dto.dart';

part 'watchlist_repository_impl.g.dart';

class WatchlistRepositoryImpl implements IWatchlistRepository {
  final IWatchlistRemoteDataSource _remoteDataSource;

  WatchlistRepositoryImpl(this._remoteDataSource);

  @override
  Future<void> addToWatchlist(WatchlistItem item) async {
    await _remoteDataSource.addToWatchlist(WatchlistItemDto.fromEntity(item));
  }

  @override
  Future<void> removeFromWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    await _remoteDataSource.removeFromWatchlist(
      userId: userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
  }

  @override
  Stream<List<WatchlistItem>> watchWatchlist(String userId) {
    return _remoteDataSource
        .watchWatchlist(userId)
        .map((dtos) => dtos.map((dto) => dto.toEntity()).toList());
  }

  @override
  Future<bool> isInWatchlist({
    required String userId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    return _remoteDataSource.isInWatchlist(
      userId: userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
  }
}

@riverpod
IWatchlistRepository watchlistRepository(Ref ref) {
  return WatchlistRepositoryImpl(ref.watch(watchlistRemoteDataSourceProvider));
}
