import 'package:flutter/material.dart';
import 'package:wargaqu/components/reusable_bills_ui.dart';
import 'package:wargaqu/model/bill_type.dart';

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