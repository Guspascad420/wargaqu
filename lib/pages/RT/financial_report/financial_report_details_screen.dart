import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/components/income_expense_chart.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/theme/app_colors.dart';

class FinancialReportDetailsScreen extends StatelessWidget {
  const FinancialReportDetailsScreen({super.key, required this.reportData});

  final ReportData reportData;

  @override
  Widget build(BuildContext context) {
    final Widget widget = switch (reportData) {

      MonthlyReport(
        id: final id,
        entityId: final entityId,
        monthlyIncome: final monthlyIncome,
        monthlyExpenses: final monthlyExpenses,
        netMonthlyResult: final netMonthlyResult,
        periodYearMonth: final periodYearMonth,
        lastUpdated: final lastUpdated
      ) => Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Laporan ${DateFormat('MMMM yyyy').format(DateTime.tryParse("$periodYearMonth-01") ?? DateTime.now())}'
                  , style: Theme.of(context).textTheme.titleMedium),
              ),
            body: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h,),
                  IncomeExpenseDonutChart(
                    totalIncome: monthlyIncome,
                    totalExpenses: monthlyExpenses,
                  ),
                  SizedBox(height: 10.h),
                  Text('Detail Laporan', style: Theme.of(context).textTheme.titleLarge),
                  Text('Berikut adalah detail laporan keuangan', style: Theme.of(context).textTheme.bodyLarge, maxLines: 2,),
                ],
              ),
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
      ) => throw UnimplementedError(),
    };

    return widget;
  }

}