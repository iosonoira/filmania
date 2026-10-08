// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_media_watched.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
