import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/theme/app_colors.dart';

class CitizenProfileScreen extends ConsumerWidget {
  const CitizenProfileScreen({super.key});

  Widget profileHeaderCard(String name, String residencyStatus, String address) {
    return Card(
      margin: EdgeInsets.only(left: 15.w),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.roboto(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600
              ),
            ),
            Text(
              address,
              style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              margin: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                residencyStatus,
                style: GoogleFonts.poppins(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp, // Ukuran font dibuat pas untuk sebuah badge
                ),
              ),
            )
          ],
        )
      )
    );
  }

  Widget _buildDataRow(BuildContext context, String key, String value) {
    return Container(
      padding: EdgeInsets.only(top: 5.h, left: 15.h, right: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 17,
              )
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Profil Warga',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profileHeaderCard('Nyoman Ayu Carmenita', 'Warga Tetap', 'Blok C-12, Perumahan Griya Asri'),
          SizedBox(height: 15.h),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: ElevatedButton.icon(
              icon: Icon(Icons.chat_bubble, color: Colors.white,),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.positive,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              label: Text(
                "Chat via WhatsApp",
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15.w, top: 25.h),
            child: Text(
              'Data Pribadi',
              style: Theme.of(context).textTheme.titleLarge,
            )
          ),
          SizedBox(height: 10.h),
          _buildDataRow(context, 'NIK', '3171234567890001'),
          Divider(color: Colors.grey,),
          _buildDataRow(context, 'No. Telepon', '0812-3456-7890'),
          Divider(color: Colors.grey,),
          _buildDataRow(context, 'Pekerjaan', 'Pramugari'),
          Container(
              margin: EdgeInsets.only(left: 15.w, top: 25.h),
              child: Text(
                'Riwayat Aktivitas Terkini',
                style: Theme.of(context).textTheme.titleLarge,
              )
          ),
        ],
      ),
    );
  }


}