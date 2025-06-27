import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/components/reusable_main_screen.dart';
import 'package:wargaqu/pages/RT/dashboard/dashboard_screen.dart';
import 'package:wargaqu/pages/RT/home/rt_home_screen.dart';
import 'package:wargaqu/pages/citizen/profile/profile_screen.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

class RtMainScreen extends ConsumerWidget {
  const RtMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtData = ref.watch(rtDataProvider);
    final currentName = ref.watch(currentNameProvider);

    String? appBarTitleLogic(int selectedIndex, BuildContext context) {
      switch (selectedIndex) {
        case 0:
          return 'Selamat Datang, ${currentName?.split(' ')[0]}!';
        case 1:
          return 'Dashboard';
        case 2:
          return rtData?.rtName;
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
            label: 'Dashboard',
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
        fabTriggerIndex: 1,
        widgetOptions: <Widget>[
          RtHomeScreen(),
          DashboardScreen(),
          ProfileScreen(),
        ]
    );
  }
}