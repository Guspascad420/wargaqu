import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/components/reusable_bills_ui.dart';
import 'package:wargaqu/model/bill/bill_type.dart';

class RegularBillsScreen extends ConsumerWidget {
  const RegularBillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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