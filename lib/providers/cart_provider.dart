import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_model.dart';

final cartProvider = StreamProvider.family<CartModel, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('carts')
      .doc(userId)
      .snapshots()
      .map((doc) => CartModel.fromJson(doc.data()!));
});