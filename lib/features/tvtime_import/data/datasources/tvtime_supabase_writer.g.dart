// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tvtime_supabase_writer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tvTimeSupabaseWriter)
final tvTimeSupabaseWriterProvider = TvTimeSupabaseWriterProvider._();

final class TvTimeSupabaseWriterProvider
    extends
        $FunctionalProvider<
          TvTimeSupabaseWriter,
          TvTimeSupabaseWriter,
          TvTimeSupabaseWriter
        >
    with $Provider<TvTimeSupabaseWriter> {
  TvTimeSupabaseWriterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tvTimeSupabaseWriterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tvTimeSupabaseWriterHash();

  @$internal
  @override
  $ProviderElement<TvTimeSupabaseWriter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TvTimeSupabaseWriter create(Ref ref) {
    return tvTimeSupabaseWriter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TvTimeSupabaseWriter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TvTimeSupabaseWriter>(value),
    );
  }
}

String _$tvTimeSupabaseWriterHash() =>
    r'5c7b9d32d6bd330a5269bed2147a318ae0d05dcb';
