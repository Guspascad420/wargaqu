import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';

part 'rt_data.freezed.dart';
part 'rt_data.g.dart';

@freezed
abstract class RtData with _$RtData {
  const factory RtData({
    required String id,
    required String rwId,
    required int rtNumber,
    required String rtName,
    String? secretariatAddress,
    int? population,
    int? currentBalance,
    int? currentMonthIncome,
    int? currentMonthExpenses,
    int? previousMonthClosingBalance,
    @Default([]) List<BankAccount> bankAccounts,
    @Default(true) bool isActive,
  }) = _RtData;

  factory RtData.fromJson(Map<String, dynamic> json) => _$RtDataFromJson(json);
}