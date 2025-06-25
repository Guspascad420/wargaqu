import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'expense.freezed.dart';
part 'expense.g.dart';

DateTime? _dateTimeFromJson(Timestamp? timestamp) => timestamp?.toDate();
Timestamp? _dateTimeToJson(DateTime? date) => date == null ? null : Timestamp.fromDate(date);

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required String description,
    required double amount,
    String? recipientName,
    String? notes,
    required String inputtedByUserId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? expenseDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}