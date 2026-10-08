// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(personRemoteDataSource)
final personRemoteDataSourceProvider = PersonRemoteDataSourceProvider._();

final class PersonRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          IPersonRemoteDataSource,
          IPersonRemoteDataSource,
          IPersonRemoteDataSource
        >
    with $Provider<IPersonRemoteDataSource> {
  PersonRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<IPersonRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IPersonRemoteDataSource create(Ref ref) {
    return personRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IPersonRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IPersonRemoteDataSource>(value),
    );
  }
}

String _$personRemoteDataSourceHash() =>
    r'abfdb6839d9e5ce90d7cf6d52cf3c7baf7c6f25b';

@ProviderFor(personRepository)
final personRepositoryProvider = PersonRepositoryProvider._();

final class PersonRepositoryProvider
    extends
        $FunctionalProvider<
          IPersonRepository,
          IPersonRepository,
          IPersonRepository
        >
    with $Provider<IPersonRepository> {
  PersonRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personRepositoryHash();

  @$internal
  @override
  $ProviderElement<IPersonRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IPersonRepository create(Ref ref) {
    return personRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IPersonRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IPersonRepository>(value),
    );
  }
}

String _$personRepositoryHash() => r'1cdc0d73f838eb1c00c87e391d42c0f6ce10a203';
