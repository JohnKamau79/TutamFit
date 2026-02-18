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

  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
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

  // Future<void> deleteUser(String uid) async {
  //   await _firestore.collection(_collection).doc(uid).delete();
  // }

  Future<void> deleteUser(String uid) async {
  final batch = _firestore.batch();
  final userDoc = _firestore.collection(_collection).doc(uid);

  // Delete wishlist
  final wishlistSnapshot = await userDoc.collection('wishlist').get();
  for (var doc in wishlistSnapshot.docs) {
    batch.delete(doc.reference);
  }

  // Delete cart
  final cartSnapshot = await userDoc.collection('cart').get();
  for (var doc in cartSnapshot.docs) {
    batch.delete(doc.reference);
  }

  // Delete user doc
  batch.delete(userDoc);

  await batch.commit();
}
}
