import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/RT/rt_officials.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/generate_code/generate_code_state.dart';
import 'package:wargaqu/model/unique_code/unique_code.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/notifiers/delete_code_notifier.dart';
import 'package:wargaqu/notifiers/generate_code_notifier.dart';
import 'package:wargaqu/notifiers/add_new_rt_notifier.dart';
import 'package:wargaqu/providers/rw_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';
import 'package:wargaqu/services/rt_service.dart';
import 'package:wargaqu/services/rw_service.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final rwServiceProvider = Provider((ref) => RwService(ref.watch(firestoreProvider)));

final rtDataListProvider = Provider<List<RtData>>((ref) {
  return [
    const RtData(
      id: 'rt01_rw05',
      rwId: 'rw_05_griya_asri',
      rtNumber: 001,
      rtName: 'RT 001 Mawar',
      registrationUniqueCode: 'RT01MWRXYZ',
      uniqueCodeStatus: 'USED',
      secretariatAddress: 'Jl. Mawar No. 1, Griya Asri',
      population: 52,
      currentBalance: 15850000,
      previousMonthClosingBalance: 13550000,
      bankAccounts: [
        BankAccount(
          id: 'bca_rt01',
          bankName: 'BCA',
          accountNumber: '1112223330',
          accountHolderName: 'KAS RT 001 MAWAR RW 05',
        ),
      ],
      isActive: true,
    ),

    // Data untuk RT 002
    const RtData(
      id: 'rt02_rw05',
      rwId: 'rw_05_griya_asri',
      rtNumber: 002,
      rtName: 'RT 002 Melati',
      registrationUniqueCode: 'RT02MLTABC',
      uniqueCodeStatus: 'AVAILABLE',
      secretariatAddress: 'Jl. Melati No. 1, Griya Asri',
      population: 48,
      currentBalance: 12300000,
      previousMonthClosingBalance: 11800000,
      bankAccounts: [
        BankAccount(
          id: 'mandiri_rt02',
          bankName: 'Bank Mandiri',
          accountNumber: '2223334440',
          accountHolderName: 'KAS RT 002 MELATI RW 05',
        ),
      ],
      isActive: true,
    ),

    // Data untuk RT 003
    const RtData(
      id: 'rt03_rw05',
      rwId: 'rw_05_griya_asri',
      rtNumber: 003,
      rtName: 'RT 003 Anggrek',
      registrationUniqueCode: 'RT03AGKDEF',
      uniqueCodeStatus: 'AVAILABLE',
      population: 60,
      currentBalance: 20500000,
      previousMonthClosingBalance: 20500000, // Contoh jika saldo belum berubah
      // bankAccounts dibiarkan kosong, akan menggunakan default list kosong
      isActive: true,
    ),

    // Data untuk RT 004 (Contoh tidak aktif)
    const RtData(
      id: 'rt04_rw05',
      rwId: 'rw_05_griya_asri',
      rtNumber: 004,
      rtName: 'RT 004 Kamboja',
      registrationUniqueCode: 'RT04KMBGHI',
      uniqueCodeStatus: 'EXPIRED',
      population: 0,
      currentBalance: 0,
      isActive: false, // Contoh RT yang tidak aktif
    ),
  ];
});

final selectedRtProvider = StateProvider<RtData?>((ref) => null);

final rtServiceProvider = Provider<RtService>((ref) {
  return RtService(ref.watch(firestoreProvider));
});

final generateCodeNotifierProvider = NotifierProvider<GenerateCodeNotifier, GenerateCodeState>(() {
  return GenerateCodeNotifier();
});

final deleteCodeNotifierProvider = AsyncNotifierProvider.autoDispose<DeleteCodeNotifier, void>(() {
  return DeleteCodeNotifier();
});

final addNewRtNotifierProvider = AsyncNotifierProvider<AddNewRtNotifier, void>(() {
  return AddNewRtNotifier();
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
  final rwData = ref.watch(rwDataProvider(rtData.rwId));

  return AsyncValue.data('${rtData.rtName} memiliki $population warga yang terhubung dan sudah terhubung pada ${rwData?.rwName}');
});

final rtDocStreamProvider = StreamProvider.autoDispose<DocumentSnapshot>((ref) {
  final asyncUserDoc = ref.watch(userDocStreamProvider);

  return asyncUserDoc.when(
    data: (userDoc) {
      if (!userDoc.exists || userDoc.data() == null) {
        return const Stream.empty();
      }

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

