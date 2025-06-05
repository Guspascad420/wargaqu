import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/components/bill_item_card.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill_type.dart';

class BillsTab extends StatelessWidget {
  const BillsTab({super.key, required this.bill, required this.billType,
    required this.title, required this.subtitle});

  final Bill bill;
  final BillType billType;
  final String title;
  final String subtitle;

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
          BillItemCard(billType: billType, title: bill.billName, dueDate: bill.dueDate,
              amount: bill.amount)
        ],
      )
    );
  }
}