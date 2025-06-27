import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/pages/RT/financial_report/financial_report_details_screen.dart';

class ReportItemCard extends StatelessWidget {
  final ReportData reportData;

  const ReportItemCard({super.key, required this.reportData});

  String formatReportTitle(String periodYearMonth) {
    try {
      final DateTime date = DateTime.parse('$periodYearMonth-01');
      return DateFormat('MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return periodYearMonth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthYearFormatterMY = DateFormat('MMMM yyyy');
    final Widget contentWidgets = switch (reportData) {
      MonthlyReport(
        periodYearMonth: final periodYearMonth,
        lastUpdated: final lastUpdated
      ) => InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => FinancialReportDetailsScreen(reportData: reportData))
          );
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            margin: EdgeInsets.only(top: 15.h),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(monthYearFormatterMY.format(DateTime.tryParse("$periodYearMonth-01") ?? DateTime.now()), style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 4.h),
                        Text(
                          'Terakhir diperbarui: ${DateFormat('dd-MM-yyyy').format(lastUpdated!)}',
                          style: GoogleFonts.roboto(
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade500,
                  size: 36.r,
                ),
              ],
            )
        )
      ),
      YearlyReport(
        id: final id,
        entityId: final entityId,
        annualIncome: final annualIncome,
        annualExpenses: final annualExpenses,
        netAnnualResult: final netAnnualResult,
        reportYear: final reportYear,
        averageMonthlyIncome: final averageMonthlyIncome,
        averageMonthlyExpenses: final averageMonthlyExpenses,
        lastUpdated: final lastUpdated
      ) => InkWell(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tahun $reportYear', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      )
                  ),
                  SizedBox(width: 16.w),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade500,
                    size: 36.r,
                  ),
                ],
              )
          )
      )
    };

    return contentWidgets;
  }

}