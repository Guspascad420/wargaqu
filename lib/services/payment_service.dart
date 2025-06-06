import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wargaqu/model/payment/payment.dart';

class PaymentService {
  final FirebaseFirestore _firestore;

  PaymentService(this._firestore);

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
}