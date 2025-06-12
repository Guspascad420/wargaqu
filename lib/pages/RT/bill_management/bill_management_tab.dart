import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/components/bill_item_card.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/pages/RT/bill_details/bill_details_screen.dart';

class BillManagementTab extends StatelessWidget {
  const BillManagementTab({super.key, required this.availableBills});

  final List<Bill> availableBills;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: ListView.separated(
        itemCount: availableBills.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BillDetailsScreen(bill: availableBills[index]))
              );
            },
            child: BillItemCard(billType: availableBills[index].billType,
                title: availableBills[index].billName, dueDate: availableBills[index].dueDate,
                amount: availableBills[index].amount),
          );
        },
      ),
    );
  }

}