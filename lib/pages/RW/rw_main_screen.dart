import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/components/reusable_main_screen.dart';
import 'package:wargaqu/model/RW/rw_data.dart';
import 'package:wargaqu/pages/RW/home/rw_home_screen.dart';
import 'package:wargaqu/pages/RW/profile/rw_profile_screen.dart';
import 'package:wargaqu/pages/RW/rt_financial_report/rt_financial_report_screen.dart';
import 'package:wargaqu/providers/user_providers.dart';

import '../../providers/rw_providers.dart';

class RwMainScreen extends ConsumerWidget {
  const RwMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = ref.watch(currentNameProvider);
    final rwData = ref.watch(rwDataProvider);

    final dataRwGriyaAsri = RwData(
      id: 'rw05_griya_asri_sejahtera', // ID unik buat dokumen di Firestore
      rwName: 'RW 05 Griya Asri Sejahtera',
      registrationUniqueCode: 'GAS2025XYZ', // Kode unik buat registrasi pengurus RW
      uniqueCodeStatus: 'AVAILABLE', // Status kodenya
      secretariatAddress: 'Jl. Boulevard Raya No. 1, Perumahan Griya Asri',
      province: 'DKI Jakarta',
      city: 'Jakarta Barat',
      district: 'Cengkareng',
      village: 'Duri Kosambi',
      isActive: true, // Status RW aktif
    );

    String appBarTitleLogic(int selectedIndex, BuildContext context) {

      switch (selectedIndex) {
        case 0:
          return 'Selamat Datang, ${username?.split(' ')[0]}!';
        case 1:
          return 'Laporan Keuangan';
        case 2:
          return '${rwData?.rwName}';
        default:
          return 'WargaQu';
      }
    }

    double toolbarHeightLogic(int selectedIndex) {
      return selectedIndex == 0 ? 100.h : 70.h;
    }

    return ReusableMainScreen(
        bottomNavigationBarItems: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_outlined),
            label: 'Laporan Keuangan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        appBarTitleBuilder: appBarTitleLogic,
        toolbarHeightBuilder: toolbarHeightLogic,
        specialAppBarColorTriggerIndex: 2,
        specialTitleTriggerIndex: 1,
        widgetOptions: <Widget>[
          RwHomeScreen(rwData: dataRwGriyaAsri),
          RtFinancialReportScreen(),
          RwProfileScreen(),
        ]
    );
  }

}