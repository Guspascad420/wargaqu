import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../bill/bill_type.dart';
part 'payment.freezed.dart';
part 'payment.g.dart';

DateTime _dateTimeFromJson(Timestamp timestamp) => timestamp.toDate();
Timestamp _dateTimeToJson(DateTime date) => Timestamp.fromDate(date);

DateTime? _rtTimestampFromJson(Timestamp? timestamp) => timestamp?.toDate();
Timestamp? _rtTimestampToJson(DateTime? date) => date == null ? null : Timestamp.fromDate(date);

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    String? id,
    required String billName,
    @JsonKey(fromJson: _billTypeFromJson, toJson: _billTypeToJson)
    required BillType billType,
    required int amountPaid,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime paymentTimestamp,
    @JsonKey(fromJson: _rtTimestampFromJson, toJson: _rtTimestampToJson)
    DateTime? rtConfirmationTimestamp,
    required String paymentMethod,
    required String status,
    required String paymentProofUrl,
    String? rtNote,
    String? citizenNote
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}

BillType _billTypeFromJson(String jsonValue) => BillType.fromString(jsonValue);
String _billTypeToJson(BillType billType) => billType.name;