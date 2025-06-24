import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/model/RW/rw_data.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

final rwDocStreamProvider = StreamProvider.autoDispose
    .family<DocumentSnapshot<Map<String, dynamic>>, String>((ref, rwId) {

  final rwService = ref.watch(rwServiceProvider);

  return rwService.fetchRwDocStream(rwId);
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