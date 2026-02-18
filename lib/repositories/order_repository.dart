import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutam_fit/models/order_model.dart';
import 'package:tutam_fit/models/cart_model.dart';

class OrderRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _ordersRef() {
    return _firestore.collection('orders');
  }

  // Create order
  Future<void> createOrder({
    required String userName,
    required List<CartModel> cartItems,
    required String paymentMethod, // 'mpesa' | 'stripe'
    required double totalAmount,
  }) async {
    if (_uid == null) throw Exception('User not logged in');

    final items = cartItems.map((c) => c.toMap()).toList();

    await _ordersRef().add({
      'userId': _uid,
      'userName': userName,
      'items': items,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Stream user's orders
  Stream<List<OrderModel>> streamUserOrders(String uid) {
    return _ordersRef()
        .where('userId', isEqualTo: uid)
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Stream all orders for admin
  Stream<List<OrderModel>> streamAllOrders() {
    return _ordersRef()
        // Optional: sort by creation date
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Update order status (after payment confirmation)
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _ordersRef().doc(orderId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete order
  Future<void> deleteOrder(String orderId) async {
    await _ordersRef().doc(orderId).delete();
  }
}
