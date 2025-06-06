// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ReportData _$ReportDataFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'monthly':
      return MonthlyReport.fromJson(json);
    case 'yearly':
      return YearlyReport.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'ReportData',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$ReportData {
  String get id;
  String get entityId;
  DateTime? get lastUpdated;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportDataCopyWith<ReportData> get copyWith =>
      _$ReportDataCopyWithImpl<ReportData>(this as ReportData, _$identity);

  /// Serializes this ReportData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportData &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, entityId, lastUpdated);

  @override
  String toString() {
    return 'ReportData(id: $id, entityId: $entityId, lastUpdated: $lastUpdated)';
  }
}

/// @nodoc
abstract mixin class $ReportDataCopyWith<$Res> {
  factory $ReportDataCopyWith(
          ReportData value, $Res Function(ReportData) _then) =
      _$ReportDataCopyWithImpl;
  @useResult
  $Res call({String id, String entityId, DateTime? lastUpdated});
}

/// @nodoc
class _$ReportDataCopyWithImpl<$Res> implements $ReportDataCopyWith<$Res> {
  _$ReportDataCopyWithImpl(this._self, this._then);

  final ReportData _self;
  final $Res Function(ReportData) _then;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityId = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: freezed == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class MonthlyReport extends ReportData {
  const MonthlyReport(
      {required this.id,
      required this.entityId,
      required this.monthlyIncome,
      required this.monthlyExpenses,
      required this.netMonthlyResult,
      required this.incomingTransactionCount,
      required this.outgoingTransactionCount,
      required this.periodYearMonth,
      this.lastUpdated,
      final String? $type})
      : $type = $type ?? 'monthly',
        super._();
  factory MonthlyReport.fromJson(Map<String, dynamic> json) =>
      _$MonthlyReportFromJson(json);

  @override
  final String id;
  @override
  final String entityId;
  final double monthlyIncome;
  final double monthlyExpenses;
  final double netMonthlyResult;
  final double incomingTransactionCount;
  final double outgoingTransactionCount;
  final String periodYearMonth;
  @override
  final DateTime? lastUpdated;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MonthlyReportCopyWith<MonthlyReport> get copyWith =>
      _$MonthlyReportCopyWithImpl<MonthlyReport>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MonthlyReportToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MonthlyReport &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.monthlyIncome, monthlyIncome) ||
                other.monthlyIncome == monthlyIncome) &&
            (identical(other.monthlyExpenses, monthlyExpenses) ||
                other.monthlyExpenses == monthlyExpenses) &&
            (identical(other.netMonthlyResult, netMonthlyResult) ||
                other.netMonthlyResult == netMonthlyResult) &&
            (identical(
                    other.incomingTransactionCount, incomingTransactionCount) ||
                other.incomingTransactionCount == incomingTransactionCount) &&
            (identical(
                    other.outgoingTransactionCount, outgoingTransactionCount) ||
                other.outgoingTransactionCount == outgoingTransactionCount) &&
            (identical(other.periodYearMonth, periodYearMonth) ||
                other.periodYearMonth == periodYearMonth) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityId,
      monthlyIncome,
      monthlyExpenses,
      netMonthlyResult,
      incomingTransactionCount,
      outgoingTransactionCount,
      periodYearMonth,
      lastUpdated);

  @override
  String toString() {
    return 'ReportData.monthly(id: $id, entityId: $entityId, monthlyIncome: $monthlyIncome, monthlyExpenses: $monthlyExpenses, netMonthlyResult: $netMonthlyResult, incomingTransactionCount: $incomingTransactionCount, outgoingTransactionCount: $outgoingTransactionCount, periodYearMonth: $periodYearMonth, lastUpdated: $lastUpdated)';
  }
}

/// @nodoc
abstract mixin class $MonthlyReportCopyWith<$Res>
    implements $ReportDataCopyWith<$Res> {
  factory $MonthlyReportCopyWith(
          MonthlyReport value, $Res Function(MonthlyReport) _then) =
      _$MonthlyReportCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String entityId,
      double monthlyIncome,
      double monthlyExpenses,
      double netMonthlyResult,
      double incomingTransactionCount,
      double outgoingTransactionCount,
      String periodYearMonth,
      DateTime? lastUpdated});
}

/// @nodoc
class _$MonthlyReportCopyWithImpl<$Res>
    implements $MonthlyReportCopyWith<$Res> {
  _$MonthlyReportCopyWithImpl(this._self, this._then);

  final MonthlyReport _self;
  final $Res Function(MonthlyReport) _then;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? entityId = null,
    Object? monthlyIncome = null,
    Object? monthlyExpenses = null,
    Object? netMonthlyResult = null,
    Object? incomingTransactionCount = null,
    Object? outgoingTransactionCount = null,
    Object? periodYearMonth = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(MonthlyReport(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      monthlyIncome: null == monthlyIncome
          ? _self.monthlyIncome
          : monthlyIncome // ignore: cast_nullable_to_non_nullable
              as double,
      monthlyExpenses: null == monthlyExpenses
          ? _self.monthlyExpenses
          : monthlyExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      netMonthlyResult: null == netMonthlyResult
          ? _self.netMonthlyResult
          : netMonthlyResult // ignore: cast_nullable_to_non_nullable
              as double,
      incomingTransactionCount: null == incomingTransactionCount
          ? _self.incomingTransactionCount
          : incomingTransactionCount // ignore: cast_nullable_to_non_nullable
              as double,
      outgoingTransactionCount: null == outgoingTransactionCount
          ? _self.outgoingTransactionCount
          : outgoingTransactionCount // ignore: cast_nullable_to_non_nullable
              as double,
      periodYearMonth: null == periodYearMonth
          ? _self.periodYearMonth
          : periodYearMonth // ignore: cast_nullable_to_non_nullable
              as String,
      lastUpdated: freezed == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class YearlyReport extends ReportData {
  const YearlyReport(
      {required this.id,
      required this.entityId,
      required this.annualIncome,
      required this.annualExpenses,
      required this.netAnnualResult,
      required this.reportYear,
      this.averageMonthlyIncome,
      this.averageMonthlyExpenses,
      this.lastUpdated,
      final String? $type})
      : $type = $type ?? 'yearly',
        super._();
  factory YearlyReport.fromJson(Map<String, dynamic> json) =>
      _$YearlyReportFromJson(json);

  @override
  final String id;
  @override
  final String entityId;
  final double annualIncome;
  final double annualExpenses;
  final double netAnnualResult;
  final int reportYear;
  final double? averageMonthlyIncome;
  final double? averageMonthlyExpenses;
  @override
  final DateTime? lastUpdated;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $YearlyReportCopyWith<YearlyReport> get copyWith =>
      _$YearlyReportCopyWithImpl<YearlyReport>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$YearlyReportToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is YearlyReport &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.annualIncome, annualIncome) ||
                other.annualIncome == annualIncome) &&
            (identical(other.annualExpenses, annualExpenses) ||
                other.annualExpenses == annualExpenses) &&
            (identical(other.netAnnualResult, netAnnualResult) ||
                other.netAnnualResult == netAnnualResult) &&
            (identical(other.reportYear, reportYear) ||
                other.reportYear == reportYear) &&
            (identical(other.averageMonthlyIncome, averageMonthlyIncome) ||
                other.averageMonthlyIncome == averageMonthlyIncome) &&
            (identical(other.averageMonthlyExpenses, averageMonthlyExpenses) ||
                other.averageMonthlyExpenses == averageMonthlyExpenses) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityId,
      annualIncome,
      annualExpenses,
      netAnnualResult,
      reportYear,
      averageMonthlyIncome,
      averageMonthlyExpenses,
      lastUpdated);

  @override
  String toString() {
    return 'ReportData.yearly(id: $id, entityId: $entityId, annualIncome: $annualIncome, annualExpenses: $annualExpenses, netAnnualResult: $netAnnualResult, reportYear: $reportYear, averageMonthlyIncome: $averageMonthlyIncome, averageMonthlyExpenses: $averageMonthlyExpenses, lastUpdated: $lastUpdated)';
  }
}

/// @nodoc
abstract mixin class $YearlyReportCopyWith<$Res>
    implements $ReportDataCopyWith<$Res> {
  factory $YearlyReportCopyWith(
          YearlyReport value, $Res Function(YearlyReport) _then) =
      _$YearlyReportCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String entityId,
      double annualIncome,
      double annualExpenses,
      double netAnnualResult,
      int reportYear,
      double? averageMonthlyIncome,
      double? averageMonthlyExpenses,
      DateTime? lastUpdated});
}

/// @nodoc
class _$YearlyReportCopyWithImpl<$Res> implements $YearlyReportCopyWith<$Res> {
  _$YearlyReportCopyWithImpl(this._self, this._then);

  final YearlyReport _self;
  final $Res Function(YearlyReport) _then;

  /// Create a copy of ReportData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? entityId = null,
    Object? annualIncome = null,
    Object? annualExpenses = null,
    Object? netAnnualResult = null,
    Object? reportYear = null,
    Object? averageMonthlyIncome = freezed,
    Object? averageMonthlyExpenses = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(YearlyReport(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _self.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      annualIncome: null == annualIncome
          ? _self.annualIncome
          : annualIncome // ignore: cast_nullable_to_non_nullable
              as double,
      annualExpenses: null == annualExpenses
          ? _self.annualExpenses
          : annualExpenses // ignore: cast_nullable_to_non_nullable
              as double,
      netAnnualResult: null == netAnnualResult
          ? _self.netAnnualResult
          : netAnnualResult // ignore: cast_nullable_to_non_nullable
              as double,
      reportYear: null == reportYear
          ? _self.reportYear
          : reportYear // ignore: cast_nullable_to_non_nullable
              as int,
      averageMonthlyIncome: freezed == averageMonthlyIncome
          ? _self.averageMonthlyIncome
          : averageMonthlyIncome // ignore: cast_nullable_to_non_nullable
              as double?,
      averageMonthlyExpenses: freezed == averageMonthlyExpenses
          ? _self.averageMonthlyExpenses
          : averageMonthlyExpenses // ignore: cast_nullable_to_non_nullable
              as double?,
      lastUpdated: freezed == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
