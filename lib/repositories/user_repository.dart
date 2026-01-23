import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'user';

  Stream<UserModel> getUserById(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) => UserModel.fromJson(doc.data()!));
  }

  Future<void> addUser(UserModel user, String uid) async {
    await _firestore.collection(_collection).doc(uid).set(user.toJson());
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(uid).update(data);
  }
}
