import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
part 'bill.freezed.dart';
part 'bill.g.dart';

@freezed
abstract class Bill with _$Bill {
  const factory Bill({
    required String id,
    required String rtId,
    required String billName,
    @JsonKey(fromJson: _billTypeFromJson, toJson: _billTypeToJson)
    required BillType billType,
    required double amount,
    @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
    required DateTime dueDate,
  }) = _Bill;

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
}

BillType _billTypeFromJson(String jsonValue) => BillType.fromString(jsonValue);
String _billTypeToJson(BillType billType) => billType.name;

DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);
