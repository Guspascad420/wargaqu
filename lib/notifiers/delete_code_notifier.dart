import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/providers/rt_providers.dart';

class DeleteCodeNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> execute({
    required String rtId,
    required String codeToDelete,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return ref.read(rtServiceProvider).deleteCode(
        rtId: rtId,
        codeToDelete: codeToDelete,
      );
    });
  }
}