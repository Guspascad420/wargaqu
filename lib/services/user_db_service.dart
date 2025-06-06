import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wargaqu/model/user/user.dart';

class UserDbService {
  final FirebaseFirestore _firestore;

  UserDbService(this._firestore);

  Future<void> createUserProfile(User user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .set(user.toJson());
    } catch (e) {
      throw Exception('Gagal menyimpan data profil.');
    }
  }
}