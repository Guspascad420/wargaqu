// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyReport _$MonthlyReportFromJson(Map<String, dynamic> json) =>
    MonthlyReport(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
      monthlyExpenses: (json['monthlyExpenses'] as num).toDouble(),
      netMonthlyResult: (json['netMonthlyResult'] as num).toDouble(),
      periodYearMonth: json['periodYearMonth'] as String,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MonthlyReportToJson(MonthlyReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'monthlyIncome': instance.monthlyIncome,
      'monthlyExpenses': instance.monthlyExpenses,
      'netMonthlyResult': instance.netMonthlyResult,
      'periodYearMonth': instance.periodYearMonth,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'runtimeType': instance.$type,
    };

YearlyReport _$YearlyReportFromJson(Map<String, dynamic> json) => YearlyReport(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      annualIncome: (json['annualIncome'] as num).toDouble(),
      annualExpenses: (json['annualExpenses'] as num).toDouble(),
      netAnnualResult: (json['netAnnualResult'] as num).toDouble(),
      reportYear: (json['reportYear'] as num).toInt(),
      averageMonthlyIncome: (json['averageMonthlyIncome'] as num?)?.toDouble(),
      averageMonthlyExpenses:
          (json['averageMonthlyExpenses'] as num?)?.toDouble(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$YearlyReportToJson(YearlyReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'annualIncome': instance.annualIncome,
      'annualExpenses': instance.annualExpenses,
      'netAnnualResult': instance.netAnnualResult,
      'reportYear': instance.reportYear,
      'averageMonthlyIncome': instance.averageMonthlyIncome,
      'averageMonthlyExpenses': instance.averageMonthlyExpenses,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'runtimeType': instance.$type,
    };
