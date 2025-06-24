class PaymentConfirmationDetails {
  final String paymentId;
  final String residentName;
  final String address;
  final String billName;
  final double amount;
  final String proofOfPaymentImageUrl;

  const PaymentConfirmationDetails({
    required this.paymentId,
    required this.residentName,
    required this.address,
    required this.billName,
    required this.amount,
    required this.proofOfPaymentImageUrl,
  });
}