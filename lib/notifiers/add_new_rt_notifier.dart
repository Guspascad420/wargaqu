import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/providers/rt_providers.dart';

class AddNewRtNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> executeAddNewRt({
    required int rtNumber,
    required String rtName,
    required String rwId,
    required String address,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final rtService = ref.read(rtServiceProvider);
      await rtService.addNewRt(
        rtNumber: rtNumber,
        rtName: rtName,
        rwId: rwId,
        address: address,
      );
    });
  }
}