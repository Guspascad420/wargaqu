import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/theme/app_colors.dart';

class BillDetailsScreen extends StatelessWidget {
  const BillDetailsScreen({super.key, required this.bill});

  final Bill bill;

  Widget _buildPropertyItem(BuildContext context, String label, String sublabel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium
          ),
          Text(
            sublabel,
            style: GoogleFonts.roboto(fontSize: 14.sp)
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Iuran',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPropertyItem(context, 'Judul Iuran', bill.billName),
          _buildPropertyItem(context, 'Tipe Iuran', bill.billType.displayName),
          _buildPropertyItem(context, 'Jatuh Tempo', bill.dueDate.toString()),
          _buildPropertyItem(context, 'Nominal', bill.amount.toString()),
          const Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                side: BorderSide(color: AppColors.primary90, width: 1.5.w), // Lebar border dengan .w
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Edit Iuran',
                textAlign: TextAlign.center, // Menambahkan text align center
                style: GoogleFonts.roboto(
                  fontSize: 15.sp, // Ukuran font disesuaikan
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary90,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton.icon(
              label: Text(
                'Hapus Iuran',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.negative,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.w),
                ),
                elevation: 2,
              ),
              onPressed: () {

              },
            ),
          ),
          SizedBox(height: 20)
        ],
      )
    );
  }

}