import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/RT/rt_officials.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/citizen/citizen_with_status.dart';
import 'package:wargaqu/model/generate_code/generate_code_state.dart';
import 'package:wargaqu/model/transaction/transaction_data.dart';
import 'package:wargaqu/model/unique_code/unique_code.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/notifiers/add_new_bank_account_notifier.dart';
import 'package:wargaqu/notifiers/citizen_verification_notifier.dart';
import 'package:wargaqu/notifiers/delete_code_notifier.dart';
import 'package:wargaqu/notifiers/generate_code_notifier.dart';
import 'package:wargaqu/notifiers/rt_creation_notifier.dart';
import 'package:wargaqu/providers/rw_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';
import 'package:wargaqu/services/rt_service.dart';
import 'package:wargaqu/services/rw_service.dart';

import '../model/bill/bill.dart';
import '../model/bill/bill_type.dart';

final rwServiceProvider = Provider((ref) => RwService(FirebaseFirestore.instance));

final billTypeProvider = StateProvider<BillType>((ref) => BillType.regular);
final mockAvailableBillsProvider = Provider<List<Bill>>((ref) {
  return [
    Bill(id: '1', billName: 'Iuran Januari 2025', billType: BillType.regular, rtId: '008',
        amount: 50, dueDate: DateTime.now().add(const Duration(days: 10))),
    Bill(id: '2', billName: 'Iuran Februari 2025', billType: BillType.regular, rtId: '008',
        amount: 75, dueDate: DateTime.now().add(const Duration(days: 5))),
    Bill(id: '3', billName: 'Iuran perbaikan portal', billType: BillType.incidental, rtId: '008',
        amount: 30, dueDate: DateTime.now().add(const Duration(days: 15))),
  ];
});
final selectedBillProvider = StateProvider<Bill?>((ref) => null);

final mockBankAccountsProvider = Provider<List<BankAccount>>((ref) {
  return [
    BankAccount(
        id: 'bca1',
        bankName: 'BCA',
        accountNumber: '**** **** **** 1234',
        accountHolder: 'Pengurus RT 05 RW 02',
        logoAsset: 'images/bca.png'
    ),
    BankAccount(
        id: 'bri1',
        bankName: 'BRI',
        accountNumber: '**** **** **** 9012',
        accountHolder: 'Bendahara RT 05',
        logoAsset: 'images/bri.png'
    ),
  ];
});

final selectedRtProvider = StateProvider<RtData?>((ref) => null);

final rtServiceProvider = Provider<RtService>((ref) {
  return RtService(FirebaseFirestore.instance);
});

final generateCodeNotifierProvider = NotifierProvider<GenerateCodeNotifier, GenerateCodeState>(() {
  return GenerateCodeNotifier();
});

final deleteCodeNotifierProvider = AsyncNotifierProvider.autoDispose<DeleteCodeNotifier, void>(() {
  return DeleteCodeNotifier();
});

final rtCreationNotifierProvider = AsyncNotifierProvider.autoDispose<RtCreationNotifier, void>(() {
  return RtCreationNotifier();
});

final addNewBankAccountNotifierProvider = AsyncNotifierProvider.autoDispose<AddNewBankAccountNotifier, void>(() {
  return AddNewBankAccountNotifier();
});

final citizenVerificationNotifierProvider = AsyncNotifierProvider.autoDispose<CitizenVerificationNotifier, void>(() {
  return CitizenVerificationNotifier();
});

final rtDataProvider = Provider.autoDispose<RtData?>((ref) {
  final asyncRtDoc = ref.watch(rtDocStreamProvider);

  return asyncRtDoc.when(
    data: (doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      final dataWithId = doc.data()! as Map<String, dynamic>..['id'] = doc.id;
      return RtData.fromJson(dataWithId);
    },
    loading: () => null,
    error: (e, s) {
      return null;
    },
  );
});

final rtSummaryProvider = Provider<AsyncValue<String>>((ref) {
  final rtData = ref.watch(rtDataProvider);
  if (rtData == null) {
    return const AsyncValue.loading();
  }
  final population = rtData.population ?? 0;
  final rwData = ref.watch(rwDataProvider);

  return AsyncValue.data('${rtData.rtName} memiliki $population warga yang terhubung dan sudah terhubung pada ${rwData?.rwName}');
});

final rtDocStreamProvider = StreamProvider.autoDispose<DocumentSnapshot>((ref) {
  final asyncUserDoc = ref.watch(userDocStreamProvider);
  debugPrint("rtDocStreamProvider called");

  return asyncUserDoc.when(
    data: (userDoc) {
      if (!userDoc.exists || userDoc.data() == null) {
        debugPrint("rtDocStreamProvider: userDoc does not exist");
        return const Stream.empty();
      }

      debugPrint("rtDocStreamProvider: userDoc exists");

      final userData = userDoc.data() as Map<String, dynamic>;
      final rtId = userData['rtId'] as String?;

      if (rtId != null) {
        final rtService = ref.read(rtServiceProvider);
        return rtService.fetchRtDocStream(rtId);
      } else {
        return const Stream.empty();
      }
    },
    loading: () => const Stream.empty(),
    error: (err, stack) => Stream.error(err, stack),
  );
});

final rtListStreamProvider = StreamProvider.autoDispose.family<List<RtData>, String>((ref, rwId) {
  final rtService = ref.watch(rtServiceProvider);
  return rtService.fetchRtsByRwIdStream(rwId);
});

final rtListProvider = FutureProvider.autoDispose.family<List<RtData>, String>((ref, rwId) {
  final rtService = ref.watch(rtServiceProvider);
  return rtService.fetchRtsByRwId(rwId);
});

final filteredRtsProvider = Provider.autoDispose.family<List<RtData>, String>((ref, rwId) {
  final searchQuery = ref.watch(rwSearchQueryProvider).toLowerCase();
  final allRtsAsync = ref.watch(rtListProvider(rwId));

  final allRts = switch (allRtsAsync) {
    AsyncData(:final value) => value,
    _ => <RtData>[],
  };

  if (searchQuery.isEmpty) {
    return [];
  }

  return allRts.where((rt) {
    return rt.rtName.toLowerCase().contains(searchQuery);
  }).toList();
});

final rtChairmanProvider = FutureProvider.family<UserModel?, String>((ref, rtId) {
  final rtService = ref.watch(rtServiceProvider);
  return rtService.fetchRtChairman(rtId);
});

final rtTreasurersProvider = FutureProvider.family<List<UserModel>, String>((ref, rtId) {
  final rtService = ref.watch(rtServiceProvider);
  return rtService.fetchRtTreasurers(rtId);
});

final registrationCodesProvider = StreamProvider.autoDispose.family<List<UniqueCode>, String>((ref, rtId) {
  final rtService = ref.watch(rtServiceProvider);
  return rtService.fetchRegistrationCodes(rtId);
});

final rtManagementProvider = FutureProvider<RtManagement?>((ref) async {
  final selectedRt = ref.watch(selectedRtProvider);

  if (selectedRt == null) {
    return null;
  }

  final chairmanFuture = ref.watch(rtChairmanProvider(selectedRt.id).future);
  final treasurersFuture = ref.watch(rtTreasurersProvider(selectedRt.id).future);
  final codesFuture = ref.watch(registrationCodesProvider(selectedRt.id).future);

  final results = await Future.wait([
    chairmanFuture,
    treasurersFuture,
    codesFuture
  ]);

  final chairman = results[0] == null ? null : results[0] as UserModel;
  final treasurers = results[1] as List<UserModel>;
  final codes = results[2] as List<UniqueCode>;

  return RtManagement(chairman: chairman, treasurers: treasurers, registrationCodes: codes);
});

final transactionsProvider = StreamProvider.autoDispose.family<List<TransactionData>, String>((ref, rtId) {
  final rtService = ref.watch(rtServiceProvider);
  return rtService.fetchTransactions(rtId);
});

final pendingCitizensProvider = StreamProvider.autoDispose.family<List<UserModel>, String>((ref, rtId) {
  final rtService = ref.watch(rtServiceProvider);
  return rtService.fetchPendingCitizens(rtId);
});
