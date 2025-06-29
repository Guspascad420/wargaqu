import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/rt_providers.dart';

class AddNewBankAccountNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> executeAddNewBankAccount({
    required String rtId,
    required String bankName,
    required String accountNumber,
    required String accountHolder,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final rtService = ref.read(rtServiceProvider);
      await rtService.addBankAccount(
        rtId: rtId, bankName: bankName, accountNumber: accountNumber,
          accountHolder: accountHolder
      );
    });
  }
}