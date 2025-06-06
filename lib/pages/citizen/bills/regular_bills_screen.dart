import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/components/reusable_bills_ui.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/model/payment/payment.dart';
import 'package:wargaqu/services/payment_service.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(FirebaseFirestore.instance);
});

final paymentHistoryProvider = FutureProvider.family<List<Payment>, ({String userId, String billType})>((ref, args) {
  final service = ref.watch(paymentServiceProvider);
  return service.fetchPaymentHistory(args.userId, args.billType);
});

class RegularBillsScreen extends StatefulWidget {
  const RegularBillsScreen({super.key});

  @override
  State<RegularBillsScreen> createState() => _RegularBillsScreenState();
}

class _RegularBillsScreenState extends State<RegularBillsScreen> {
  @override
  Widget build(BuildContext context) {
    return ReusableBillsUI(
        billType: BillType.regular,
        title: 'Pembayaran Iuran Bulanan',
        billsTabTitle: 'Tagihan Iuran Bulanan',
        billsTabSubtitle: 'Berikut adalah tagihan iuran bulanan dari RT Anda yang perlu dibayarkan',
        historyTabTitle: 'Pembayaran Iuran Bulanan',
        historyTabSubtitle: 'Berikut adalah riwayat pembayaran iuran bulanan yang Anda lakukan',
    );
  }
}