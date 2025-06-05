import 'package:flutter/material.dart';
import 'package:wargaqu/components/reusable_bills_ui.dart';
import 'package:wargaqu/model/bill_type.dart';

class IncidentalBillsScreen extends StatefulWidget {
  const IncidentalBillsScreen({super.key});

  @override
  State<IncidentalBillsScreen> createState() => _IncidentalBillsScreenState();
}

class _IncidentalBillsScreenState extends State<IncidentalBillsScreen> {
  @override
  Widget build(BuildContext context) {
    return ReusableBillsUI(
      billType: BillType.incidental,
      title: 'Pembayaran Iuran Khusus',
      billsTabTitle: 'Tagihan Iuran Khusus',
      billsTabSubtitle: 'Berikut adalah tagihan iuran khusus dari RT Anda yang perlu dibayarkan',
      historyTabTitle: 'Pembayaran Iuran Khusus',
      historyTabSubtitle: 'Berikut adalah riwayat pembayaran iuran khusus yang Anda lakukan',
    );
  }
}