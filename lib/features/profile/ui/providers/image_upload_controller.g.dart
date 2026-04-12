// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ImageUploadController)
final imageUploadControllerProvider = ImageUploadControllerProvider._();

final class ImageUploadControllerProvider
    extends $AsyncNotifierProvider<ImageUploadController, void> {
  ImageUploadControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageUploadControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageUploadControllerHash();

  @$internal
  @override
  ImageUploadController create() => ImageUploadController();
}

String _$imageUploadControllerHash() =>
    r'b5facf93e67842967c70be9554a1d2ab2d2147b7';

abstract class _$ImageUploadController extends $AsyncNotifier<void> {
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
