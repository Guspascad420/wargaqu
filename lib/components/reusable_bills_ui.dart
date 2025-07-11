import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/components/payment_detail_dialog.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/model/payment/payment.dart';
import 'package:wargaqu/pages/citizen/bills/tabs/bills_tab.dart';
import 'package:wargaqu/pages/citizen/bills/tabs/history_tab.dart';

class ReusableBillsUI extends StatelessWidget {
  const ReusableBillsUI({super.key,
    required this.billType,
    required this.title,
    required this.billsTabTitle,
    required this.billsTabSubtitle,
    required this.historyTabTitle,
    required this.historyTabSubtitle});

  final BillType billType;
  final String title;
  final String billsTabTitle;
  final String billsTabSubtitle;
  final String historyTabTitle;
  final String historyTabSubtitle;

  @override
  Widget build(BuildContext context) {
    const double tabBarHeight = kTextTabBarHeight;
    final Bill bill = Bill(
        id: 'IKJ-2025-07-001',
        rtId: '008',
        billName: 'Iuran Juli 2025',
        billType: BillType.regular,
        amount: 20000,
        dueDate: DateTime(2025, 7, 10, 23, 59), // Tanggal 10 Juli 2025, jam 23:59
    );

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 65.h,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(tabBarHeight),
                child: Material(
                  elevation: 3,
                  shadowColor: Colors.black.withOpacity(0.4),
                  child: TabBar(
                    tabs: const [
                      Tab(text: 'Tertagih', icon: Icon(Icons.receipt_long)),
                      Tab(text: 'Riwayat', icon: Icon(Icons.history)),
                    ],
                  ),
                ),
              ),
              title: Text(title, style: Theme.of(context).textTheme.titleMedium),
              centerTitle: true
          ),
          body: TabBarView(
              children: [
                BillsTab(billType: billType, title: billsTabTitle,
                    subtitle: billsTabSubtitle),
                HistoryTab(billType: billType, title: historyTabTitle,
                    subtitle: historyTabSubtitle)
              ]
          ),
        )
    );
  }
}