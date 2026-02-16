import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'users';

  Stream<UserModel?> getUserById(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map(
          (doc) => doc.data() != null ? UserModel.fromJson(doc.data()!) : null,
        );
  }

  Future<void> addUser(UserModel user, String uid) async {
    await _firestore
        .collection(_collection)
        .doc(uid)
        .set(user.toJson(), SetOptions(merge: true));
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(uid).update(data);
  }
}
