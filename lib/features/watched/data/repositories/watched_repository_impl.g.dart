// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watched_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(watchedRepository)
final watchedRepositoryProvider = WatchedRepositoryProvider._();

final class WatchedRepositoryProvider
    extends
        $FunctionalProvider<
          IWatchedRepository,
          IWatchedRepository,
          IWatchedRepository
        >
    with $Provider<IWatchedRepository> {
  WatchedRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchedRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchedRepositoryHash();

  @$internal
  @override
  $ProviderElement<IWatchedRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IWatchedRepository create(Ref ref) {
    return watchedRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IWatchedRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IWatchedRepository>(value),
    );
  }
}

String _$watchedRepositoryHash() => r'2f753342109354651c7e30d476990a5a4b674329';
