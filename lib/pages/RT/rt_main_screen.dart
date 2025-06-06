import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/components/reusable_main_screen.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/pages/RT/dashboard/dashboard_screen.dart';
import 'package:wargaqu/pages/RT/financial_report/financial_report_screen.dart';
import 'package:wargaqu/pages/RT/home/rt_home_screen.dart';
import 'package:wargaqu/pages/citizen/profile/profile_screen.dart';

class RtMainScreen extends ConsumerWidget {
  const RtMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtExample = RtData(
      id: 'rw05_kel_makmur_rt_01',
      rwId: 'rw_05_kel_makmur',
      rtNumber: '001',
      rtName: 'RT 001 Damai Sejahtera', // rtName sekarang diisi
      registrationUniqueCode: 'RT001DSXYZ', // Isi dengan contoh kode unik
      secretariatAddress: 'Jl. Damai No. 1, RW 05 Kel. Makmur',
      citizenCount: 60,
      currentBalance: 15750000, // Contoh saldo saat ini
      bankAccounts: [
        const BankAccount(
          id: 'bca_rt001_01', // Contoh ID untuk rekening bank
          bankName: 'Bank Central Asia (BCA)',
          accountNumber: '0010020030',
          accountHolderName: 'Kas RT 001 Damai Sejahtera',
          logoAsset: 'images/bca.png',
        ),
        const BankAccount(
          id: 'mandiri_rt001_01',
          bankName: 'Bank Mandiri',
          accountNumber: '900800700600',
          accountHolderName: 'Bendahara RT 001 Damai Sejahtera',
          logoAsset: 'images/mandiri.png',
        ),
      ],
      isActive: true,
    );
    
    final ReportData monthlyReport = ReportData.monthly(
        id: 'rt01_rw05_2025-06',
        entityId: 'rt01_rw05_kel_makmur',
        periodYearMonth: '2025-06',
        monthlyIncome: 5500000.0,
        monthlyExpenses: 3200000.0,
        netMonthlyResult: 2300000.0, // (5.500.000 - 3.200.000)
        incomingTransactionCount: 52,
        outgoingTransactionCount: 15,
        lastUpdated: DateTime.now()
    );

    String appBarTitleLogic(int selectedIndex, BuildContext context) {
      const userName = "Mbappe";
      switch (selectedIndex) {
        case 0:
          return 'Selamat Datang, $userName!';
        case 1:
          return 'Dashboard';
        case 2:
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
        widgetOptions: <Widget>[
          RtHomeScreen(),
          DashboardScreen(rtData: rtExample, monthlyReport: monthlyReport),
          ProfileScreen(),
        ]
    );
  }
}