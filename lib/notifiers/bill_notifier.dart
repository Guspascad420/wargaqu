import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/bill/bill_type.dart';
import '../providers/providers.dart';

class BillNotifier extends AsyncNotifier<void> {
  @override
  void build() {
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
      debugPrint('Bill created successfully!');
    } catch (e, stackTrace) {
      debugPrint('Error submitting new bill: $e');
      state = AsyncError(e, stackTrace); // Set error state
    }
  }

  Future<void> executeUpdateBill({
    required String billId,
    required String billName,
    required double amount,
    required String description,
    required DateTime dueDate
  }) async {
    state = const AsyncLoading();
    try {
      final billService = ref.read(billServiceProvider);
      await billService.updateBill(
          billId: billId,
          billName: billName,
          amount: amount,
          dueDate: dueDate,
          description: description
      );
      state = const AsyncData(null);
      debugPrint('Bill updated successfully!');
    } catch (e, stackTrace) {
      debugPrint('Error updating new bill: $e');
      state = AsyncError(e, stackTrace); // Set error state
    }
  }

  Future<void> executeDeleteBill(String billId) async {
    state = const AsyncLoading();
    try {
      final billService = ref.read(billServiceProvider);
      await billService.deleteBill(billId);
      state = const AsyncData(null);
      debugPrint('Bill deleted successfully!');
    } catch (e, stackTrace) {
      debugPrint('Error deleting bill: $e');
      state = AsyncError(e, stackTrace);
    }
  }
}