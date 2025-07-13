import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/components/income_expense_chart.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/model/transaction/transaction_data.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/theme/app_colors.dart';

import '../../../components/transaction_tab_view.dart';

class FinancialReportDetailsScreen extends ConsumerWidget {
  const FinancialReportDetailsScreen({super.key, required this.reportData, required this.rtId});

  final String rtId;
  final ReportData reportData;

  Widget _transactionItemCard(BuildContext context, String title, int amount,
      TransactionType type, NumberFormat formatter) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        margin: EdgeInsets.only(bottom: 10.h),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Container(
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: type == TransactionType.income ? AppColors.primary400 : AppColors.secondary100,
                  shape: BoxShape.circle,
                )
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 3.h),
                  Text(formatter.format(amount), style: GoogleFonts.roboto(fontSize: 15.sp))
                ],
              ),
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTransactions = ref.watch(transactionsProvider(rtId));
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
              title: Text('Laporan ${DateFormat('MMMM yyyy', 'id_ID').format(DateTime.tryParse("$periodYearMonth-01") ?? DateTime.now())}'
                  , style: Theme.of(context).textTheme.titleMedium),
              ),
            body: SingleChildScrollView(
              child: Padding(
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
                    Text('Berikut adalah detail laporan keuangan',
                      style: Theme.of(context).textTheme.bodyLarge, maxLines: 2,),
                    SizedBox(height: 10.h),
                    asyncTransactions.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) {
                          print(err);
                          print(stack);
                          return Center(child: Text('Error: $err'));
                        },
                        data: (transactions) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];
                                return switch(transaction) {
                                  IncomeTransaction() => _transactionItemCard(context, transaction.description,
                                      transaction.amount, TransactionType.income, currencyFormatter),
                                  ExpenseTransaction() => _transactionItemCard(context, transaction.description,
                                      transaction.amount, TransactionType.expense,currencyFormatter),
                                  TransactionData() => throw UnimplementedError(),
                                };
                              }
                          );
                        }
                    )

                  ],
                ),
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