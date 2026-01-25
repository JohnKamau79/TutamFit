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

  Future<void> addItem(String userId, CartModel item) async{
    final cartDoc = _firestore.collection(_collection).doc(userId);
    final snapshot = await cartDoc.get();

    CartModel cart;
    if(snapshot.exists) {
      cart = CartModel.fromJson(snapshot.data()!)
      final existingIndex = cart.items.indexWhere((i) => i.productId == item.productId);
      if(existingIndex >= 0) {
        cart.items[existingIndex].quantity += item.quantity;
      }
      else{
        cart.items.add(item);
      }
    }
    else {
      cart = CartModel(items: [item]);
    }

    await cartDoc.set(cart.toJson());
  }

  Future<void> updateCart(String userId, CartModel cart) async {
    await _firestore.collection(_collection).doc(userId).set(cart.toJson());
  }

  Future<void> clearCart(String userId) async {
    await _firestore.collection(_collection).doc(userId).delete();
  }
}
