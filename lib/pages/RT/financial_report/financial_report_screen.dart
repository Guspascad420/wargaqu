import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wargaqu/components/report_item_card.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/services/report_service.dart';
import 'package:wargaqu/theme/app_colors.dart';

import '../../../components/transaction_tab_view.dart';

final selectedReportTypeProvider = StateProvider<ReportType>((ref) {
  return ReportType.monthly;
});

class FinancialReportScreen extends ConsumerWidget {
  final String rtId;

  const FinancialReportScreen({super.key, required this.rtId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReportType currentSelectedType = ref.watch(selectedReportTypeProvider);

    final List<bool> isSelected = [
      currentSelectedType == ReportType.monthly,
      currentSelectedType == ReportType.yearly,
    ];

    final asyncReports = ref.watch(reportListProvider((rtId: rtId, reportType: currentSelectedType)));

    final double chipPaddingVertical = 8.h;
    final double chipPaddingHorizontal = 16.w;
    final double chipFontSize = 14.sp;
    final double chipBorderRadius = 10.r;

    Widget emptyReports() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Belum Ada Laporan Tersedia', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,),
          Text('Laporan keuangan akan otomatis dibuat di sini setelah ada transaksi pemasukan atau pengeluaran pertama yang tercatat',
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: FontWeight.normal,
                color: Color(0xFF74696D),
              ),
              textAlign: TextAlign.center)
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Keuangan', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: true,
      ),
      body: asyncReports.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (reports) {
          if (reports.isEmpty) {
            return emptyReports();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h),
                Text('Pilih Tipe Laporan: ', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 15.h),
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
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final report = reports[index];
                      return ReportItemCard(rtId: rtId, reportData: report);
                    }
                )
              ],
            ),
          );
        }
      )
    );
  }

}