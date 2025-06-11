import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wargaqu/model/report/report.dart';

class ReportService {
  final FirebaseFirestore _firestore;

  ReportService(this._firestore);

  Future<List<ReportData>> fetchReports(String userId, ReportType reportType) async {
    String collectionName = ReportType.monthly == reportType ? 'monthlyReports' : 'yearlyReports';

    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .orderBy('lastUpdated', descending: true)
          .limit(20)
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ReportData.fromJson(data);
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