import 'package:freezed_annotation/freezed_annotation.dart';
part 'bill.freezed.dart';
part 'bill.g.dart';

@freezed
abstract class Bill with _$Bill {
  const factory Bill({
    required String id,
    required String billName,
    required String billType,
    required String createdBy,
    required double amount,
    required DateTime dueDate,
    required String paymentMethod,
    required String paymentStatus,
  }) = _Bill;

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
}
