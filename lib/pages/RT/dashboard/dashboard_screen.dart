import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/pages/RT/dashboard/components/main_balance_card.dart';
import 'package:wargaqu/pages/RT/dashboard/components/small_info_card.dart';
import 'package:wargaqu/pages/RT/financial_report/financial_report_screen.dart';

import '../../../providers/rt_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rtData = ref.watch(rtDataProvider);
    final String currentMonthName = DateFormat.MMMM('id_ID').format(DateTime.now());

    final int currentMonthIncome = rtData?.currentMonthIncome ?? 0;
    final int currentMonthExpenses = rtData?.currentMonthExpenses ?? 0;

    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text('(Data diperbarui secara real-time)', style: Theme.of(context).textTheme.bodyMedium)
            ),
            SizedBox(height: 15.h),
            mainBalanceCard(context, rtData!),
            SizedBox(height: 15.h),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 15.w),
                    // smallInfoCard sekarang pakai data dari rtData
                    smallInfoCard(context, currentMonthIncome, 'Pemasukan Bulan Ini',
                        Colors.green.shade700, Icons.arrow_downward_rounded, '(Berjalan - $currentMonthName)'),
                    SizedBox(width: 10.w),
                    smallInfoCard(context, currentMonthExpenses, 'Pengeluaran Bulan Ini',
                        Colors.red.shade700, Icons.arrow_upward_rounded, '(Berjalan - $currentMonthName)'),
                    SizedBox(width: 15.w),
                  ],
                )
            ),
            SizedBox(height: 15.h),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              child: ElevatedButton.icon(
                icon: Icon(Icons.bar_chart_rounded, size: 24.sp),
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lihat Laporan Keuangan Lengkap',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      '(Bulanan / Tahunan)',
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FinancialReportScreen()),
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}