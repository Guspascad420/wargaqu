import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/model/payment/payment_confirmation_details/payment_confirmation_details.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

import '../model/citizen/citizen_with_status.dart';
import '../model/user/user.dart';

final citizenListProvider = FutureProvider.autoDispose.family<List<CitizenWithStatus>, String>((ref, rtId) async {
  final selectedBill = ref.watch(selectedBillProvider);
  final rtService = ref.watch(rtServiceProvider);
  final List<UserModel> allCitizens = await rtService.fetchAllCitizens(rtId);

  debugPrint("All citizens: ${allCitizens.length}");

  return allCitizens.map((user) {
    String statusForThisBill = 'none';

    if (selectedBill != null) {
      statusForThisBill = user.billsStatus[selectedBill.id] ?? 'belum_bayar';
    }

    return CitizenWithStatus(
      user: user,
      paymentStatus: statusForThisBill,
    );
  }).toList();
});

final filteredCitizenListProvider = Provider.family<AsyncValue<List<CitizenWithStatus>>, String>((ref, rtId) {
  final filter = ref.watch(filterStatusProvider);
  final asyncFullList = ref.watch(citizenListProvider(rtId));

  return asyncFullList.whenData((fullList) {
    switch (filter) {
      case 'lunas':
        return fullList.where((citizen) => citizen.paymentStatus == 'lunas').toList();
      case 'belum_bayar':
        return fullList.where((citizen) => citizen.paymentStatus == 'belum_bayar').toList();
      case 'perlu_konfirmasi':
        return fullList.where((citizen) => citizen.paymentStatus == 'perlu_konfirmasi').toList();
      case 'semua':
      default:
        return fullList;
    }
  });
});

final paymentDetailsProvider = FutureProvider.autoDispose.family<PaymentConfirmationDetails,
    ({UserModel user, String paymentId})>((ref, args)  async {
  final service = ref.watch(userServiceProvider);

  final paymentDoc = await service.fetchPaymentDoc(args.user.id, args.paymentId);

  if (!paymentDoc.exists) {
    throw Exception('Data pembayaran tidak ditemukan!');
  }

  final paymentData = paymentDoc.data() as Map<String, dynamic>;
  return PaymentConfirmationDetails(
    paymentId: paymentDoc.id,
    name: args.user.fullName,
    address: args.user.address,
    billName: paymentData['billName'] ?? 'Iuran',
    amount: paymentData['amountPaid'] ?? 0,
    proofOfPaymentImageUrl: paymentData['paymentProofUrl'] ?? '',
  );
});