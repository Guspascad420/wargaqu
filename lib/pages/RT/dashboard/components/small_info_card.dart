import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

Widget smallInfoCard(BuildContext context, double amount,
    String title, Color amountColor, IconData icon, String periodInfo) {
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  return Card(
    elevation: 2.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
    child: Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: amountColor, size: 18.sp),
              SizedBox(width: 6.w),
              Text(
                title,
                style: GoogleFonts.roboto(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600
                ),
              ),
            ],
          ),
          Text(
            periodInfo,
            style: GoogleFonts.roboto(fontSize: 11.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 8.h),
          Text(
            currencyFormatter.format(amount),
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    ),
  );
}