import 'package:freezed_annotation/freezed_annotation.dart';
part 'payment_confirmation_details.freezed.dart';
part 'payment_confirmation_details.g.dart';

@freezed
abstract class PaymentConfirmationDetails with _$PaymentConfirmationDetails {
  const factory PaymentConfirmationDetails({
    required String paymentId,
    required String name,
    required String address,
    required String billName,
    required int amount,
    required String proofOfPaymentImageUrl,
  }) = _PaymentConfirmationDetails;

  factory PaymentConfirmationDetails.fromJson(Map<String, dynamic> json) =>
      _$PaymentConfirmationDetailsFromJson(json);
}