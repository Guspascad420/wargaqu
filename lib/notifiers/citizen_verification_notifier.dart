import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/providers/rt_providers.dart';

class CitizenVerificationNotifier extends AsyncNotifier<void> {
  @override
  void build() {

  }

  Future<void> executeUpdateCitizenStatus({
    required String userId,
    required bool isApproved,
    String? rejectionReason,
    String? rtId
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final rtService = ref.read(rtServiceProvider);
      await rtService.updateCitizenStatus(userId: userId, isApproved: isApproved,
          rejectionReason: rejectionReason, rtId: rtId);
    });
  }
}