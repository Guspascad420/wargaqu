import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/reusable_home_screen.dart';
import 'package:wargaqu/pages/RT/citizen_activity/citizen_activity_screen.dart';
import 'package:wargaqu/theme/app_colors.dart';

class RtHomeScreen extends StatefulWidget {
  const RtHomeScreen({super.key});

  @override
  State<RtHomeScreen> createState() => _RtHomeScreenState();
}

class _RtHomeScreenState extends State<RtHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ReusableHomeScreen(
          subtitle: '{Name_RT} telah memiliki {jumlah_warga_terhubung} yang terhubung dan sudah terhubung pada {Name_RW}',
          servicesWidgets: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const CitizenActivityScreen())
                  );
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF5D9BF8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Image.asset('images/group_chat.png', width: 140.w,),
                        SizedBox(height: 10.h),
                        Text('Pantau Aktivitas & Profil Warga', style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                      ],
                    )
                )
            ),
            GestureDetector(
                onTap: () {

                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF58B961),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Image.asset('images/group_chat.png', width: 140.w,),
                        SizedBox(height: 10.h),
                        Text('Pengelolaan Pembayaran Iuran Bulanan', style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                      ],
                    )
                )
            ),
            GestureDetector(
                onTap: () {

                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.secondary100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Image.asset('images/world_humanitarian_day.png', width: 140.w,),
                        SizedBox(height: 10.h),
                        Text('Pengelolaan Pembayaran Iuran Khusus', style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                      ],
                    )
                )
            ),
            const SizedBox(height: 10),
          ]
      )
    );
  }

}