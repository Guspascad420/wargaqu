import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/model/confirmation/confirmation_state.dart';
import 'package:wargaqu/providers/providers.dart';

import '../providers/citizen_providers.dart';

class PaymentConfirmationNotifier extends Notifier<ConfirmationState> {
  @override
  ConfirmationState build() {
    return const ConfirmationState();
  }

  Future<void> executeConfirmPayment({
    required String userId,
    required String billName,
    required String billId,
    required String paymentId,
    required int amountPaid,
    required String rtId,
    String? rtNote
  }) async {
    state = const ConfirmationState(isLoading: true, actionInProgress: ConfirmationAction.confirm);
    try {
      final paymentService = ref.read(paymentServiceProvider);
      await paymentService.confirmPayment(
          userId: userId,
          billId: billId,
          billName: billName,
          paymentId: paymentId,
          amountPaid: amountPaid,
          rtId: rtId,
          rtNote: rtNote
      );
      ref.invalidate(citizenListProvider);
      state = const ConfirmationState(isLoading: false, actionInProgress: null);
    } catch (e) {
      state = ConfirmationState(isLoading: false, actionInProgress: null, errorMessage: e.toString());
    }
  }

  Future<void> executeConfirmCashPayment({
    required String userId,
    required String rtId,
    required String billId,
    required String billName,
    required int amountPaid,
  }) async {
    state = const ConfirmationState(isLoading: true, actionInProgress: ConfirmationAction.confirm);
    try {
      final paymentService = ref.read(paymentServiceProvider);
      await paymentService.confirmCashPayment(
          userId: userId,
          billId: billId,
          billName: billName,
          amountPaid: amountPaid,
          rtId: rtId,
      );
      ref.invalidate(citizenListProvider);
      state = const ConfirmationState(isLoading: false, actionInProgress: null);
    } catch (e) {
      state = ConfirmationState(isLoading: false, actionInProgress: null, errorMessage: e.toString());
    }
  }

  Future<void> executeRejectPayment({
    required String userId,
    required String paymentId,
    required String billId,
    required String rejectionReason,
  }) async {
    state = const ConfirmationState(isLoading: true, actionInProgress: ConfirmationAction.reject);
    try {
      final paymentService = ref.read(paymentServiceProvider);
      await paymentService.rejectPayment(
          userId: userId,
          paymentId: paymentId,
          billId: billId,
          rejectionReason: rejectionReason
      );
      ref.invalidate(citizenListProvider);
      state = const ConfirmationState(isLoading: false, actionInProgress: null);
    } catch (e) {
      state = ConfirmationState(isLoading: false, actionInProgress: null, errorMessage: e.toString());
    }
  }
}