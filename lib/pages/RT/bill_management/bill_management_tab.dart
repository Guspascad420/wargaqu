import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/bill_item_card.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/pages/RT/bill_details/bill_details_screen.dart';
import 'package:wargaqu/providers/providers.dart';

import '../../../providers/rt_providers.dart';

class BillManagementTab extends ConsumerWidget {
  const BillManagementTab({super.key, required this.billType});

  final BillType billType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAvailableBills = ref.watch(billsProvider(billType));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: asyncAvailableBills.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text(error.toString()),
        data: (bills) {
          if (bills.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum ada Iuran',
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 20.sp)),
                Text('Tekan tombol + di bawah untuk memulai', style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF74696D),
                ), textAlign: TextAlign.center)
              ],
            );
          }
          return ListView.separated(
            itemCount: bills.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (BuildContext context, int index) {
              return BillItemCard(billType: bills[index].billType,
                  title: bills[index].billName, dueDate: bills[index].dueDate,
                  amount: bills[index].amount, onItemTapped: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => BillDetailsScreen(bill: bills[index]))
                    );
                  });
            },
          );
        }
      ),
    );
  }

}