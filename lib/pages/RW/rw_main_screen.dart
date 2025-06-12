import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wargaqu/components/reusable_main_screen.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/RW/rw_data.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/pages/RW/home/rw_home_screen.dart';
import 'package:wargaqu/pages/RW/rt_financial_report/rt_financial_report_screen.dart';
import 'package:wargaqu/pages/citizen/profile/profile_screen.dart';

class RwMainScreen extends ConsumerWidget {
  const RwMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final List<RtData> daftarRtDiRwGriyaAsri = [
      const RtData(
        id: 'rt01_rw05',
        rwId: 'rw_05_griya_asri',
        rtNumber: '001',
        rtName: 'RT 001 Mawar',
        registrationUniqueCode: 'RT01MWRXYZ',
        uniqueCodeStatus: 'USED',
        secretariatAddress: 'Jl. Mawar No. 1, Griya Asri',
        citizenCount: 52,
        currentBalance: 15850000,
        previousMonthClosingBalance: 13550000,
        bankAccounts: [
          BankAccount(
            id: 'bca_rt01',
            bankName: 'BCA',
            accountNumber: '1112223330',
            accountHolderName: 'KAS RT 001 MAWAR RW 05',
          ),
        ],
        isActive: true,
      ),

      // Data untuk RT 002
      const RtData(
        id: 'rt02_rw05',
        rwId: 'rw_05_griya_asri',
        rtNumber: '002',
        rtName: 'RT 002 Melati',
        registrationUniqueCode: 'RT02MLTABC',
        uniqueCodeStatus: 'AVAILABLE',
        secretariatAddress: 'Jl. Melati No. 1, Griya Asri',
        citizenCount: 48,
        currentBalance: 12300000,
        previousMonthClosingBalance: 11800000,
        bankAccounts: [
          BankAccount(
            id: 'mandiri_rt02',
            bankName: 'Bank Mandiri',
            accountNumber: '2223334440',
            accountHolderName: 'KAS RT 002 MELATI RW 05',
          ),
        ],
        isActive: true,
      ),

      // Data untuk RT 003
      const RtData(
        id: 'rt03_rw05',
        rwId: 'rw_05_griya_asri',
        rtNumber: '003',
        rtName: 'RT 003 Anggrek',
        registrationUniqueCode: 'RT03AGKDEF',
        uniqueCodeStatus: 'AVAILABLE',
        citizenCount: 60,
        currentBalance: 20500000,
        previousMonthClosingBalance: 20500000, // Contoh jika saldo belum berubah
        // bankAccounts dibiarkan kosong, akan menggunakan default list kosong
        isActive: true,
      ),

      // Data untuk RT 004 (Contoh tidak aktif)
      const RtData(
        id: 'rt04_rw05',
        rwId: 'rw_05_griya_asri',
        rtNumber: '004',
        rtName: 'RT 004 Kamboja',
        registrationUniqueCode: 'RT04KMBGHI',
        uniqueCodeStatus: 'EXPIRED',
        citizenCount: 0,
        currentBalance: 0,
        isActive: false, // Contoh RT yang tidak aktif
      ),
    ];

    String appBarTitleLogic(int selectedIndex, BuildContext context) {
      const userName = "Mbappe";

      switch (selectedIndex) {
        case 0:
          return 'Selamat Datang, $userName!';
        case 1:
          return 'Laporan Keuangan';
        case 2:
          return '{nama rw}';
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
          RwHomeScreen(rwData: dataRwGriyaAsri, rtDataList: daftarRtDiRwGriyaAsri),
          RtFinancialReportScreen(rtDataList: daftarRtDiRwGriyaAsri),
          ProfileScreen(),
        ]
    );
  }

}