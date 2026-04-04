import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // Initial state
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    
    // Simulo una chiamata API
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 2));
      
      if (email == 'test@test.com' && password == 'password') {
        // Successo
        return;
      } else {
        throw Exception('Credenziali non valide');
      }
    });
  }
}
