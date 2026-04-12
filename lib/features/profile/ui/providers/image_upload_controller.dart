import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase/supabase_client.dart';

part 'image_upload_controller.g.dart';

@riverpod
class ImageUploadController extends _$ImageUploadController {
  @override
  FutureOr<void> build() => null;

  // Use standard Riverpod AsyncNotifier approach which gives Idle/Pending/Success/Error
  Future<void> upload(dynamic xfile) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      // 1. Legge il file
      debugPrint('Step 1: Leggo bytes...');
      final bytes = await xfile.readAsBytes();

      final supabase = ref.read(supabaseClientProvider);
      final user = supabase.auth.currentUser;
      
      if (user == null) {
        throw Exception('Utente non autenticato');
      }

      final nameParts = xfile.name.split('.');
      final ext = nameParts.length > 1 ? nameParts.last : 'jpg';
      final fileName = '${user.id}-${DateTime.now().millisecondsSinceEpoch}.$ext';

      // 2. Upload su Storage
      debugPrint('Step 2: Upload su bucket avatars...');
      try {
        await supabase.storage.from('avatars').uploadBinary(
              fileName,
              bytes,
              fileOptions: FileOptions(contentType: 'image/$ext', upsert: true),
            );
      } catch (e) {
        debugPrint('CRASH IN UPLOAD STORAGE: $e');
        rethrow;
      }

      final imageUrl = supabase.storage.from('avatars').getPublicUrl(fileName);

      // 3. User metadata
      debugPrint('Step 3: Update user metadata...');
      try {
        await supabase.auth.updateUser(
          UserAttributes(data: {'avatar_url': imageUrl}),
        );
      } catch (e) {
        debugPrint('CRASH IN METADATA UPDATE: $e');
        rethrow;
      }
      
      // 4. Update public.user
      debugPrint('Step 4: Update tabella user...');
      try {
        await supabase.from('user').update({
          'photo_url': imageUrl,
        }).eq('id', user.id);
      } catch (e) {
        debugPrint('CRASH IN PUBLIC.USER UPDATE: $e');
        rethrow;
      }
    });
  }
}
