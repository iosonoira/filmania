// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userWatchlist)
final userWatchlistProvider = UserWatchlistProvider._();

final class UserWatchlistProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WatchlistItem>>,
          List<WatchlistItem>,
          Stream<List<WatchlistItem>>
        >
    with
        $FutureModifier<List<WatchlistItem>>,
        $StreamProvider<List<WatchlistItem>> {
  UserWatchlistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userWatchlistProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userWatchlistHash();

  @$internal
  @override
  $StreamProviderElement<List<WatchlistItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WatchlistItem>> create(Ref ref) {
    return userWatchlist(ref);
  }
}

String _$userWatchlistHash() => r'b27efb7515b552d02e19497dc84d54baddf73fba';

@ProviderFor(isMediaInWatchlist)
final isMediaInWatchlistProvider = IsMediaInWatchlistFamily._();

final class IsMediaInWatchlistProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsMediaInWatchlistProvider._({
    required IsMediaInWatchlistFamily super.from,
    required (int, DiscoverMediaType) super.argument,
  }) : super(
         retry: null,
         name: r'isMediaInWatchlistProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isMediaInWatchlistHash();

  @override
  String toString() {
    return r'isMediaInWatchlistProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as (int, DiscoverMediaType);
    return isMediaInWatchlist(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is IsMediaInWatchlistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isMediaInWatchlistHash() =>
    r'af3611ef6ac349399a15a3fc0ea5e200fcefbe28';

final class IsMediaInWatchlistFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, (int, DiscoverMediaType)> {
  IsMediaInWatchlistFamily._()
    : super(
        retry: null,
        name: r'isMediaInWatchlistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsMediaInWatchlistProvider call(int mediaId, DiscoverMediaType type) =>
      IsMediaInWatchlistProvider._(argument: (mediaId, type), from: this);

  @override
  String toString() => r'isMediaInWatchlistProvider';
}

@ProviderFor(WatchlistNotifier)
final watchlistProvider = WatchlistNotifierProvider._();

final class WatchlistNotifierProvider
    extends $AsyncNotifierProvider<WatchlistNotifier, void> {
  WatchlistNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchlistProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchlistNotifierHash();

  @$internal
  @override
  WatchlistNotifier create() => WatchlistNotifier();
}

String _$watchlistNotifierHash() => r'42fd533341a955d19c2a4a76052763cdc270d81a';

abstract class _$WatchlistNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
