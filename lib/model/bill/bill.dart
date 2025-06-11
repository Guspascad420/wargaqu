import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
part 'bill.freezed.dart';
part 'bill.g.dart';

@freezed
abstract class Bill with _$Bill {
  const factory Bill({
    required String id,
    required String billName,
    @JsonKey(fromJson: _billTypeFromJson, toJson: _billTypeToJson)
    required BillType billType,
    required String createdBy,
    required double amount,
    required DateTime dueDate,
    required String paymentMethod,
    required String paymentStatus,
  }) = _Bill;

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
}

BillType _billTypeFromJson(String jsonValue) => BillType.fromString(jsonValue);
String _billTypeToJson(BillType billType) => billType.name;
