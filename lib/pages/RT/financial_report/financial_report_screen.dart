import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/report_item_card.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/theme/app_colors.dart';

final selectedReportTypeProvider = StateProvider<ReportType>((ref) {
  return ReportType.monthly;
});

class FinancialReportScreen extends ConsumerWidget {
  const FinancialReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReportType currentSelectedType = ref.watch(selectedReportTypeProvider);
    final List<bool> isSelected = [
      currentSelectedType == ReportType.monthly,
      currentSelectedType == ReportType.yearly,
    ];

    final double chipPaddingVertical = 8.h;
    final double chipPaddingHorizontal = 16.w;
    final double chipFontSize = 14.sp;
    final double chipBorderRadius = 10.r;

    final List<ReportData> monthlyReports = [
      ReportData.monthly(
        id: 'rt01_rw05_2025-04',
        entityId: 'rt01_rw05',
        monthlyIncome: 5200000.0,
        monthlyExpenses: 3100000.0,
        netMonthlyResult: 2100000.0,
        periodYearMonth: '2025-04',
        lastUpdated: DateTime(2025, 4, 30),
        incomingTransactionCount:  30,
        outgoingTransactionCount: 10,
      ),
      ReportData.monthly(
        id: 'rt01_rw05_2025-05',
        entityId: 'rt01_rw05',
        monthlyIncome: 5350000.0,
        monthlyExpenses: 3300000.0,
        netMonthlyResult: 2050000.0,
        periodYearMonth: '2025-05',
        lastUpdated: DateTime(2025, 6, 4),
        incomingTransactionCount:  30,
        outgoingTransactionCount: 10,
      ),
      ReportData.monthly(
        id: 'rt01_rw05_2025-06',
        entityId: 'rt01_rw05',
        monthlyIncome: 5500000.0,
        monthlyExpenses: 3200000.0,
        netMonthlyResult: 2300000.0,
        periodYearMonth: '2025-06',
        lastUpdated: DateTime.now(),
        incomingTransactionCount:  30,
        outgoingTransactionCount: 10,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Keuangan', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: true,
      ),
      body: Container(
          margin: EdgeInsets.all(15.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pilih Tipe Laporan: ', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 15.h,),
                ToggleButtons(
                  isSelected: isSelected,
                  onPressed: (int index) {
                    final newSelectedType = index == 0 ? ReportType.monthly : ReportType.yearly;
                    ref.read(selectedReportTypeProvider.notifier).state = newSelectedType;
                  },
                  borderRadius: BorderRadius.circular(chipBorderRadius),
                  selectedColor: Colors.white,
                  color: AppColors.primary400,
                  fillColor: AppColors.primary400,
                  splashColor: AppColors.primary400.withOpacity(0.12),
                  highlightColor: AppColors.primary400.withOpacity(0.1),
                  borderColor: AppColors.primary400,
                  selectedBorderColor: AppColors.primary400,
                  borderWidth: 1.5,
                  constraints: BoxConstraints(
                    minHeight: 36.h,
                    minWidth: 100.w,
                  ),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: chipPaddingHorizontal, vertical: chipPaddingVertical),
                      child: Text(
                        'Bulanan',
                        style: GoogleFonts.roboto(fontSize: chipFontSize, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: chipPaddingHorizontal, vertical: chipPaddingVertical),
                      child: Text(
                        'Tahunan',
                        style: GoogleFonts.roboto(fontSize: chipFontSize, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    if (currentSelectedType == ReportType.monthly)...[
                      for (var report in monthlyReports)
                        ReportItemCard(reportData: report)
                    ]
                    else...[

                    ]
                  ],
                )
              ],
            ),
          )
      ),
    );
  }

}