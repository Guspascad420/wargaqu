import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wargaqu/model/bank_account/bank_account.dart';
import 'package:wargaqu/model/bill/bill.dart';
import 'package:wargaqu/model/bill/bill_type.dart';

class BillService {
  final FirebaseFirestore _firestore;

  BillService(this._firestore);

  Future<List<BankAccount>> fetchBankAccounts(String rtId) async {
    try {
      final DocumentSnapshot rtDoc = await _firestore
          .collection('rts')
          .doc(rtId)
          .get();

      if (!rtDoc.exists) {
        print('Dokumen RT dengan ID $rtId tidak ditemukan.');
        return []; // Kembalikan list kosong
      }

      final List<dynamic> bankAccountsList = rtDoc.get('bankAccounts') ?? [];

      if (bankAccountsList.isEmpty) {
        print('Tidak ada rekening bank di RT $rtId.');
        return [];
      }

      return bankAccountsList.map((accountData) {
        return BankAccount.fromJson(accountData as Map<String, dynamic>);
      }).toList();

    } catch (e) {
      print('Error pas ngambil rekening bank: $e');
      throw Exception('Gagal memuat data rekening bank.');
    }
  }

  Future<void> createNewBill(Bill bill) async {
    try {
      await _firestore
          .collection('bills')
          .doc(bill.id)
          .set(bill.toJson());
    } catch (e) {
      throw Exception('Gagal menyimpan data iuran');
    }
  }

  Future<List<Bill>> fetchActiveBills() async {
    try {
      final snapshot = await _firestore
          .collection('bills')
          .where('billType', isEqualTo: BillType.regular.displayName)
          .where('status', isEqualTo: 'active')
          .orderBy('paymentTimestamp', descending: true) // Urutkan dari yang terbaru
          .limit(5)
          .get();

      if (snapshot.docs.isEmpty) {
        return []; // Kembalikan list kosong jika tidak ada data
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Bill.fromJson(data);
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