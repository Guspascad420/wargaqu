
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/services/user_service.dart';


final userServiceProvider = Provider<UserService>((ref) {
  return UserService(FirebaseFirestore.instance, FirebaseMessaging.instance);
});

final userDocStreamProvider = StreamProvider<DocumentSnapshot<Map<String, dynamic>>>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  debugPrint("userDocStreamProvider called");
  return authState.when(
    data: (user) {
      if (user != null) {
        debugPrint("userDocStreamProvider: user is here, id: ${user.uid}");
        final userService = ref.read(userServiceProvider);
        return userService.getUserDocStream(user.uid);
      }
      debugPrint("userDocStreamProvider: user is null");
      return Stream.empty();
    },
    loading: () {
      debugPrint("userDocStreamProvider: loading...");
      return Stream.empty();
    },
    error: (err, stack) {
      debugPrint(err.toString());
      debugPrint(stack.toString());
      return Stream.empty();
    },
  );
});

final userDataProvider = FutureProvider.autoDispose<UserModel?>((ref) {
  final asyncUserDoc = ref.watch(userDocStreamProvider);
  return asyncUserDoc.when(
    data: (doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      final dataWithId = doc.data()!..['id'] = doc.id;
      final userModel = UserModel.fromJson(dataWithId);
      return userModel;
    },
    loading: () => null,
    error: (e, s) {
      return null;
    },
  );
});

final userIdProvider = Provider<String?>((ref) {
  final asyncUserData = ref.read(userDataProvider);
  return asyncUserData.value?.id;
});

final roleProvider = Provider<String?>((ref) {
  final asyncUserData = ref.watch(userDataProvider);
  return asyncUserData.value?.role;
});

final currentNameProvider = Provider<String?>((ref) {
  final asyncUserData = ref.watch(userDataProvider);
  return asyncUserData.value?.fullName;
});

final addressProvider = Provider<String?>((ref) {
  final asyncUserData = ref.watch(userDataProvider);
  return asyncUserData.value?.address;
});

final currentRwIdProvider = Provider<String?>((ref) {
  final asyncUserData = ref.watch(userDataProvider);
  return asyncUserData.value?.rwId;
});

final currentRtIdProvider = Provider<String?>((ref) {
  final asyncUserData = ref.watch(userDataProvider);
  return asyncUserData.value?.rtId;
});

final billsStatusProvider = Provider<Map<String, dynamic>?>((ref) {
  final asyncUserData = ref.watch(userDataProvider);
  return asyncUserData.value?.billsStatus;
});