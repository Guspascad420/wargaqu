import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/components/reusable_main_screen.dart';
import 'package:wargaqu/pages/RT/financial_report/financial_report_screen.dart';
import 'package:wargaqu/pages/citizen/home/citizen_home_screen.dart';
import 'package:wargaqu/pages/citizen/profile/profile_screen.dart';

class CitizenMainScreen extends StatelessWidget {
  const CitizenMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String appBarTitleLogic(int selectedIndex, BuildContext context) {
      const userName = "Mbappe";

      switch (selectedIndex) {
        case 0:
          return 'Selamat Datang, $userName!';
        case 1:
          return '{nama lengkap user}';
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
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        appBarTitleBuilder: appBarTitleLogic,
        toolbarHeightBuilder: toolbarHeightLogic,
        specialAppBarColorTriggerIndex: 1,
        widgetOptions: <Widget>[
          CitizenHomeScreen(),
          ProfileScreen(),
        ]
    );
  }
}