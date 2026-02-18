import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutam_fit/models/product_model.dart';

class ProductRepository {
  final _collection = FirebaseFirestore.instance.collection('products');

  Stream<List<ProductModel>> streamAllProducts() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = {...doc.data(), 'id': doc.id};
        return ProductModel.fromJson(data);
      }).toList(),
    );
  }

  Stream<List<ProductModel>> streamProductsByCategory(
    String categoryId, {
    String? typeId,
  }) {
    Query query = _collection.where('categoryId', isEqualTo: categoryId);
    if (typeId != null) {
      query = query.where('typeId', isEqualTo: typeId);
    }
    return query.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = {...(doc.data() as Map<String, dynamic>), 'id': doc.id};
        return ProductModel.fromJson(data);
      }).toList(),
    );
  }

  Future<String> addProduct(ProductModel product) async {
    final docRef = _collection.doc();
    await docRef.set(product.toJson());
    return docRef.id;
  }

  Future<void> updateProduct(String productId, Map<String, Object> updatedData) async {
  await _collection.doc(productId).update(updatedData);
  }

  Future<void> deleteProduct(String productId) async {
    await _collection.doc(productId).delete();
  }
}
