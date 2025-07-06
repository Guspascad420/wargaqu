import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/bill_item_card.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

import '../../../../components/payment_detail_dialog.dart';
import '../../../../model/payment/payment.dart';

class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key, required this.billType, required this.title,
    required this.subtitle});

  final BillType billType;

  final String title;
  final String subtitle;

  void _showPaymentDetailDialog(BuildContext context, String billName,
      int amountPaid, String paymentMethod, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 2,
          child: PaymentDetailDialogContent(billName: billName, amountPaid:
          amountPaid, paymentMethod: paymentMethod, status: status),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userIdProvider);
    final asyncPaymentHistory = ref.watch(paymentHistoryProvider((userId: userId!, billType: billType.displayName)));

    return asyncPaymentHistory.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text(error.toString()),
        data: (payments) {
          if (payments.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(Icons.credit_card_off_outlined , size: 125.w),
               SizedBox(height: 10.h),
               Text('Belum ada riwayat pembayaran yang tersimpan',
                   style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center)
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
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return BillItemCard(title: payment.billName, paymentMethod: payment.paymentMethod,
                          dueDate: DateTime.utc(2024, 11, 9), amount: 20000, status: payment.status,
                          showPaymentDetailDialog: _showPaymentDetailDialog, onItemTapped: () {});
                    },
                  )
                ],
              )
          );
        }
    );
  }
}