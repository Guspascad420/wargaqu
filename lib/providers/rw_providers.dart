import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wargaqu/model/RW/rw_data.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

final rwDocStreamProvider = StreamProvider.autoDispose<DocumentSnapshot>((ref) {
  final asyncUserDoc = ref.watch(userDocStreamProvider);

  return asyncUserDoc.when(
    data: (userDoc) {
      if (!userDoc.exists || userDoc.data() == null) {
        return const Stream.empty();
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final rwId = userData['rwId'] as String?;

      if (rwId != null) {
        final rwService = ref.read(rwServiceProvider);
        return rwService.fetchRwDocStream(rwId);
      } else {
        return const Stream.empty();
      }
    },
    loading: () => const Stream.empty(),
    error: (err, stack) => Stream.error(err, stack),
  );

});

final rwSummaryProvider = Provider<AsyncValue<String>>((ref) {
  final rwData = ref.watch(rwDataProvider);
  if (rwData == null) {
    debugPrint('aaahhh');
    return const AsyncValue.loading();
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

final rwDataProvider = Provider.autoDispose<RwData?>((ref) {
  final asyncRwDoc = ref.watch(rwDocStreamProvider);

  return asyncRwDoc.when(
    data: (doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      final dataWithId = doc.data()! as Map<String, dynamic>..['id'] = doc.id;
      return RwData.fromJson(dataWithId);
    },
    loading: () => null,
    error: (e, s) {
      return null;
    },
  );
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
