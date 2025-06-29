import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/bill_item_card.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/pages/citizen/bank_account/bank_account_selection_screen.dart';
import 'package:wargaqu/providers/providers.dart';

class BillsTab extends ConsumerWidget {
  const BillsTab({super.key, required this.billType,
    required this.title, required this.subtitle});
  final BillType
  billType;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBills = ref.watch(billsProvider(billType));

    return asyncBills.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text(error.toString()),
      data: (bills) {
        if (bills.isEmpty) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline , size: 125.w),
                SizedBox(height: 10.h),
                Text('Semuanya Lunas!',
                    style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
                Text('Saat ini tidak ada tagihan baru untuk Anda.',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF74696D),
                    ),
                    textAlign: TextAlign.center)
              ]
          );
        }
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    final bill = bills[index];
                    return BillItemCard(title: bill.billName,
                        dueDate: DateTime.utc(2024, 11, 9), amount: 20000, onItemTapped: () {});
                  },
                )
              ],
            )
        );
      }
    );
  }
}