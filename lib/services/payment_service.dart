import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:wargaqu/model/bill/bill_type.dart';
import 'package:wargaqu/model/payment/payment.dart';
import 'package:path/path.dart' as path;

import '../model/income/income.dart';

class PaymentService {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  PaymentService(this._firestore, this._storage);

  Future<List<Payment>> fetchPaymentHistory(String userId, String billType) async {
    try {
      debugPrint(billType);
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('payments')
          .where('billType', isEqualTo: billType)
          .orderBy('paymentTimestamp', descending: true)
          .limit(20)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Payment.fromJson(data);
      }).toList();

    } on FirebaseException catch (e) {
      debugPrint('Firebase Error fetching payment history: ${e.message}');
      throw Exception('Gagal memuat riwayat pembayaran: ${e.code}');
    } catch (e, stack) {
      debugPrint('General Error fetching payment history: $e');
      debugPrint(stack.toString());
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<void> makePayment({
    required String userId,
    required String billId,
    required BillType billType,
    required String billName,
    required int amountPaid,
    required String paymentMethod,
    required File proofImageFile,
    String? citizenNote
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

      final batch = _firestore.batch();

      final newPaymentRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('payments')
          .doc();
      final newPaymentId = newPaymentRef.id;

      final paymentData = Payment(
        id: newPaymentId,
        billName: billName,
        amountPaid: amountPaid,
        billType: billType,
        paymentMethod: paymentMethod,
        paymentProofUrl: downloadUrl,
        status: 'perlu_konfirmasi',
        paymentTimestamp: DateTime.now(),
        citizenNote: citizenNote
      );
      batch.set(newPaymentRef, paymentData.toJson());

      final userDocRef = _firestore.collection('users').doc(userId);
      batch.update(userDocRef, {
        'billsStatus.$billId.status': 'perlu_konfirmasi',
        'billsStatus.$billId.paymentId': newPaymentId
      });

      await batch.commit();
      debugPrint('Pembayaran berhasil dikirim untuk verifikasi!');

    } on FirebaseException catch (e) {
      debugPrint('Firebase Error saat melakukan pembayaran: ${e.message}');
      throw Exception('Gagal mengirim bukti pembayaran: ${e.code}');
    } catch (e) {
      debugPrint('General Error saat melakukan pembayaran: $e');
      throw Exception('Terjadi kesalahan tidak terduga saat mengirim bukti.');
    }
  }

  Future<void> confirmPayment({
    required String userId,
    required String billName,
    required String billId,
    required String paymentId,
    required int amountPaid,
    required String rtId,
    String? rtNote,
  }) async {
    final paymentDocRef = _firestore.collection('users').doc(userId).collection('payments').doc(paymentId);
    final userDocRef = _firestore.collection('users').doc(userId);
    final rtDocRef = _firestore.collection('rts').doc(rtId);
    final newIncomeDocRef = rtDocRef.collection('incomes').doc();

    // Buat ID Laporan Bulanan yang bisa ditebak
    final periodId = DateFormat('yyyy-MM').format(DateTime.now());
    final reportId = '${rtId}_$periodId';
    final monthlyReportRef = _firestore.collection('monthlyReports').doc(reportId);

    try {
      await _firestore.runTransaction((transaction) async {
        final reportDoc = await transaction.get(monthlyReportRef);
        transaction.update(paymentDocRef, {
          'status': 'lunas',
          'rtNote': rtNote,
          'rtConfirmationTimestamp': FieldValue.serverTimestamp(),
        });

        // Update map `billsStatus` di dokumen user
        transaction.update(userDocRef, {
          'billsStatus.$billId.status': 'lunas',
        });

        transaction.set(newIncomeDocRef, {
          'amount': amountPaid,
          'incomeDate': FieldValue.serverTimestamp(),
          'description': 'Pembayaran $billName',
          'runtimeType': 'income'
        });

        // Update saldo kas utama RT
        transaction.update(rtDocRef, {
          'currentBalance': FieldValue.increment(amountPaid),
          'currentMonthIncome': FieldValue.increment(amountPaid),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Update atau buat dokumen laporan bulanan
        if (!reportDoc.exists) {
          transaction.set(monthlyReportRef, {
            'entityId': rtId,
            'runtimeType': 'monthly',
            'periodYearMonth': periodId,
            'totalIncome': amountPaid,
            'totalExpenses': 0,
            'netMonthlyResult': amountPaid,
            'incomingTransactionCount': 1,
            'outgoingTransactionCount': 0,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        } else {
          final currentData = reportDoc.data()!;
          final newNetResult = (currentData['totalIncome'] ?? 0) + amountPaid - (currentData['totalExpenses'] ?? 0);

          transaction.update(monthlyReportRef, {
            'totalIncome': FieldValue.increment(amountPaid),
            'incomingTransactionCount': FieldValue.increment(1),
            'netMonthlyResult': newNetResult,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      });

      debugPrint('Konfirmasi pembayaran untuk $paymentId berhasil secara atomik!');

    } catch (e) {
      debugPrint('Transaksi gagal: $e');
      throw Exception('Gagal mengonfirmasi pembayaran, coba beberapa saat lagi.');
    }
  }

  Future<void> confirmCashPayment({
    required String userId,
    required String rtId,
    required String billId,
    required String billName,
    required int amountPaid,
  }) async {

    final userDocRef = _firestore.collection('users').doc(userId);
    final rtDocRef = _firestore.collection('rts').doc(rtId);
    final newPaymentRef = userDocRef.collection('payments').doc();

    final currentDate = DateTime.now();
    final periodId = DateFormat('yyyy-MM').format(currentDate);
    final reportId = '${rtId}_$periodId';
    final monthlyReportRef = _firestore.collection('monthlyReports').doc(reportId);

    try {
      await _firestore.runTransaction((transaction) async {
        final reportDoc = await transaction.get(monthlyReportRef);

        transaction.set(newPaymentRef, {
          'id': newPaymentRef.id,
          'billId': billId,
          'billName': billName,
          'amountPaid': amountPaid,
          'paymentMethod': 'Tunai',
          'status': 'lunas',
          'paymentTimestamp': FieldValue.serverTimestamp(),
          'rtConfirmationTimestamp': FieldValue.serverTimestamp(),
        });

        // Aksi 2: Update "contekan" status di dokumen user
        transaction.update(userDocRef, {
          'billsStatus.$billId': {
            'status': 'lunas',
            'paymentId': newPaymentRef.id,
          },
        });

        transaction.update(rtDocRef, {
          'currentBalance': FieldValue.increment(amountPaid),
          'currentMonthIncome': FieldValue.increment(amountPaid),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (!reportDoc.exists) {
          transaction.set(monthlyReportRef, {
            'entityId': rtId,
            'runtimeType': 'monthly',
            'periodYearMonth': periodId,
            'totalIncome': amountPaid,
            'totalExpenses': 0,
            'netMonthlyResult': amountPaid,
            'incomingTransactionCount': 1,
            'outgoingTransactionCount': 0,
            'lastUpdated': FieldValue.serverTimestamp()
          });
        } else {
          // Jika sudah ada, update yang ada
          final currentData = reportDoc.data()!;
          final newNetResult = (currentData['totalIncome'] ?? 0) + amountPaid - (currentData['totalExpenses'] ?? 0);
          transaction.update(monthlyReportRef, {
            'totalIncome': FieldValue.increment(amountPaid),
            'incomingTransactionCount': FieldValue.increment(1),
            'netMonthlyResult': newNetResult,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      });

      debugPrint('Pembayaran tunai untuk $userId berhasil dikonfirmasi!');

    } catch (e) {
      debugPrint("Transaksi konfirmasi tunai gagal: $e");
      throw Exception("Gagal menyimpan pembayaran tunai.");
    }
  }

  Future<void> rejectPayment({
    required String userId,
    required String paymentId,
    required String billId,      // ID iuran yang statusnya mau diubah di 'billsStatus'
    required String rejectionReason, // Alasan penolakan dari RT
  }) async
  {
    if (rejectionReason.isEmpty) {
      throw Exception('Alasan penolakan wajib diisi.');
    }

    try {
      final batch = _firestore.batch();

      final paymentDocRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('payments')
          .doc(paymentId);

      final userDocRef = _firestore.collection('users').doc(userId);

      batch.update(paymentDocRef, {
        'status': 'ditolak',
        'rtNote': rejectionReason,
        'rtConfirmationTimestamp': FieldValue.serverTimestamp()
      });

      final statusDetail = {
        'status': 'ditolak',
        'paymentId': paymentId,
        'rejectionReason': rejectionReason,
      };
      batch.update(userDocRef, {
        'billsStatus.$billId': statusDetail,
      });

      await batch.commit();

      debugPrint('Notifikasi "Pembayaran Ditolak" dikirim ke user $userId.');
      debugPrint('Penolakan pembayaran untuk $paymentId berhasil!');

    } on FirebaseException catch (e) {
      debugPrint('Firebase Error saat menolak pembayaran: ${e.message}');
      throw Exception('Gagal menolak pembayaran: ${e.code}');
    } catch (e) {
      debugPrint('General Error saat menolak pembayaran: $e');
      rethrow;
    }
  }
}