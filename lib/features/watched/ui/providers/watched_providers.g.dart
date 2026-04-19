// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watched_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(watchedItems)
final watchedItemsProvider = WatchedItemsFamily._();

final class WatchedItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WatchedItem>>,
          List<WatchedItem>,
          Stream<List<WatchedItem>>
        >
    with
        $FutureModifier<List<WatchedItem>>,
        $StreamProvider<List<WatchedItem>> {
  WatchedItemsProvider._({
    required WatchedItemsFamily super.from,
    required MediaType super.argument,
  }) : super(
         retry: null,
         name: r'watchedItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchedItemsHash();

  @override
  String toString() {
    return r'watchedItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<WatchedItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WatchedItem>> create(Ref ref) {
    final argument = this.argument as MediaType;
    return watchedItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchedItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchedItemsHash() => r'11c07cd6644d5b5fb38ed1a75210206f54eedb03';

final class WatchedItemsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<WatchedItem>>, MediaType> {
  WatchedItemsFamily._()
    : super(
        retry: null,
        name: r'watchedItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchedItemsProvider call(MediaType mediaType) =>
      WatchedItemsProvider._(argument: mediaType, from: this);

  @override
  String toString() => r'watchedItemsProvider';
}

@ProviderFor(isMediaWatched)
final isMediaWatchedProvider = IsMediaWatchedFamily._();

final class IsMediaWatchedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsMediaWatchedProvider._({
    required IsMediaWatchedFamily super.from,
    required ({int mediaId, MediaType mediaType}) super.argument,
  }) : super(
         retry: null,
         name: r'isMediaWatchedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isMediaWatchedHash();

  @override
  String toString() {
    return r'isMediaWatchedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as ({int mediaId, MediaType mediaType});
    return isMediaWatched(
      ref,
      mediaId: argument.mediaId,
      mediaType: argument.mediaType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsMediaWatchedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isMediaWatchedHash() => r'7c372dc4f13a0cb83a32e8f440486f3fa1d1b6cc';

final class IsMediaWatchedFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({int mediaId, MediaType mediaType})
        > {
  IsMediaWatchedFamily._()
    : super(
        retry: null,
        name: r'isMediaWatchedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsMediaWatchedProvider call({
    required int mediaId,
    required MediaType mediaType,
  }) => IsMediaWatchedProvider._(
    argument: (mediaId: mediaId, mediaType: mediaType),
    from: this,
  );

  @override
  String toString() => r'isMediaWatchedProvider';
}
