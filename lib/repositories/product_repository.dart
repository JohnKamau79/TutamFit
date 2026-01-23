import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'product';

  Stream<List<ProductModel>> getAllProducts() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection(_collection).add(product.toJson());
  }

  Future<void> updateProduct(String docId, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(docId).update(data);
  }

  Future<void> deleteProduct(String docId) async {
    await _firestore.collection(_collection).doc(docId).delete();
  }
}
