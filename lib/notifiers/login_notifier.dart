import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/providers.dart';

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
      final firebaseUser = await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (firebaseUser == null) {
        throw Exception('Gagal login');
      }
      state = const AsyncData(null);

    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}