import 'package:freezed_annotation/freezed_annotation.dart';
part 'report.freezed.dart';
part 'report.g.dart';

enum ReportType { monthly, yearly }

@freezed
sealed class ReportData with _$ReportData {
  const ReportData._();

  const factory ReportData.monthly({
    required String id,
    required String entityId,
    required double monthlyIncome,
    required double monthlyExpenses,
    required double netMonthlyResult,
    required double incomingTransactionCount,
    required double outgoingTransactionCount,
    required String periodYearMonth,
    DateTime? lastUpdated,
  }) = MonthlyReport;

  const factory ReportData.yearly({
    required String id,
    required String entityId,
    required double annualIncome,
    required double annualExpenses,
    required double netAnnualResult,
    required int reportYear,
    double? averageMonthlyIncome,
    double? averageMonthlyExpenses,
    DateTime? lastUpdated,
  }) = YearlyReport;

  factory ReportData.fromJson(Map<String, dynamic> json) => _$ReportDataFromJson(json);

}