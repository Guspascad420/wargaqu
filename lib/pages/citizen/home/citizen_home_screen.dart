import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/reusable_home_screen.dart';
import 'package:wargaqu/pages/citizen/bills/incidental_bills_screen.dart';
import 'package:wargaqu/pages/citizen/bills/regular_bills_screen.dart';
import 'package:wargaqu/theme/app_colors.dart';

class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ReusableHomeScreen(
        subtitle: 'Anda sudah terhubung dengan {Name_RT}',
        servicesWidgets: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegularBillsScreen())
                );
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
                      Text('Pembayaran Iuran Bulanan', style: GoogleFonts.roboto(
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const IncidentalBillsScreen())
                );
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
                      Text('Pembayaran Iuran Khusus', style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                    ],
                  )
              )
          )
        ]
    );
  }

}