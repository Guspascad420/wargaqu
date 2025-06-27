import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/bill/bill_type.dart';
import '../providers/providers.dart';

class BillCreationNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> executeNewBill({
    required String rtId,
    required String billName,
    required BillType billType,
    required double amount,
    required String description,
    required DateTime dueDate
  }) async {
    state = const AsyncLoading(); // Set loading state
    try {
      final billService = ref.read(billServiceProvider);
      await billService.createNewBill(
        rtId: rtId,
        billName: billName,
        billType: billType,
        amount: amount,
        dueDate: dueDate
      );
      state = const AsyncData(null); // Set success state (or AsyncData with a success message)
      print('Bill created successfully!');
    } catch (e, stackTrace) {
      print('Error submitting new bill: $e');
      state = AsyncError(e, stackTrace); // Set error state
    }
  }
}