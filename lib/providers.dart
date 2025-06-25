import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/payment/payment.dart';
import 'package:wargaqu/notifiers/login_notifier.dart';
import 'package:wargaqu/notifiers/registration_notifier.dart';
import 'package:wargaqu/pages/auth/citizen/citizen_login_form.dart';
import 'package:wargaqu/services/auth_service.dart';
import 'package:wargaqu/services/bill_service.dart';
import 'package:wargaqu/services/payment_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

final authStateChangesProvider = StreamProvider<fb_auth.User?>((ref) {
  return fb_auth.FirebaseAuth.instance.authStateChanges();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(fb_auth.FirebaseAuth.instance);
});

final registrationNotifierProvider =
AsyncNotifierProvider<RegistrationNotifier, void>(() {
  return RegistrationNotifier();
});

final loginNotifierProvider = AsyncNotifierProvider<LoginNotifier, void>(() {
  return LoginNotifier();
});

final filterStatusProvider = StateProvider<String>((ref) => 'Semua');
final filterBillTypeProvider = StateProvider<String>((ref) => 'Bulanan');

final billServiceProvider = Provider<BillService>((ref) {
  return BillService(FirebaseFirestore.instance);
});

final billsProvider = FutureProvider<List<Bill>>((ref) {
  final service = ref.watch(billServiceProvider);
  return service.fetchActiveBills();
});

final bankAccountsProvider =  FutureProvider.family<List<BankAccount>, String>((ref, rtId) {
  final service = ref.watch(billServiceProvider);
  return service.fetchBankAccounts(rtId);
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(FirebaseFirestore.instance, FirebaseStorage.instance);
});

final paymentHistoryProvider = FutureProvider.family<List<Payment>, ({String userId, String billType})>((ref, args) {
  final service = ref.watch(paymentServiceProvider);
  return service.fetchPaymentHistory(args.userId, args.billType);
});