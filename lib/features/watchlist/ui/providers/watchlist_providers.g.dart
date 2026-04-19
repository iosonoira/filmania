// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userWatchlists)
final userWatchlistsProvider = UserWatchlistsProvider._();

final class UserWatchlistsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Watchlist>>,
          List<Watchlist>,
          Stream<List<Watchlist>>
        >
    with $FutureModifier<List<Watchlist>>, $StreamProvider<List<Watchlist>> {
  UserWatchlistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userWatchlistsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userWatchlistsHash();

  @$internal
  @override
  $StreamProviderElement<List<Watchlist>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Watchlist>> create(Ref ref) {
    return userWatchlists(ref);
  }
}

String _$userWatchlistsHash() => r'792a8d89abc442e4c4da96d55362a89e78c5a8f0';

@ProviderFor(watchlistItems)
final watchlistItemsProvider = WatchlistItemsFamily._();

final class WatchlistItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WatchlistItem>>,
          List<WatchlistItem>,
          Stream<List<WatchlistItem>>
        >
    with
        $FutureModifier<List<WatchlistItem>>,
        $StreamProvider<List<WatchlistItem>> {
  WatchlistItemsProvider._({
    required WatchlistItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'watchlistItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchlistItemsHash();

  @override
  String toString() {
    return r'watchlistItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<WatchlistItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WatchlistItem>> create(Ref ref) {
    final argument = this.argument as String;
    return watchlistItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchlistItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchlistItemsHash() => r'5d21fc7c5b39f904598a06de5001c9dade0abdae';

final class WatchlistItemsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<WatchlistItem>>, String> {
  WatchlistItemsFamily._()
    : super(
        retry: null,
        name: r'watchlistItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchlistItemsProvider call(String watchlistId) =>
      WatchlistItemsProvider._(argument: watchlistId, from: this);

  @override
  String toString() => r'watchlistItemsProvider';
}

@ProviderFor(isMediaInWatchlist)
final isMediaInWatchlistProvider = IsMediaInWatchlistFamily._();

final class IsMediaInWatchlistProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsMediaInWatchlistProvider._({
    required IsMediaInWatchlistFamily super.from,
    required (int, MediaType) super.argument,
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
    final argument = this.argument as (int, MediaType);
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
    r'110bccfdd4775607b62029e13ab31d95ce33933f';

final class IsMediaInWatchlistFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, (int, MediaType)> {
  IsMediaInWatchlistFamily._()
    : super(
        retry: null,
        name: r'isMediaInWatchlistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsMediaInWatchlistProvider call(int mediaId, MediaType type) =>
      IsMediaInWatchlistProvider._(argument: (mediaId, type), from: this);

  @override
  String toString() => r'isMediaInWatchlistProvider';
}

@ProviderFor(watchlistIdsContainingMedia)
final watchlistIdsContainingMediaProvider =
    WatchlistIdsContainingMediaFamily._();

final class WatchlistIdsContainingMediaProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          FutureOr<Set<String>>
        >
    with $FutureModifier<Set<String>>, $FutureProvider<Set<String>> {
  WatchlistIdsContainingMediaProvider._({
    required WatchlistIdsContainingMediaFamily super.from,
    required (int, MediaType) super.argument,
  }) : super(
         retry: null,
         name: r'watchlistIdsContainingMediaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchlistIdsContainingMediaHash();

  @override
  String toString() {
    return r'watchlistIdsContainingMediaProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    final argument = this.argument as (int, MediaType);
    return watchlistIdsContainingMedia(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchlistIdsContainingMediaProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchlistIdsContainingMediaHash() =>
    r'e83af9c7dc4039bcf07237202707962f9deddb1f';

final class WatchlistIdsContainingMediaFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Set<String>>, (int, MediaType)> {
  WatchlistIdsContainingMediaFamily._()
    : super(
        retry: null,
        name: r'watchlistIdsContainingMediaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchlistIdsContainingMediaProvider call(int mediaId, MediaType type) =>
      WatchlistIdsContainingMediaProvider._(
        argument: (mediaId, type),
        from: this,
      );

  @override
  String toString() => r'watchlistIdsContainingMediaProvider';
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
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchlistNotifierHash();

  @$internal
  @override
  WatchlistNotifier create() => WatchlistNotifier();
}

String _$watchlistNotifierHash() => r'0baa2f3d6e0d1e7e973954600f5734a861a5d318';

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

String _$userWatchlistHash() => r'f6bdbbaf29fc758113dcc44926edf2137be8edf8';
