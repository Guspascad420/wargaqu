import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

class AuthNotifier extends AsyncNotifier<void> {
  @override
  void build() {
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

      await userService.saveAndGetFcmToken(firebaseUser.uid);

      state = const AsyncData(null);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> signOut(String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      ref.read(userServiceProvider).deleteFcmToken(userId);
      ref.read(authServiceProvider).signOut();
    });
  }
}