import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wargaqu/theme/app_colors.dart';

final touchedIndexProvider = StateProvider<int>((ref) => -1);

class IncomeExpenseDonutChart extends ConsumerWidget {
  final int totalIncome;
  final int totalExpenses;

  const IncomeExpenseDonutChart({
    super.key,
    required this.totalIncome,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int totalValue = totalIncome + totalExpenses;
    final double incomePercentage = totalValue > 0 ? (totalIncome / totalValue) * 100 : 0;
    final double expensePercentage = totalValue > 0 ? (totalExpenses / totalValue) * 100 : 0;

    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    const Color incomeColor = AppColors.primary400;
    const Color expenseColor = AppColors.secondary100;

    final TextStyle labelTextStyle = GoogleFonts.roboto(
      fontSize: 13.sp,
      fontWeight: FontWeight.w500,
    );
    final TextStyle touchedValueStyle = GoogleFonts.roboto(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: Colors.blue.shade400, // Atau warna lain yang menonjol
    );

    final touchedIndex = ref.watch(touchedIndexProvider);

    List<PieChartSectionData> showingSections() {
      return [
        PieChartSectionData(
          color: incomeColor,
          value: totalIncome.toDouble(),
          title: '',
          radius: touchedIndex == 0 ? 60.0.r : 50.0.r, // Efek membesar saat disentuh
          titleStyle: GoogleFonts.roboto(
            fontSize: touchedIndex == 0 ? 16.sp : 13.sp, // Font membesar saat disentuh
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [const Shadow(color: Colors.black26, blurRadius: 2)],
          ),
          showTitle: true,
        ),
        PieChartSectionData(
          color: expenseColor,
          value: totalExpenses.toDouble(),
          title: '',
          radius: touchedIndex == 1 ? 60.0.r : 50.0.r,
          titleStyle: GoogleFonts.roboto(
            fontSize: touchedIndex == 1 ? 16.sp : 13.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [const Shadow(color: Colors.black26, blurRadius: 2)],
          ),
          showTitle: true,
        ),
      ];
    }

    String touchedSectionText = 'Sentuh bagian grafik untuk melihat detail';
    if (touchedIndex == 0) {
      touchedSectionText = 'Pemasukan: ${currencyFormatter.format(totalIncome)}';
    } else if (touchedIndex == 1) {
      touchedSectionText = 'Pengeluaran: ${currencyFormatter.format(totalExpenses)}';
    }

    return AspectRatio(
      aspectRatio: 0.9, // Sesuaikan rasio aspek chart
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      ref.read(touchedIndexProvider.notifier).state = -1;
                      return;
                    }
                    ref.read(touchedIndexProvider.notifier).state = pieTouchResponse.touchedSection!.touchedSectionIndex;
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 3, // Jarak antar section
                centerSpaceRadius: 60.r, // Radius lubang tengah donat
                sections: showingSections(),
                startDegreeOffset: -90, // Mulai dari atas
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Text('Selisih: ${currencyFormatter.format(totalIncome - totalExpenses)}',
              style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 5.h),
          Text(
              '*laporan hanya menghitung pembayaran terkonfirmasi saja',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.normal,
                color: Color(0xFF74696D),
              )
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _Indicator(
                color: incomeColor,
                text: 'Pemasukan (${incomePercentage.toStringAsFixed(0)}%)',
                isSquare: false,
                textStyle: labelTextStyle,
              ),
              _Indicator(
                color: expenseColor,
                text: 'Pengeluaran (${expensePercentage.toStringAsFixed(0)}%)',
                isSquare: false,
                textStyle: labelTextStyle,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              touchedSectionText,
              key: ValueKey<String>(touchedSectionText), // Key buat animasi
              style: touchedIndex == -1
                  ? labelTextStyle.copyWith(color: Colors.grey.shade600)
                  : touchedValueStyle,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final TextStyle? textStyle;

  const _Indicator({
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(width: 6.w),
        Text(text, style: textStyle ?? TextStyle(fontSize: 14.sp))
      ],
    );
  }
}