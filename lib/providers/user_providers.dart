
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/services/user_service.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final userServiceProvider = Provider<UserDbService>((ref) {
  return UserDbService(FirebaseFirestore.instance);
});

final userDocStreamProvider = StreamProvider.autoDispose<DocumentSnapshot<Map<String, dynamic>>>((ref) {
  final db = ref.watch(userServiceProvider);
  final user = ref.watch(authStateProvider).asData?.value;

  if (user != null) {
    return db.getUserDocStream(user.uid);
  }

  return const Stream.empty();
});

final userDataProvider = FutureProvider.autoDispose<UserModel?>((ref) {
  final asyncUserDoc = ref.watch(userDocStreamProvider);
  return asyncUserDoc.when(
    data: (doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      final dataWithId = doc.data()!..['id'] = doc.id;
      return UserModel.fromJson(dataWithId);
    },
    loading: () => null,
    error: (e, s) {
      return null;
    },
  );
});

final userIdProvider = Provider<String?>((ref) {
  final asyncUserData = ref.watch(userDataProvider);
  return asyncUserData.value?.id;
});

final currentNameProvider = Provider<String?>((ref) {
  final asyncUserData = ref.watch(userDataProvider);
  return asyncUserData.value?.fullName;
});

final currentRwIdProvider = Provider<String?>((ref) {
  final asyncUserData = ref.watch(userDataProvider);
  return asyncUserData.value?.rwId;
});

final currentRtIdProvider = Provider<String?>((ref) {
  final asyncUserData = ref.watch(userDataProvider);
  return asyncUserData.value?.rtId;
});