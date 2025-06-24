import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/pages/auth/citizen/citizen_login_form.dart';
import 'package:wargaqu/pages/auth/citizen/citizen_registration_form.dart' hide authServiceProvider;
import 'package:wargaqu/providers.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

class RegistrationNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> registerRwOfficial({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String address,
    required String rwUniqueCode,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final userService = ref.read(userServiceProvider);
      final rwService = ref.read(rwServiceProvider);

      final rwId = await rwService.validateAndGetRwId(rwUniqueCode);

      final firebaseUser = await authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (firebaseUser == null) {
        throw Exception('Gagal membuat akun autentikasi.');
      }

      final newUser = UserModel(
        id: firebaseUser.uid,
        email: email,
        fullName: fullName,
        role: 'rw_official',
        phoneNumber: phoneNumber,
        rwId: rwId,
        address: address,
      );
      final batch = ref.read(firestoreProvider).batch();

      await userService.createUserProfile(newUser, batch);

      await rwService.claimRwCode(rwId, fullName, batch);

      await batch.commit();
    });
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String nik,
    required String fullName,
    String? phoneNumber,
    required String address,
    String? currentOccupation,
    String? residencyStatus,
    required String rwId,
    required String rtId
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final firebaseUser = await authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (firebaseUser == null) {
        throw Exception('Gagal membuat akun autentikasi.');
      }

      final newUser = UserModel(
        id: firebaseUser.uid,
        email: email,
        nik: nik,
        rtId: rtId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        address: address,
        currentOccupation: currentOccupation,
        residencyStatus: residencyStatus,
        rwId: rwId,
      );

      final userDbService = ref.read(userDbServiceProvider);
      final batch = ref.read(firestoreProvider).batch();
      await userDbService.createUserProfile(newUser, batch);
      await batch.commit();

      debugPrint('Registrasi berhasil untuk: $email');
    });
  }
}