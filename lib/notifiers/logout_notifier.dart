import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class LogoutNotifier extends AsyncNotifier<void> {
  @override
  void build() {

  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(authServiceProvider).signOut();
    });
  }
}