import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/model/income/income.dart';
import 'package:wargaqu/providers/rt_providers.dart';

import '../model/expense/expense.dart';

class TransactionNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> executeNewExpense({
    required String rtId,
    required String description,
    required int amount,
    required String inputtedByUserId,
    DateTime? expenseDate,
  }) async {
    state = const AsyncLoading();
    final newExpense = Expense(
      description: description,
      amount: amount,
      inputtedByUserId: inputtedByUserId,
      expenseDate: expenseDate,
      createdAt: DateTime.now()
    );
    try {
      final rtService = ref.read(rtServiceProvider);
      await rtService.addExpense(rtId: rtId, newExpense: newExpense);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> executeNewIncome({
    required String rtId,
    required String description,
    required int amount,
    required String inputtedByUserId,
    DateTime? incomeDate,
  }) async {
    state = const AsyncLoading();
    final newIncome = Income(amount: amount, inputtedByUserId: inputtedByUserId,
        description: description, incomeDate: incomeDate);
    try {
      final rtService = ref.read(rtServiceProvider);
      await rtService.addIncome(rtId: rtId, newIncome: newIncome);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}