import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wargaqu/model/RW/rw_data.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

final rwDocStreamProvider = StreamProvider.autoDispose
    .family<DocumentSnapshot<Map<String, dynamic>>, String>((ref, rwId) {

  final rwService = ref.watch(rwServiceProvider);

  return rwService.fetchRwDocStream(rwId);
});

final rwSummaryProvider = Provider<AsyncValue<String>>((ref) {
  final rwData = ref.watch(loggedInRwDataProvider);
  if (rwData == null) {
    return const AsyncValue.loading(); // Atau AsyncError
  }

  final asyncRtList = ref.watch(rtListStreamProvider(rwData.id));

  return asyncRtList.when(
    data: (rtList) {
      final summary = '${rwData.rwName} telah memiliki ${rtList.length} RT yang terhubung';
      return AsyncValue.data(summary);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

final rwDataProvider = Provider.autoDispose.family<RwData?, String>((ref, rwId) {
  final asyncRwDoc = ref.watch(rwDocStreamProvider(rwId));

  return asyncRwDoc.when(
    data: (doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      final dataWithId = doc.data()!..['id'] = doc.id;
      return RwData.fromJson(dataWithId);
    },
    loading: () => null,
    error: (e, s) {
      return null;
    },
  );
});

final loggedInRwDataProvider = Provider.autoDispose<RwData?>((ref) {
  final rwId = ref.watch(currentRwIdProvider);

  if (rwId == null) {
    return null;
  }

  return ref.watch(rwDataProvider(rwId));
});

final allRwsProvider = FutureProvider.autoDispose<List<RwData>>((ref) {
  final rwService = ref.watch(rwServiceProvider);
  return rwService.fetchAllRws();
});

final rwSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final filteredRwsProvider = Provider.autoDispose<List<RwData>>((ref) {
  final searchQuery = ref.watch(rwSearchQueryProvider).toLowerCase();
  final allRwsAsync = ref.watch(allRwsProvider);

  final allRws = switch (allRwsAsync) {
    AsyncData(:final value) => value,
    _ => <RwData>[],
  };

  if (searchQuery.isEmpty) {
    return [];
  }

  return allRws.where((rw) {
    return rw.rwName.toLowerCase().contains(searchQuery);
  }).toList();
});
