import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_data.freezed.dart';
part 'transaction_data.g.dart';

DateTime? _dateTimeFromJson(Timestamp? timestamp) => timestamp?.toDate();
Timestamp? _dateTimeToJson(DateTime? date) => date == null ? null : Timestamp.fromDate(date);

@freezed
abstract class TransactionData with _$TransactionData {
  const TransactionData._();

  const factory TransactionData.income({
    required String description,
    required int amount,
    String? recipientName,
    required String inputtedByUserId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? incomeDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdAt,
  }) = IncomeTransaction;

  const factory TransactionData.expense({
    required String description,
    required int amount,
    String? recipientName,
    required String inputtedByUserId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? expenseDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdAt,
  }) = ExpenseTransaction;

  factory TransactionData.fromJson(Map<String, dynamic> json) => _$TransactionDataFromJson(json);

  DateTime get transactionDate {
    DateTime date = DateTime.now();
    switch (this) {
      case final IncomeTransaction incomeData:
        date = incomeData.incomeDate!;
        break;
      case final ExpenseTransaction expenseData:
        date = expenseData.expenseDate!;
        break;
    }
    return date;
  }
}