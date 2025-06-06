import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'payment.freezed.dart';
part 'payment.g.dart';

DateTime _dateTimeFromJson(Timestamp timestamp) => timestamp.toDate();
Timestamp _dateTimeToJson(DateTime date) => Timestamp.fromDate(date);

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    @JsonKey(name: 'paymentId') required String id,
    required String billName,
    required String billType,
    required double amountPaid,
    required String billPeriod,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    required DateTime paymentTimestamp,
    required DateTime rtConfirmationTimestamp,
    required String paymentMethod,
    required String status,
    required String paymentProofUrl,
    required String rtNote
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}