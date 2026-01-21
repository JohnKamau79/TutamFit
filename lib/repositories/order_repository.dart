import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'order';

  Stream<List<OrderModel>> getOrderByUser(String uid) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: uid )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList());
  }

  Future<void> addOrder(OrderModel order) async {
    await _firestore.collection(_collection).add(order.toJson());
  }

  Future<void> updateOrder(String docId, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(docId).update(data);
  }
}