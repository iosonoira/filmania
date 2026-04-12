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

@ProviderFor(isMovieInWatchlist)
final isMovieInWatchlistProvider = IsMovieInWatchlistFamily._();

final class IsMovieInWatchlistProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsMovieInWatchlistProvider._({
    required IsMovieInWatchlistFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'isMovieInWatchlistProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isMovieInWatchlistHash();

  @override
  String toString() {
    return r'isMovieInWatchlistProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as int;
    return isMovieInWatchlist(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsMovieInWatchlistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isMovieInWatchlistHash() =>
    r'602da8dcb741e5311e4877030f88821ff417cd50';

final class IsMovieInWatchlistFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, int> {
  IsMovieInWatchlistFamily._()
    : super(
        retry: null,
        name: r'isMovieInWatchlistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsMovieInWatchlistProvider call(int movieId) =>
      IsMovieInWatchlistProvider._(argument: movieId, from: this);

  @override
  String toString() => r'isMovieInWatchlistProvider';
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

String _$watchlistNotifierHash() => r'adbe9efd5fac943fd39a63a3a66b23575c16037d';

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
