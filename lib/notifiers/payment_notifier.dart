import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/providers/providers.dart';

import '../model/bill/bill_type.dart';

class PaymentNotifier extends AsyncNotifier<void> {
  @override
  void build() {

  }

  Future<void> executeMakePayment({
    required String userId,
    required String billId,
    required BillType billType,
    required String billName,
    required int amountPaid,
    required String paymentMethod,
    required File proofImageFile,
    String? citizenNote
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final paymentService = ref.watch(paymentServiceProvider);
      await paymentService.makePayment(
        userId: userId,
        billId: billId,
        billType: billType,
        billName: billName,
        amountPaid: amountPaid,
        paymentMethod: paymentMethod,
        proofImageFile: proofImageFile,
        citizenNote: citizenNote
      );
    });
  }
}