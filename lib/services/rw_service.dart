import 'package:cloud_firestore/cloud_firestore.dart';

class RwService {
  final FirebaseFirestore _firestore;
  RwService(this._firestore);

  Future<String> validateAndGetRwId(String uniqueCode) async {
    final query = _firestore
        .collection('rws')
        .where('registrationUniqueCode', isEqualTo: uniqueCode)
        .where('uniqueCodeStatus', isEqualTo: 'AVAILABLE')
        .limit(1);

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      throw Exception('Kode unik tidak valid, sudah digunakan, atau tidak ditemukan');
    }

    return snapshot.docs.first.id;
  }

  Future<void> claimRwCode(String rwId, String headName, WriteBatch batch) async {
    final rwRef = _firestore.collection('rws').doc(rwId);
    batch.update(rwRef, {
      'uniqueCodeStatus': 'USED',
      'rwHeadName': headName,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchRwDocStream(String rwId) {
    return _firestore
        .collection('rws')
        .doc(rwId)
        .snapshots();
  }
}