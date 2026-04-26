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

String _$isMediaWatchedHash() => r'0188166f86e589c1d255249b268a8a41963ff5eb';

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

@ProviderFor(isEpisodeWatched)
final isEpisodeWatchedProvider = IsEpisodeWatchedFamily._();

final class IsEpisodeWatchedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsEpisodeWatchedProvider._({
    required IsEpisodeWatchedFamily super.from,
    required ({int seriesId, int seasonNumber, int episodeNumber})
    super.argument,
  }) : super(
         retry: null,
         name: r'isEpisodeWatchedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isEpisodeWatchedHash();

  @override
  String toString() {
    return r'isEpisodeWatchedProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument =
        this.argument as ({int seriesId, int seasonNumber, int episodeNumber});
    return isEpisodeWatched(
      ref,
      seriesId: argument.seriesId,
      seasonNumber: argument.seasonNumber,
      episodeNumber: argument.episodeNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsEpisodeWatchedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isEpisodeWatchedHash() => r'd2effa5da4808be6b9f2fa7431131efb3a91ab4c';

final class IsEpisodeWatchedFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({int seriesId, int seasonNumber, int episodeNumber})
        > {
  IsEpisodeWatchedFamily._()
    : super(
        retry: null,
        name: r'isEpisodeWatchedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsEpisodeWatchedProvider call({
    required int seriesId,
    required int seasonNumber,
    required int episodeNumber,
  }) => IsEpisodeWatchedProvider._(
    argument: (
      seriesId: seriesId,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
    ),
    from: this,
  );

  @override
  String toString() => r'isEpisodeWatchedProvider';
}

@ProviderFor(watchedEpisodes)
final watchedEpisodesProvider = WatchedEpisodesFamily._();

final class WatchedEpisodesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          Stream<List<String>>
        >
    with $FutureModifier<List<String>>, $StreamProvider<List<String>> {
  WatchedEpisodesProvider._({
    required WatchedEpisodesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'watchedEpisodesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$watchedEpisodesHash();

  @override
  String toString() {
    return r'watchedEpisodesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<String>> create(Ref ref) {
    final argument = this.argument as int;
    return watchedEpisodes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WatchedEpisodesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$watchedEpisodesHash() => r'6da46e76d6df95f96d37501489e8e7947a3b3bcd';

final class WatchedEpisodesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<String>>, int> {
  WatchedEpisodesFamily._()
    : super(
        retry: null,
        name: r'watchedEpisodesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WatchedEpisodesProvider call(int seriesId) =>
      WatchedEpisodesProvider._(argument: seriesId, from: this);

  @override
  String toString() => r'watchedEpisodesProvider';
}
