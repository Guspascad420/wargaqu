import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/reusable_home_screen.dart';
import 'package:wargaqu/pages/RT/bill_management/bill_management_screen.dart';
import 'package:wargaqu/pages/RT/citizen_activity/citizen_activity_screen.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/theme/app_colors.dart';

class RtHomeScreen extends ConsumerStatefulWidget {
  const RtHomeScreen({super.key});

  @override
  ConsumerState<RtHomeScreen> createState() => _RtHomeScreenState();
}

class _RtHomeScreenState extends ConsumerState<RtHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final asyncRtSummary = ref.watch(rtSummaryProvider);

    return SingleChildScrollView(
      child: ReusableHomeScreen(
          subtitle: asyncRtSummary.when(
            loading: () => 'Memuat data RW...',
            error: (err, stack) => 'Gagal memuat data',
            data: (summary) {
              return summary;
            },
          ),
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const BillManagementScreen())
                  );
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.secondary100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Image.asset('images/group_chat.png', width: 140.w),
                        SizedBox(height: 10.h),
                        Text('Pengelolaan Pembayaran Iuran', style: GoogleFonts.roboto(
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
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => const BillManagementScreen())
                  // );
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.positive,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Image.asset('images/confirmed_bro.png', width: 140.w),
                        SizedBox(height: 10.h),
                        Text('Verifikasi Warga', style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                      ],
                    )
                )
            )
          ]
      )
    );
  }

}