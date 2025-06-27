import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wargaqu/model/report/report.dart';

class ReportService {
  final FirebaseFirestore _firestore;

  ReportService(this._firestore);

  Stream<List<ReportData>> fetchReports(String rtId, ReportType reportType) {
    String collectionName = ReportType.monthly == reportType ? 'monthlyReports' : 'yearlyReports';

    final querySnapshotStream = _firestore
        .collection(collectionName)
        .where('entityId', isEqualTo: rtId)
        .orderBy('lastUpdated', descending: true)
        .limit(20)
        .snapshots();
    return querySnapshotStream.map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ReportData.fromJson(data);
      }).toList();
    });
  }
}