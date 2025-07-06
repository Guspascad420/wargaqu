import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

  return allCitizens.map((user) {
    String statusForThisBill = 'none';
    final Map<String, dynamic> billsStatus = user.billsStatus[selectedBill?.id] as Map<String, dynamic>? ?? {};

    if (selectedBill != null && billsStatus.isNotEmpty) {
      statusForThisBill = user.billsStatus[selectedBill.id]['status'];
    } else {
      statusForThisBill = 'belum_bayar';
    }

    return CitizenWithStatus(
      user: user,
      paymentStatus: statusForThisBill,
    );
  }).toList();
});

final citizenSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final filteredCitizenListProvider = Provider.family<AsyncValue<List<CitizenWithStatus>>, String>((ref, rtId) {
  final statusFilter = ref.watch(filterStatusProvider);
  final asyncFullList = ref.watch(citizenListProvider(rtId));
  final searchQuery = ref.watch(citizenSearchQueryProvider).toLowerCase();

  return asyncFullList.whenData((fullList) {
    List<CitizenWithStatus> statusFilteredList;
    if (statusFilter != 'semua') {
      statusFilteredList = fullList.where((citizen) => citizen.paymentStatus == statusFilter).toList();
    } else {
      statusFilteredList = fullList;
    }

    if (searchQuery.isEmpty) {
      return statusFilteredList;
    } else {
      return statusFilteredList.where((citizen) {
        return citizen.user.fullName.toLowerCase().contains(searchQuery);
      }).toList();
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
    citizenNote: paymentData['citizenNote']
  );
});