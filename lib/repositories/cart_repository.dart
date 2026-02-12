// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tutam_fit/models/cart_model.dart';

// class CartRepository {
//   final _firestore = FirebaseFirestore.instance;
//   final _collection = 'cart';

//   Stream<CartModel> getCart(String userId) {
//     return _firestore
//         .collection(_collection)
//         .doc(userId)
//         .snapshots()
//         .map((doc) => CartModel.fromJson(doc.data()!));
//   }

//   Future<void> addItem(String userId, CartItem item) async {
//     final cartDoc = _firestore.collection(_collection).doc(userId);
//     final snapshot = await cartDoc.get();

//     CartModel cart;

//     if (snapshot.exists) {
//       cart = CartModel.fromJson(snapshot.data()!);
//       final existingIndex = cart.items.indexWhere(
//         (i) => i.productId == item.productId,
//       );

//       if (existingIndex >= 0) {
//         final existingItem = cart.items[existingIndex];

//         cart.items[existingIndex] = CartItem(
//           productId: existingItem.productId,
//           quantity: existingItem.quantity + item.quantity,
//         );
//       } else {
//         cart.items.add(item);
//       }

//       cart = CartModel(
//         userId: cart.userId,
//         items: cart.items,
//         updatedAt: Timestamp.now(),
//       );
//     } else {
//       cart = CartModel(
//         userId: userId,
//         items: [item],
//         updatedAt: Timestamp.now(),
//       );
//     }

//     await cartDoc.set(cart.toJson());
//   }

//   Future<void> removeItem(String userId, String productId) async {
//     final cartDoc = _firestore.collection(_collection).doc(userId);
//     final snapshot = await cartDoc.get();

//     if (!snapshot.exists) return;

//     CartModel cart = CartModel.fromJson(snapshot.data()!);
//     final index = cart.items.indexWhere((i) => i.productId == productId);

//     if (index >= 0) {
//       final existingItem = cart.items[index];
//       if (existingItem.quantity > 1) {
//         cart.items[index] = CartItem(
//           productId: existingItem.productId,
//           quantity: existingItem.quantity - 1,
//         );
//       } else {
//         cart.items.removeAt(index);
//       }

//       cart = CartModel(
//         userId: cart.userId,
//         items: cart.items,
//         updatedAt: Timestamp.now(),
//       );

//       if (cart.items.isEmpty) {
//         await cartDoc.delete();
//         return;
//       }
//       await cartDoc.set(cart.toJson());
//     }
//   }

//   Future<void> clearCart(String userId) async {
//     await _firestore.collection(_collection).doc(userId).delete();
//   }

//   Future<double> calculateTotal(String userId) async {
//     final snapshot = await _firestore.collection(_collection).doc(userId).get();
//     if (!snapshot.exists) return 0.0;

//     final cart = CartModel.fromJson(snapshot.data()!);

//     double total = 0.0;

//     for (var item in cart.items) {
//       final product = await _firestore
//           .collection('product')
//           .doc(item.productId)
//           .get();
//       total += item.quantity * product['price'];
//     }

//     return total;
//   }
// }
