import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:filmania/core/supabase/supabase_client.dart';
import 'package:filmania/core/utils/logger.dart';
import 'package:filmania/features/auth/ui/providers/auth_notifier.dart';
import 'package:filmania/features/auth/domain/failures/auth_failure.dart';

part 'image_upload_controller.g.dart';

@riverpod
class ImageUploadController extends _$ImageUploadController {
  @override
  FutureOr<void> build() => null;

  Future<void> upload(dynamic xfile) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final user = ref.read(authStateProvider).value;
      if (user == null) {
        throw const UnknownAuthFailure('Utente non autenticato');
      }

      AppLogger.debug('Leggo bytes file', tag: 'ImageUpload');
      final bytes = await xfile.readAsBytes();

      final supabase = ref.read(supabaseClientProvider);

      final nameParts = (xfile.name as String).split('.');
      final ext = nameParts.length > 1 ? nameParts.last : 'jpg';
      final fileName =
          '${user.id}-${DateTime.now().millisecondsSinceEpoch}.$ext';

      AppLogger.debug('Upload su bucket avatars', tag: 'ImageUpload');
      await supabase.storage
          .from('avatars')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: 'image/$ext', upsert: true),
          );

      final imageUrl = supabase.storage.from('avatars').getPublicUrl(fileName);

      AppLogger.debug('Update user metadata', tag: 'ImageUpload');
      await supabase.auth.updateUser(
        UserAttributes(data: {'avatar_url': imageUrl}),
      );

      AppLogger.debug('Update tabella user', tag: 'ImageUpload');
      await supabase
          .from('user')
          .update({'photo_url': imageUrl})
          .eq('id', user.id);
    });
  }
}
