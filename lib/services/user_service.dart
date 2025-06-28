import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:wargaqu/model/citizen/citizen_with_status.dart';
import 'package:wargaqu/model/user/user.dart';

class UserDbService {
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;

  UserDbService(this._firestore, this._messaging);

  Future<void> createUserProfile(UserModel user, WriteBatch batch) async {
    final userRef = _firestore.collection('users').doc(user.id);
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final String? fcmToken = await _messaging.getToken();

    if (fcmToken == null) {
      debugPrint('Gagal mendapatkan FCM token.');
      return;
    }

    final userJson = user.toJson();
    userJson['fcmTokens'] = [fcmToken];

    debugPrint('FCM Token didapat: $fcmToken');
    batch.set(userRef, user.toJson());
  }

  Future<void> saveAndGetFcmToken(String userId) async {
    try {
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final String? fcmToken = await _messaging.getToken();

      if (fcmToken == null) {
        debugPrint('Gagal mendapatkan FCM token.');
        return;
      }

      debugPrint('FCM Token didapat: $fcmToken');

      final userDocRef = _firestore.collection('users').doc(userId);
      await userDocRef.update({
        'fcmTokens': FieldValue.arrayUnion([fcmToken]),
      });

      debugPrint('FCM Token berhasil disimpan untuk user: $userId');

    } catch (e) {
      debugPrint('Terjadi error saat menyimpan FCM token: $e');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDocStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots();
  }

  Future<List<CitizenWithStatus>> fetchCitizensWithPaymentStatus({
    required String rtId,
    required String selectedBillPeriod
  }) async
  {
    try {
      final snapshot = await _firestore
          .collection('bills')
          .where('rtId', isEqualTo: rtId)
          .where('role', isEqualTo: "warga")
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final user = UserModel.fromJson(doc.data());

        final status = user.billsStatus[selectedBillPeriod] ?? 'belum_bayar';

        return CitizenWithStatus(user: user, paymentStatus: status);
      }).toList();
    } catch (e) {
      throw Exception('Gagal memuat data pengguna.');
    }
  }
}