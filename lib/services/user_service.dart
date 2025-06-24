import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wargaqu/model/citizen/citizen_with_status.dart';
import 'package:wargaqu/model/user/user.dart';

class UserDbService {
  final FirebaseFirestore _firestore;

  UserDbService(this._firestore);

  Future<void> createUserProfile(UserModel user, WriteBatch batch) async {
    final userRef = _firestore.collection('users').doc(user.id);
    batch.set(userRef, user.toJson());
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