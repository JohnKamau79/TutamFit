import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutam_fit/models/cart_model.dart';
import 'package:tutam_fit/models/product_model.dart';

class CartRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _cartRef() {
    return _firestore.collection('users').doc(_uid).collection('cart');
  }

  // Add to cart
  Future<void> addToCart(ProductModel product) async {
    if (_uid == null) throw Exception('User not logged in');

    final doc = await _cartRef().doc(product.id).get();

    if (doc.exists) {
      await _cartRef().doc(product.id).update({
        'quantity': FieldValue.increment(1),
      });
    } else {
      await _cartRef().doc(product.id).set({
        'productId': product.id,
        'name': product.name,
        'price': product.price,
        'image': product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
        'quantity': 1,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Increase quantity
  Future<void> increaseQuantity(String productId) async {
    await _cartRef().doc(productId).update({
      'quantity': FieldValue.increment(1),
    });
  }

  // Decrease quantity
  Future<void> decreaseQuantity(String productId, int currentQty) async {
    if (currentQty <= 1) {
      await removeItem(productId);
    } else {
      await _cartRef().doc(productId).update({
        'quantity': FieldValue.increment(-1),
      });
    }
  }

  // Remove item
  Future<void> removeItem(String productId) async {
    await _cartRef().doc(productId).delete();
  }

  // Stream cart as List<CartModel>
  Stream<List<CartModel>> streamCart() {
    if (_uid == null) return const Stream.empty();

    return _cartRef().snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CartModel.fromMap(doc.data())).toList();
    });
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/cart_model.dart';

// class CartRepository {
//   final _firestore = FirebaseFirestore.instance;
//   final _collection = 'cart';

//   // Stream to listen to cart updates
//   Stream<CartModel> getCart(String userId) {
//     return _firestore
//         .collection(_collection)
//         .doc(userId)
//         .snapshots()
//         .map(
//           (doc) => doc.data() != null
//               ? CartModel.fromJson(doc.data()!)
//               : CartModel(
//                   userId: userId,
//                   items: [],
//                   updatedAt: Timestamp.now(),
//                 ),
//         );
//   }

//   // Add or update item in cart
//   Future<void> addItem(String userId, CartItem item) async {
//     final cartDoc = _firestore.collection(_collection).doc(userId);
//     final snapshot = await cartDoc.get();

//     CartModel cart;

//     if (snapshot.exists) {
//       cart = CartModel.fromJson(snapshot.data()!);
//       final index = cart.items.indexWhere((i) => i.productId == item.productId);

//       if (index >= 0) {
//         // Increase quantity if item exists
//         cart.items[index] = CartItem(
//           productId: item.productId,
//           quantity: cart.items[index].quantity + item.quantity,
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

//   // Remove single item or decrease quantity
//   Future<void> removeItem(String userId, String productId) async {
//     final cartDoc = _firestore.collection(_collection).doc(userId);
//     final snapshot = await cartDoc.get();

//     if (!snapshot.exists) return;

//     CartModel cart = CartModel.fromJson(snapshot.data()!);
//     final index = cart.items.indexWhere((i) => i.productId == productId);

//     if (index >= 0) {
//       final existing = cart.items[index];
//       if (existing.quantity > 1) {
//         cart.items[index] = CartItem(
//           productId: existing.productId,
//           quantity: existing.quantity - 1,
//         );
//       } else {
//         cart.items.removeAt(index);
//       }

//       if (cart.items.isEmpty) {
//         await cartDoc.delete();
//       } else {
//         cart = CartModel(
//           userId: cart.userId,
//           items: cart.items,
//           updatedAt: Timestamp.now(),
//         );
//         await cartDoc.set(cart.toJson());
//       }
//     }
//   }

//   // Clear entire cart
//   Future<void> clearCart(String userId) async {
//     await _firestore.collection(_collection).doc(userId).delete();
//   }

//   // // Calculate total price
//   // Future<double> calculateTotal(String userId) async {
//   //   final snapshot = await _firestore.collection(_collection).doc(userId).get();
//   //   if (!snapshot.exists) return 0.0;

//   //   final cart = CartModel.fromJson(snapshot.data()!);
//   //   double total = 0.0;

//   //   for (var item in cart.items) {
//   //     final product = await _firestore
//   //         .collection('products')
//   //         .doc(item.productId)
//   //         .get();
//   //     total += item.quantity * (product['price'] as num).toDouble();
//   //   }

//   //   return total;
//   // }
// }
