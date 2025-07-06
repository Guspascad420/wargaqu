import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:wargaqu/model/citizen/citizen_with_status.dart';
import 'package:wargaqu/model/user/user.dart';

class UserService {
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;

  UserService(this._firestore, this._messaging);

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

    Map<String, dynamic> userJson = user.toJson();
    userJson['fcmTokens'] = [fcmToken];

    debugPrint('FCM Token didapat: $fcmToken');
    batch.set(userRef, user.toJson());
  }

  Future<void> deleteFcmToken(String userId) async {
    try {
      final String? fcmToken = await _messaging.getToken();

      if (fcmToken == null) {
        debugPrint('Gagal mendapatkan FCM token.');
        return;
      }
      await _firestore.collection('users').doc(userId).update({
        'fcmTokens': FieldValue.arrayRemove([fcmToken]),
      });
    } on FirebaseException catch (e) {
      throw Exception('Gagal menghapus token: ${e.code}');
    }
    catch (e) {
      debugPrint('Terjadi error saat menghapus FCM token: $e');
    }
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

  Future<UserModel> fetchUserDoc(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();

    if (snapshot.data() == null) {
      throw Exception('Data tidak ditemukan');
    }

    return UserModel.fromJson(snapshot.data()!);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDocStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots();
  }

  Future<UserModel?> getUserDoc(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) {
      if (snapshot.data() == null) {
        return null;
      }
      return UserModel.fromJson(snapshot.data()!);
    });
  }

  Future<DocumentSnapshot> fetchPaymentDoc(String userId, String paymentId) {
    return _firestore.collection('users').doc(userId).collection('payments').doc(paymentId).get();
  }
}