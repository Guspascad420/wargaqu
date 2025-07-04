import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:segmented_progress_bar/segmented_progress_bar.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/model/confirmation/confirmation_state.dart';
import 'package:wargaqu/model/payment/payment.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/notifiers/bill_notifier.dart';
import 'package:wargaqu/notifiers/registration_notifier.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';
import 'package:wargaqu/services/auth_service.dart';
import 'package:wargaqu/services/bill_service.dart';
import 'package:wargaqu/services/payment_service.dart';
import '../model/user/user.dart';
import '../notifiers/auth_notifier.dart';
import '../notifiers/payment_confirmation_notifier.dart';
import '../notifiers/payment_notifier.dart';
import '../notifiers/transaction_notifier.dart';
import '../services/report_service.dart';
import '../theme/app_colors.dart';
import 'citizen_providers.dart';

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

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance);
});

final reportServiceProvider = Provider<ReportService>((ref) {
  return ReportService(FirebaseFirestore.instance);
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final registrationNotifierProvider =
AsyncNotifierProvider<RegistrationNotifier, void>(() {
  return RegistrationNotifier();
});

final authNotifierProvider = AsyncNotifierProvider.autoDispose<AuthNotifier, UserModel?>(() {
  return AuthNotifier();
});

final billNotifierProvider = AsyncNotifierProvider<BillNotifier, void>(() {
  return BillNotifier();
});

final transactionNotifierProvider = AsyncNotifierProvider<TransactionNotifier, void>(() {
  return TransactionNotifier();
});

final paymentNotifierProvider = AsyncNotifierProvider<PaymentNotifier, void>(() {
  return PaymentNotifier();
});

final paymentConfirmationNotifierProvider = NotifierProvider<PaymentConfirmationNotifier, ConfirmationState>(() {
  return PaymentConfirmationNotifier();
});

final filterStatusProvider = StateProvider<String>((ref) => 'semua');
final filterBillTypeProvider = StateProvider<String>((ref) => 'Bulanan');

final billDetailsProvider = StreamProvider.autoDispose.family<Bill, String>((ref, billId) {
  final billService = ref.watch(billServiceProvider);
  return billService.fetchBillDetailsStream(billId);
});

final statusSegmentsProvider = Provider.family<AsyncValue<List<ProgressSegment>>,({String rtId, BuildContext context})>((ref, args) {
  final asyncCitizens = ref.watch(citizenListProvider(args.rtId));

  return asyncCitizens.whenData((citizens) {
    if (citizens.isEmpty) {
      return [];
    }

    final totalCount = citizens.length;
    final lunasCount = citizens.where((c) => c.paymentStatus == 'lunas').length;
    final belumBayarDitolakCount = citizens.where((c) => c.paymentStatus == 'belum_bayar').length
        + citizens.where((c) => c.paymentStatus == 'ditolak').length;
    final perluKonfirmasiCount = citizens.where((c) => c.paymentStatus == 'perlu_konfirmasi').length;

    final List<ProgressSegment> segments = [];

    if (lunasCount > 0) {
      segments.add(ProgressSegment(
        value: lunasCount.toDouble(),
        color: AppColors.positive,
        label: '${(lunasCount / totalCount * 100).round()}%',
        labelTextStyle: GoogleFonts.roboto(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Theme.of(args.context).colorScheme.onSurface
        )
      ));
    }
    if (perluKonfirmasiCount > 0) {
      segments.add(ProgressSegment(
        value: perluKonfirmasiCount.toDouble(),
        color: Colors.indigo,
        label: '${(perluKonfirmasiCount / totalCount * 100).round()}%',
        labelTextStyle: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(args.context).colorScheme.onSurface
        ),
        isAbove: true
      ));
    }
    if (belumBayarDitolakCount > 0) {
      segments.add(ProgressSegment(
        value: belumBayarDitolakCount.toDouble(),
        color: AppColors.negative,
        label: '${(belumBayarDitolakCount / totalCount * 100).round()}%',
        labelTextStyle: GoogleFonts.roboto(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Theme.of(args.context).colorScheme.onSurface
        ),
      ));
    }

    return segments;
  });
});

final billServiceProvider = Provider<BillService>((ref) {
  return BillService(FirebaseFirestore.instance);
});

final billsProvider = StreamProvider.autoDispose.family<List<Bill>, ({String rtId, BillType billType})>((ref, args) {
  final service = ref.read(billServiceProvider);
  return service.fetchActiveBills(args.rtId, args.billType);
});

final allBillsProvider = Provider.autoDispose.family<AsyncValue<List<Bill>>, String>((ref, rtId) {
  final regularBills = ref.watch(billsProvider((rtId: rtId, billType: BillType.regular)));
  final incidentalBills = ref.watch(billsProvider((rtId: rtId, billType: BillType.regular)));

  return switch ((regularBills, incidentalBills)) {
    (AsyncData(value: final reg), AsyncData(value: final inc)) =>
        AsyncData(
          [...reg, ...inc]..sort((a, b) => b.dueDate.compareTo(a.dueDate)),
        ),

    (AsyncError(:final error, :final stackTrace), _) || (_, AsyncError(:final error, :final stackTrace)) =>
        AsyncError(error, stackTrace),

    _ => const AsyncLoading(),
  };
});

final availableBillsProvider = Provider.family<List<Bill>, String>((ref, rtId) {
  final selectedType = ref.watch(billTypeProvider);
  final allBillsAsync = ref.watch(allBillsProvider(rtId));

  return allBillsAsync.when(
    data: (bills) => bills.where((b) => b.billType == selectedType).toList(),
    loading: () => [],
    error: (e, s) => [],
  );
});

final unpaidBillsProvider = FutureProvider.autoDispose.family<List<Bill>, ({String rtId, BillType billType})>((ref, args) async {
  final allBillsResult = await ref.watch(billsProvider((rtId: args.rtId, billType: args.billType)).future);
  final billsStatus = ref.watch(billsStatusProvider);

  final Map<String, dynamic> paidBillsStatus = billsStatus!;

  final List<Bill> unpaidBills = allBillsResult.where((bill) {
    return !paidBillsStatus.containsKey(bill.id);
  }).toList();

  return unpaidBills;
});

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(FirebaseFirestore.instance, FirebaseStorage.instance);
});

final paymentHistoryProvider = FutureProvider.family<List<Payment>, ({String userId, String billType})>((ref, args) {
  final service = ref.watch(paymentServiceProvider);
  return service.fetchPaymentHistory(args.userId, args.billType);
});

final reportListProvider = StreamProvider.autoDispose.family<List<ReportData>, ({String rtId, ReportType reportType})>((ref, args) {
  final service = ref.watch(reportServiceProvider);
  return service.fetchReports(args.rtId, args.reportType);
});