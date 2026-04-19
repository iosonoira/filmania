import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:filmania/core/domain/enums/media_type.dart';
import '../../domain/entities/watchlist.dart';
import '../../domain/entities/watchlist_item.dart';
import '../../domain/repositories/i_watchlist_repository.dart';
import '../../domain/failures/watchlist_failure.dart';
import '../datasources/i_watchlist_remote_datasource.dart';
import '../datasources/watchlist_remote_datasource_impl.dart';
import '../models/watchlist_item_dto.dart';
import '../../../auth/ui/providers/auth_notifier.dart';

part 'watchlist_repository_impl.g.dart';

class WatchlistRepositoryImpl implements IWatchlistRepository {
  final IWatchlistRemoteDataSource _remote;
  final String _userId;

  WatchlistRepositoryImpl(this._remote, this._userId);

  // ── Watchlist CRUD ──────────────────────────────────────────────────────────

  @override
  Future<Watchlist> createWatchlist({required String name}) async {
    final dto = await _remote.createWatchlist(userId: _userId, name: name);
    return Watchlist(
      id: dto.id,
      userId: dto.userId,
      name: dto.name,
      createdAt: dto.createdAt,
    );
  }

  @override
  Future<void> deleteWatchlist(String watchlistId) =>
      _remote.deleteWatchlist(watchlistId);

  @override
  Stream<List<Watchlist>> watchUserWatchlists() {
    return _remote.watchUserWatchlists(_userId).map(
      (dtos) => dtos
          .map(
            (dto) => Watchlist(
              id: dto.id,
              userId: dto.userId,
              name: dto.name,
              createdAt: dto.createdAt,
            ),
          )
          .toList(),
    );
  }

  // ── Item CRUD ───────────────────────────────────────────────────────────────

  @override
  Future<void> addItemToWatchlist({
    required String watchlistId,
    required int mediaId,
    required String title,
    required MediaType mediaType,
    required String? posterPath,
  }) async {
    await _remote.addToWatchlist(
      WatchlistItemDto(
        id: '',
        watchlistId: watchlistId,
        mediaId: mediaId,
        title: title,
        mediaType: mediaType,
        posterPath: posterPath,
        addedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> removeItemFromWatchlist({
    required String watchlistId,
    required int mediaId,
    required MediaType mediaType,
  }) async {
    await _remote.removeFromWatchlist(
      userId: _userId,
      mediaId: mediaId,
      mediaType: mediaType,
      watchlistId: watchlistId,
    );
  }

  @override
  Stream<List<WatchlistItem>> watchWatchlistItems(String watchlistId) {
    return _remote
        .watchWatchlistItems(watchlistId)
        .map((dtos) => dtos.map((dto) => dto.toEntity()).toList());
  }

  @override
  Future<Set<String>> getWatchlistIdsContaining({
    required int mediaId,
    required MediaType mediaType,
  }) async {
    final ids = await _remote.getWatchlistIdsContainingMedia(
      userId: _userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
    return ids.toSet();
  }

  @override
  Future<bool> isInAnyWatchlist({
    required int mediaId,
    required MediaType mediaType,
  }) {
    return _remote.isInWatchlist(
      userId: _userId,
      mediaId: mediaId,
      mediaType: mediaType,
    );
  }

  @override
  Stream<List<WatchlistItem>> watchAllItems() {
    return _remote
        .watchWatchlist(_userId)
        .map((dtos) => dtos.map((dto) => dto.toEntity()).toList());
  }
}

@riverpod
IWatchlistRepository? watchlistRepository(Ref ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  return WatchlistRepositoryImpl(
    ref.watch(watchlistRemoteDataSourceProvider),
    user.id,
  );
}
