import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/model/payment/payment.dart';
import 'package:path/path.dart' as path;

class PaymentService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  PaymentService(this._firestore, this._storage);

  Future<List<Payment>> fetchPaymentHistory(String userId, String billType) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('payments')
          .where('billType', isEqualTo: billType)
          .orderBy('paymentTimestamp', descending: true) // Urutkan dari yang terbaru
          .limit(20) // Batasi jumlah data yang diambil untuk awal
          .get();

      if (snapshot.docs.isEmpty) {
        return []; // Kembalikan list kosong jika tidak ada data
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['paymentId'] = doc.id;
        return Payment.fromJson(data);
      }).toList();

    } on FirebaseException catch (e) {
      print('Firebase Error fetching payment history: ${e.message}');
      throw Exception('Gagal memuat riwayat pembayaran: ${e.code}');
    } catch (e) {
      print('General Error fetching payment history: $e');
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<void> makePayment({
    required String userId,
    required BillType billType,
    required String dueTypeId,
    required String billName,
    required String billPeriod,
    required double amountPaid,
    required String paymentMethod,
    String? citizenNote,
    required File proofImageFile,
    required DateTime dueDate
  }) async
  {
    try {
      final fileExtension = path.extension(proofImageFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final storagePath = 'payment_proofs/$userId/$fileName';
      final storageRef = _storage.ref().child(storagePath);

      final uploadTask = storageRef.putFile(proofImageFile);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      final paymentData = Payment(
        id: dueTypeId,
        billName: billName,
        amountPaid: amountPaid,
        billPeriod: billPeriod,
        billType: billType,
        paymentMethod: paymentMethod,
        paymentProofUrl: downloadUrl,
        status: 'pending_confirmation',
        paymentTimestamp: DateTime.now(),
        dueDate: dueDate,
      );

      final batch = _firestore.batch();

      final newPaymentRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('payments')
          .doc();
      batch.set(newPaymentRef, paymentData.toJson());

      final userDocRef = _firestore.collection('users').doc(userId);
      batch.update(userDocRef, {
        'billsStatusByPeriod.$billPeriod': 'pending_confirmation',
      });

      await batch.commit();
      print('Pembayaran berhasil dikirim untuk verifikasi!');

    } on FirebaseException catch (e) {
      print('Firebase Error saat melakukan pembayaran: ${e.message}');
      throw Exception('Gagal mengirim bukti pembayaran: ${e.code}');
    } catch (e) {
      print('General Error saat melakukan pembayaran: $e');
      throw Exception('Terjadi kesalahan tidak terduga saat mengirim bukti.');
    }
  }

  Future<void> confirmPayment({
    required String userId,
    required String paymentId,
    required String billPeriod, // Format "YYYY-MM"
    required double amountPaid,
    required String rtId,
    String? rtNote,
  }) async
  {
    try {
      final batch = _firestore.batch();

      final paymentDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('payments')
          .doc(paymentId);

      final userDocRef = _firestore.collection('users').doc(userId);

      final reportId = "${rtId}_${DateFormat('yyyy-MM').format(DateTime.now())}";
      final monthlyReportRef = _firestore.collection('monthly_report').doc(reportId);

      batch.update(paymentDocRef, {
        'status': 'paid',
        'rtNote': rtNote,
        'rtConfirmationTimestamp': FieldValue.serverTimestamp(),
      });

      batch.update(userDocRef, {
        'duesStatusByPeriod.$billPeriod': 'paid',
      });

      batch.set(monthlyReportRef, {
        'totalIncome': FieldValue.increment(amountPaid),
        'incomingTransactionCount': FieldValue.increment(1),
        'rtId': rtId,
        'periodYearMonth': billPeriod,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();

      print('Notifikasi "Pembayaran Dikonfirmasi" dikirim ke user $userId.');

      print('Konfirmasi pembayaran untuk $paymentId berhasil!');

    } on FirebaseException catch (e) {
      print('Firebase Error saat konfirmasi pembayaran: ${e.message}');
      throw Exception('Gagal mengonfirmasi pembayaran: ${e.code}');
    } catch (e) {
      print('General Error saat konfirmasi pembayaran: $e');
      throw Exception('Terjadi kesalahan tidak terduga saat konfirmasi.');
    }
  }
}