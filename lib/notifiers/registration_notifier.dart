import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wargaqu/model/user/user.dart';
import 'package:wargaqu/pages/auth/citizen/citizen_registration_form.dart';
import 'package:wargaqu/providers/providers.dart';
import 'package:wargaqu/providers/rt_providers.dart';
import 'package:wargaqu/providers/user_providers.dart';

class RegistrationNotifier extends AsyncNotifier<void> {
  @override
  void build() {

  }

  Future<void> registerRtOfficial({
    required String email,
    required String password,
    required String fullName,
    required String nik,
    required String phoneNumber,
    required String address,
    required String rtUniqueCode,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      final userService = ref.read(userServiceProvider);
      final rtService = ref.read(rtServiceProvider);

      final result = await rtService.validateRt(rtUniqueCode);

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
        role: result.role,
        phoneNumber: phoneNumber,
        nik: nik,
        rtId: result.rtId,
        rwId: result.rwId,
        address: address,
        joinedTimestamp: DateTime.now()
      );
      final batch = ref.read(firestoreProvider).batch();

      await userService.createUserProfile(newUser, batch);

      await rtService.claimRtCode(result.rtId, result.role, fullName, rtUniqueCode, batch);

      await batch.commit();
    });
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
        joinedTimestamp: DateTime.now()
      );
      final batch = ref.read(firestoreProvider).batch();

      await userService.createUserProfile(newUser, batch);

      await rwService.claimRwCode(rwId, fullName, batch);

      await batch.commit();
    });
  }

  Future<void> registerCitizen({
    required String email,
    required String password,
    required String nik,
    required String fullName,
    required String address,
    required String rwId,
    required String rtId,
    String? kkNumber,
    String? phoneNumber,
    String? currentOccupation,
    String? residencyStatus,
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
        kkNumber: kkNumber,
        rwId: rwId,
        status: 'pending_approval',
        joinedTimestamp: DateTime.now()
      );

      final userDbService = ref.read(userServiceProvider);
      final batch = ref.read(firestoreProvider).batch();
      await userDbService.createUserProfile(newUser, batch);
      await batch.commit();

      debugPrint('Registrasi berhasil untuk: $email');
    });
  }
}