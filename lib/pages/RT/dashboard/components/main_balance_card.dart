import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/theme/app_colors.dart';

Widget mainBalanceCard(BuildContext context, RtData rtData) {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  int currentBalance = rtData.currentBalance ?? 0;
  int previousBalance = rtData.previousMonthClosingBalance ?? 0;
  final bool isBalanceIncreased = currentBalance - previousBalance >= 0;

  return Card(
    elevation: 4.0,
    margin: EdgeInsets.symmetric(horizontal: 15.w),
    shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primary400, width: 1),
        borderRadius: BorderRadius.circular(12.r)
    ),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo Kas Saat Ini',
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            currencyFormatter.format(rtData.currentBalance),
            style: GoogleFonts.roboto(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          rtData.previousMonthClosingBalance == null
              ? SizedBox.shrink()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: isBalanceIncreased ? Colors.green.shade100 : Colors.red.shade100
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  child: Row(
                    children: [
                      Icon(
                        isBalanceIncreased ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: isBalanceIncreased ? Colors.green.shade700 : Colors.red.shade700,
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${currencyFormatter.format((currentBalance - previousBalance).abs())} dari bulan lalu',
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          color: isBalanceIncreased ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                    ],
                  )
          )
        ],
      ),
    ),
  );
}