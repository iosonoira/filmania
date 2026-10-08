// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(personDetails)
final personDetailsProvider = PersonDetailsFamily._();

final class PersonDetailsProvider
    extends $FunctionalProvider<AsyncValue<Person>, Person, FutureOr<Person>>
    with $FutureModifier<Person>, $FutureProvider<Person> {
  PersonDetailsProvider._({
    required PersonDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'personDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personDetailsHash();

  @override
  String toString() {
    return r'personDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Person> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Person> create(Ref ref) {
    final argument = this.argument as int;
    return personDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personDetailsHash() => r'3673e5d20bc969ea8655758577193e2622bc0804';

final class PersonDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Person>, int> {
  PersonDetailsFamily._()
    : super(
        retry: null,
        name: r'personDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PersonDetailsProvider call(int personId) =>
      PersonDetailsProvider._(argument: personId, from: this);

  @override
  String toString() => r'personDetailsProvider';
}

@ProviderFor(personFilmography)
final personFilmographyProvider = PersonFilmographyFamily._();

final class PersonFilmographyProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PersonCredit>>,
          List<PersonCredit>,
          FutureOr<List<PersonCredit>>
        >
    with
        $FutureModifier<List<PersonCredit>>,
        $FutureProvider<List<PersonCredit>> {
  PersonFilmographyProvider._({
    required PersonFilmographyFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'personFilmographyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personFilmographyHash();

  @override
  String toString() {
    return r'personFilmographyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PersonCredit>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PersonCredit>> create(Ref ref) {
    final argument = this.argument as int;
    return personFilmography(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonFilmographyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personFilmographyHash() => r'abad9f268b862ea461961e668b346fb68327b1da';

final class PersonFilmographyFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<PersonCredit>>, int> {
  PersonFilmographyFamily._()
    : super(
        retry: null,
        name: r'personFilmographyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PersonFilmographyProvider call(int personId) =>
      PersonFilmographyProvider._(argument: personId, from: this);

  @override
  String toString() => r'personFilmographyProvider';
}
