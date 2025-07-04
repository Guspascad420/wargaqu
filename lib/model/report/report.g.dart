// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthlyReport _$MonthlyReportFromJson(Map<String, dynamic> json) =>
    MonthlyReport(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toInt() ?? 0,
      monthlyExpenses: (json['monthlyExpenses'] as num?)?.toInt() ?? 0,
      netMonthlyResult: (json['netMonthlyResult'] as num?)?.toInt() ?? 0,
      incomingTransactionCount:
          (json['incomingTransactionCount'] as num?)?.toInt() ?? 0,
      outgoingTransactionCount:
          (json['outgoingTransactionCount'] as num?)?.toInt() ?? 0,
      periodYearMonth: json['periodYearMonth'] as String,
      lastUpdated: _timestampFromJson(json['lastUpdated'] as Timestamp),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MonthlyReportToJson(MonthlyReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'monthlyIncome': instance.monthlyIncome,
      'monthlyExpenses': instance.monthlyExpenses,
      'netMonthlyResult': instance.netMonthlyResult,
      'incomingTransactionCount': instance.incomingTransactionCount,
      'outgoingTransactionCount': instance.outgoingTransactionCount,
      'periodYearMonth': instance.periodYearMonth,
      'lastUpdated': _timestampToJson(instance.lastUpdated),
      'runtimeType': instance.$type,
    };

YearlyReport _$YearlyReportFromJson(Map<String, dynamic> json) => YearlyReport(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      annualIncome: (json['annualIncome'] as num).toDouble(),
      annualExpenses: (json['annualExpenses'] as num).toDouble(),
      netAnnualResult: (json['netAnnualResult'] as num).toDouble(),
      reportYear: (json['reportYear'] as num).toDouble(),
      averageMonthlyIncome: (json['averageMonthlyIncome'] as num?)?.toDouble(),
      averageMonthlyExpenses:
          (json['averageMonthlyExpenses'] as num?)?.toDouble(),
      lastUpdated: _timestampFromJson(json['lastUpdated'] as Timestamp),
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
      'lastUpdated': _timestampToJson(instance.lastUpdated),
      'runtimeType': instance.$type,
    };
