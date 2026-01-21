import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

final productProvider = StreamProvider<List<ProductModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('products')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromJson(doc.data()))
            .toList(),
      );
});
