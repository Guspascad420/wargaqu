import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'income.freezed.dart';
part 'income.g.dart';

DateTime? _dateTimeFromJson(Timestamp? timestamp) => timestamp?.toDate();
Timestamp? _dateTimeToJson(DateTime? date) => date == null ? null : Timestamp.fromDate(date);

@freezed
abstract class Income with _$Income {
  const factory Income({
    required String description,
    required int amount,
    String? recipientName,
    String? inputtedByUserId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? incomeDate,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdAt,
  }) = _Income;

  factory Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);
}