import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wargaqu/model/RT/rt_data.dart';
import 'package:wargaqu/model/expense/expense.dart';
import 'package:wargaqu/model/report/report.dart';
import 'package:wargaqu/model/unique_code/unique_code.dart';
import 'package:wargaqu/model/user/user.dart';

class RtService {
  final FirebaseFirestore _firestore;

  RtService(this._firestore);

  Future<({String role, String rtId, String rwId})> validateRt(String uniqueCode) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('registrationCodes')
          .where('code', isEqualTo: uniqueCode)
          .where('status', isEqualTo: 'AVAILABLE')
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Kode unik tidak valid!');
      }
      final codeDoc = querySnapshot.docs.first;
      final String rtId = codeDoc.reference.parent.parent!.id;
      final String role = codeDoc.data()['role'];

      final DocumentSnapshot rtDoc = await _firestore.collection('rts').doc(rtId).get();

      final rwMap = rtDoc.data() as Map<String, dynamic>;
      final String rwIdValue = rwMap['rwId'];
      return (rtId: rtId, role: role, rwId: rwIdValue);
    } on FirebaseException catch (e) {
      print('======================================================');
      print('ERROR ASLI DARI FIREBASE:');
      print(e); // Ini nampilin objek errornya
      print('PESAN LENGKAPNYA:');
      print(e.message); // <-- LINK AJAIBNYA ADA DI SINI
      print('======================================================');

      throw Exception('Gagal mengambil data: ${e.message}');
    }
  }

  Future<void> claimRtCode(String rtId, String role, String officialName, String uniqueCode, WriteBatch batch) async {
    final querySnapshot = await _firestore.collection('rts')
        .doc(rtId).collection('registrationCodes').where('code', isEqualTo: uniqueCode).limit(1).get();
    final uniqueCodeRef = querySnapshot.docs.first.reference;

    batch.update(uniqueCodeRef, {
      'role': role,
      'status': 'USED',
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchRtDocStream(String rtId) {
    return _firestore
        .collection('rts')
        .doc(rtId)
        .snapshots();
  }

  Future<List<UserModel>> fetchRtTreasurers(String rtId) async {
    final snapshot = await _firestore
        .collection('users')
        .where('rtId', isEqualTo: rtId)
        .where('role', isEqualTo: 'bendahara_rt')
        .get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return UserModel.fromJson(data);
    }).toList();
  }

  Future<UserModel?> fetchRtChairman(String rtId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('rtId', isEqualTo: rtId)
          .where('role', isEqualTo: 'ketua_rt')
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      final chairmanMap = snapshot.docs.first.data();
      return UserModel.fromJson(chairmanMap);

    } on FirebaseException catch (e) {
      throw Exception('Gagal mengambil data: ${e.message}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga');
    }
  }

  Future<List<ReportData>> fetchMonthlyReportsByRtId(String rtId) async {
    try {
      final snapshot = await _firestore
          .collection('monthlyReports')
          .where('rtId', isEqualTo: rtId)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return MonthlyReport.fromJson(data);
      }).toList();

    } catch (e) {
      throw Exception('Gagal memuat data rekening bank.');
    }
  }

  Stream<List<UniqueCode>> fetchRegistrationCodes(String rtId) {
    final querySnapshotStream = _firestore
        .collection('rts')
        .doc(rtId)
        .collection('registrationCodes')
        .snapshots();

    return querySnapshotStream.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return UniqueCode.fromJson(data);
      }).toList();
    });
  }

  Future<List<ReportData>> fetchYearlyReportsByRtId(String rtId) async {
    try {
      final snapshot = await _firestore
          .collection('yearlyReports')
          .where('rtId', isEqualTo: rtId)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return YearlyReport.fromJson(data);
      }).toList();

    } catch (e) {
      print('Error pas ngambil rekening bank: $e');
      throw Exception('Gagal memuat data rekening bank.');
    }
  }

  Stream<List<RtData>> fetchRtsByRwIdStream(String rwId) {
    final querySnapshotStream = _firestore
        .collection('rts')
        .where("rwId", isEqualTo: rwId)
        .snapshots();

    return querySnapshotStream.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return RtData.fromJson(data);
      }).toList();
    });
  }

  Future<void> addExpense({
    required String rtId,
    required Expense newExpense,
  }) async
  {
    try {
      final rtDocRef = _firestore.collection('rts').doc(rtId);
      final newExpenseDocRef = rtDocRef.collection('expenses').doc();

      final batch = _firestore.batch();

      batch.set(newExpenseDocRef, newExpense.toJson());

      batch.update(rtDocRef, {
        'currentBalance': FieldValue.increment(-newExpense.amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();


    } on FirebaseException catch (e) {
      print('Firebase Error saat mencatat pengeluaran: ${e.message}');
      throw Exception('Gagal menyimpan data pengeluaran: ${e.code}');
    } catch (e) {
      print('General Error saat mencatat pengeluaran: $e');
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<void> addNewCode({
    required String rtId,
    required UniqueCode newCode,
  }) async {
    try {
      await _firestore.collection('rts').doc(rtId).collection('registrationCodes').add(newCode.toJson());
    } on FirebaseException catch (e) {
      throw Exception('Gagal menyimpan data pengeluaran: ${e.code}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<void> deleteCode({
    required String rtId,
    required String codeToDelete,
  }) async {
    try {
     QuerySnapshot querySnapshot =  await _firestore.collection('rts').doc(rtId)
         .collection('registrationCodes').where('code', isEqualTo: codeToDelete).get();
     if (querySnapshot.docs.isNotEmpty) {
       DocumentSnapshot docToDelete = querySnapshot.docs.first;

       await docToDelete.reference.delete();
     }
    } on FirebaseException catch (e) {
      throw Exception('Gagal menyimpan data pengeluaran: ${e.code}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }

  Future<void> addNewRt({
    required int rtNumber,
    required String rtName,
    required String rwId,
    required String address,
  }) async {
    try {
      await _firestore.collection('rts').add({
        'rtNumber': rtNumber,
        'rtName': rtName,
        'rwId': rwId,
        'address': address,
        'currentBalance': 0,
        'registrationUniqueCode': '',
      });
    } on FirebaseException catch (e) {
      throw Exception('Gagal menyimpan data pengeluaran: ${e.code}');
    } catch (e) {
      throw Exception('Terjadi kesalahan tidak terduga.');
    }
  }
}