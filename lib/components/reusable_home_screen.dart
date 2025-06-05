import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/theme/app_colors.dart';

class ReusableHomeScreen extends StatelessWidget {
  final String subtitle;
  final List<Widget> servicesWidgets; // Ini daftar container layanan

  const ReusableHomeScreen({
    super.key,
    required this.subtitle,
    required this.servicesWidgets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.positive
            ),
          ),
          SizedBox(height: 25.h),
          Text('Layanan Kami', style: Theme.of(context).textTheme.titleLarge),
          Text(
            'Berikut adalah layanan yang dapat Anda akses sebagai warga dari pihak RT',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 15.h),
          ...servicesWidgets
        ],
      ),
    );
  }
}