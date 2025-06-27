import 'package:cloud_firestore/cloud_firestore.dart';
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
    @Default(0) int monthlyIncome,
    @Default(0) int monthlyExpenses,
    @Default(0) int netMonthlyResult,
    @Default(0) int incomingTransactionCount,
    @Default(0) int outgoingTransactionCount,
    required String periodYearMonth,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime lastUpdated,
  }) = MonthlyReport;

  const factory ReportData.yearly({
    required String id,
    required String entityId,
    required double annualIncome,
    required double annualExpenses,
    required double netAnnualResult,
    required double reportYear,
    double? averageMonthlyIncome,
    double? averageMonthlyExpenses,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime lastUpdated,
  }) = YearlyReport;

  factory ReportData.fromJson(Map<String, dynamic> json) => _$ReportDataFromJson(json);
}

DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);