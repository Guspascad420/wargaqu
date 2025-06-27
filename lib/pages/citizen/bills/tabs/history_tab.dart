import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/components/bill_item_card.dart';
import 'package:wargaqu/model/bill/bill.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key, required this.bill, required this.title,
    required this.subtitle, required this.showPaymentDetailDialog});

  final Bill bill;
  final String title;
  final String subtitle;
  final void Function(BuildContext) showPaymentDetailDialog;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            Text(subtitle,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 15.sp),
            BillItemCard(title: 'Iuran Februari 2024',
              dueDate: DateTime.utc(2024, 11, 9), amount: 20000, status: 'Belum bayar',
                showPaymentDetailDialog: showPaymentDetailDialog, onItemTapped: () {})
          ],
        )
    );
  }
}