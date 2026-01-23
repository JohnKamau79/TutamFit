import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_model.dart';

class CartRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'cart';

  Stream<CartModel> getCart(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map((doc) => CartModel.fromJson(doc.data()!));
  }

  Future<void> updateCart(String userId, CartModel cart) async {
    await _firestore.collection(_collection).doc(userId).set(cart.toJson());
  }

  Future<void> clearCart(String userId) async {
    await _firestore.collection(_collection).doc(userId).delete();
  }
}
