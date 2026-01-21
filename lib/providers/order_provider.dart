import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';

final orderProvider = StreamProvider.family<List<OrderModel>, String>((
  ref,
  uid,
) {
  return FirebaseFirestore.instance
      .collection('orders')
      .where('userId', isEqualTo: uid)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromJson(doc.data()))
            .toList(),
      );
});
