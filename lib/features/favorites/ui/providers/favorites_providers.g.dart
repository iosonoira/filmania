// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favorites)
final favoritesProvider = FavoritesProvider._();

final class FavoritesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FavoriteItem>>,
          List<FavoriteItem>,
          Stream<List<FavoriteItem>>
        >
    with
        $FutureModifier<List<FavoriteItem>>,
        $StreamProvider<List<FavoriteItem>> {
  FavoritesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesHash();

  @$internal
  @override
  $StreamProviderElement<List<FavoriteItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FavoriteItem>> create(Ref ref) {
    return favorites(ref);
  }
}

String _$favoritesHash() => r'a4a24006147e2baf85912191dad469df39317366';

@ProviderFor(isMediaFavorite)
final isMediaFavoriteProvider = IsMediaFavoriteFamily._();

final class IsMediaFavoriteProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsMediaFavoriteProvider._({
    required IsMediaFavoriteFamily super.from,
    required ({int mediaId, MediaType mediaType}) super.argument,
  }) : super(
         retry: null,
         name: r'isMediaFavoriteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isMediaFavoriteHash();

  @override
  String toString() {
    return r'isMediaFavoriteProvider'
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
    return isMediaFavorite(
      ref,
      mediaId: argument.mediaId,
      mediaType: argument.mediaType,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsMediaFavoriteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isMediaFavoriteHash() => r'f7ab35b0b3fdeab0dbbfe266e4481336bea800fc';

final class IsMediaFavoriteFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<bool>,
          ({int mediaId, MediaType mediaType})
        > {
  IsMediaFavoriteFamily._()
    : super(
        retry: null,
        name: r'isMediaFavoriteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsMediaFavoriteProvider call({
    required int mediaId,
    required MediaType mediaType,
  }) => IsMediaFavoriteProvider._(
    argument: (mediaId: mediaId, mediaType: mediaType),
    from: this,
  );

  @override
  String toString() => r'isMediaFavoriteProvider';
}
