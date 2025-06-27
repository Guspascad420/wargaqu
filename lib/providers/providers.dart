import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/model/payment/payment.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/notifiers/bill_creation_notifier.dart';
import 'package:wargaqu/notifiers/login_notifier.dart';
import 'package:wargaqu/notifiers/registration_notifier.dart';
import 'package:wargaqu/pages/auth/citizen/citizen_login_form.dart';
import 'package:wargaqu/services/auth_service.dart';
import 'package:wargaqu/services/bill_service.dart';
import 'package:wargaqu/services/payment_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import '../notifiers/transaction_notifier.dart';
import '../pages/RT/financial_report/financial_report_screen.dart';
import '../services/report_service.dart';

final bankListProvider = Provider<List<String>>((ref) {
  return  [
    // 4 Bank Terbesar + Swasta Populer
    'Bank Central Asia (BCA)',
    'Bank Mandiri',
    'Bank Rakyat Indonesia (BRI)',
    'Bank Negara Indonesia (BNI)',

    // Bank BUMN & Syariah Besar Lainnya
    'Bank Syariah Indonesia (BSI)',
    'Bank Tabungan Negara (BTN)',

    // Bank Swasta & Digital Populer Lainnya
    'CIMB Niaga',
    'Bank Danamon',
    'Permata Bank',
    'Bank Jago',
    'Jenius (Bank BTPN)',
    'SeaBank',

    // Bank Pembangunan Daerah (BPD)
    'Bank Jatim',
    'Bank BJB (Jawa Barat & Banten)',
    'Bank DKI',
    'Bank Jateng',

    // Bank Lainnya
    'Bank Mega',
    'OCBC NISP',
    'Panin Bank',
    'UOB Indonesia',
    'Maybank Indonesia',
  ];
});

final authStateChangesProvider = StreamProvider<fb_auth.User?>((ref) {
  return fb_auth.FirebaseAuth.instance.authStateChanges();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(fb_auth.FirebaseAuth.instance);
});

final reportServiceProvider = Provider<ReportService>((ref) {
  return ReportService(FirebaseFirestore.instance);
});

final registrationNotifierProvider =
AsyncNotifierProvider<RegistrationNotifier, void>(() {
  return RegistrationNotifier();
});

final loginNotifierProvider = AsyncNotifierProvider<LoginNotifier, void>(() {
  return LoginNotifier();
});

final billCreationNotifierProvider = AsyncNotifierProvider<BillCreationNotifier, void>(() {
  return BillCreationNotifier();
});

final transactionNotifierProvider = AsyncNotifierProvider<TransactionNotifier, void>(() {
  return TransactionNotifier();
});

final filterStatusProvider = StateProvider<String>((ref) => 'Semua');
final filterBillTypeProvider = StateProvider<String>((ref) => 'Bulanan');

final billServiceProvider = Provider<BillService>((ref) {
  return BillService(FirebaseFirestore.instance);
});

final billsProvider = StreamProvider.autoDispose.family<List<Bill>, BillType>((ref, billType) {
  final service = ref.watch(billServiceProvider);
  return service.fetchActiveBills(billType);
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(FirebaseFirestore.instance, FirebaseStorage.instance);
});

final paymentHistoryProvider = FutureProvider.family<List<Payment>, ({String userId, String billType})>((ref, args) {
  final service = ref.watch(paymentServiceProvider);
  return service.fetchPaymentHistory(args.userId, args.billType);
});

final reportsProvider = StreamProvider.autoDispose.family<List<ReportData>, ({String rtId, ReportType reportType})>((ref, args) {
  final service = ref.watch(reportServiceProvider);
  return service.fetchReports(args.rtId, args.reportType);
});
