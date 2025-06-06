import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/pages/RT/dashboard/components/main_balance_card.dart';
import 'package:wargaqu/pages/RT/dashboard/components/small_info_card.dart';
import 'package:wargaqu/pages/RT/financial_report/financial_report_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key, required this.rtData, required this.monthlyReport});

  final RtData rtData;
  final ReportData monthlyReport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double currentMonthIncome = 0;
    double currentMonthExpenses = 0;

    switch (monthlyReport) {
      case MonthlyReport(
        monthlyIncome: final income,
        monthlyExpenses: final expenses
      ):
        currentMonthIncome = income;
        currentMonthExpenses = expenses;
        break;
      case YearlyReport():
        currentMonthIncome = 0;
        currentMonthExpenses = 0;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text('(Update Terakhir: 5 Juni 2025, 14:30 WIB)', style: Theme.of(context).textTheme.bodyLarge)
        ),
        SizedBox(height: 15.h),
        mainBalanceCard(context, rtData, monthlyReport),
        SizedBox(height: 15.h),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 15.w),
                smallInfoCard(context, currentMonthIncome, 'Pemasukan Bulan Ini',
                    Colors.green.shade700, Icons.arrow_upward_rounded, '(Berjalan - Juni)'),
                SizedBox(width: 10.w),
                smallInfoCard(context, currentMonthExpenses, 'Pengeluaran Bulan Ini',
                    Colors.red.shade700, Icons.arrow_downward_rounded, '(Berjalan - Juni)'),
                SizedBox(width: 15.w),
              ],
            )
        ),
        SizedBox(height: 15.h),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          child: ElevatedButton(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart_rounded, size: 24.sp),
                SizedBox(width: 10.w),
                Flexible(
                  child: Column(
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
                        textAlign: TextAlign.center, // Bisa disesuaikan
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}