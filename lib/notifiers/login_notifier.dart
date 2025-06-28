import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

class LoginNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final authService = ref.read(authServiceProvider);
      final userService = ref.read(userServiceProvider);

      final firebaseUser = await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (firebaseUser == null) {
        throw Exception('Gagal login');
      }

      userService.saveAndGetFcmToken(firebaseUser.uid);
      state = const AsyncData(null);

    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}