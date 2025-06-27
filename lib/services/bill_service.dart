import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';

class BillService {
  final FirebaseFirestore _firestore;

  BillService(this._firestore);

  Future<void> createNewBill({
    required String rtId,
    required String billName,
    required BillType billType,
    required double amount,
    required DateTime dueDate
  }) async {
    try {
      await _firestore
          .collection('bills')
          .add({
            'rtId': rtId,
            'billName': billName,
            'billType': billType.displayName,
            'amount': amount,
            'dueDate': dueDate,
            'status': 'ACTIVE',
          });
    } catch (e) {
      throw Exception('Gagal menyimpan data iuran');
    }
  }

  Stream<List<Bill>> fetchActiveBills(BillType billType) {
    try {
      final querySnapshotStream = _firestore
          .collection('bills')
          .where('billType', isEqualTo: billType.displayName)
          .where('status', isEqualTo: 'ACTIVE')
          .limit(5)
          .snapshots();

      return querySnapshotStream.map((snapshot) {
        if (snapshot.docs.isEmpty) {
          return [];
        }
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return Bill.fromJson(data);
        }).toList();

      });
    } on FirebaseException catch (e) {
      print('Firebase Error fetching payment history: ${e.message}');
      throw Exception('Gagal memuat riwayat pembayaran: ${e.code}');
    } catch (e) {
      print('General Error fetching payment history: $e');
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }
}