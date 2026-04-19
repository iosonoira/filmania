// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(watchlistRepository)
final watchlistRepositoryProvider = WatchlistRepositoryProvider._();

final class WatchlistRepositoryProvider
    extends
        $FunctionalProvider<
          IWatchlistRepository?,
          IWatchlistRepository?,
          IWatchlistRepository?
        >
    with $Provider<IWatchlistRepository?> {
  WatchlistRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchlistRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchlistRepositoryHash();

  @$internal
  @override
  $ProviderElement<IWatchlistRepository?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IWatchlistRepository? create(Ref ref) {
    return watchlistRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IWatchlistRepository? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IWatchlistRepository?>(value),
    );
  }
}

String _$watchlistRepositoryHash() =>
    r'b5f784ac684c3226448fcb19522d1c6a9616edf9';
