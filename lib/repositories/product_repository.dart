import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRepository {
  final CollectionReference _productCollection = FirebaseFirestore.instance
      .collection('products');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _collection = 'products';

  // Get all products
  Stream<List<ProductModel>> getAllProducts() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ProductModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(),
        );
  }

  Future<List<ProductModel>> fetchProductsOnce() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .toList();
  }

  // // Get products by category or type
  // Stream<List<ProductModel>> filterProducts({
  //   String? categoryId,
  //   String? typeName,
  // }) {
  //   Query query = _productCollection;
  //   if (categoryId != null) {
  //     query = query.where('categoryId', isEqualTo: categoryId);
  //   }
  //   if (typeName != null) {
  //     query = query.where('typeName', isEqualTo: typeName);
  //   }

  //   return query.snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       data['id'] = doc.id;
  //       return ProductModel.fromJson(data);
  //     }).toList();
  //   });
  // }

  Stream<List<ProductModel>> filterProductsByCategory({
    required String categoryId,
    String? typeName,
  }) {
    Query query = _firestore
        .collection(_collection)
        .where('categoryId', isEqualTo: categoryId);

    if (typeName != null) {
      query = query.where('typeName', isEqualTo: typeName);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList(),
    );
  }

  Stream<List<ProductModel>> getFilteredProducts({String? categoryId}) {
    Query query = _firestore.collection(_collection);

    if (categoryId != null && categoryId != 'all') {
      query = query.where('categoryId', isEqualTo: categoryId);
    }

    return query.snapshots().map(
      (snap) => snap.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList(),
    );
  }

  // Add new product
  Future<void> addProduct(ProductModel product) async {
    await _productCollection.add(product.toJson());
  }

  // Update existing product
  Future<void> updateProduct(String docId, Map<String, dynamic> data) async {
    await _productCollection.doc(docId).update(data);
  }

  // Delete existing product
  Future<void> deleteProduct(String docId) async {
    await _productCollection.doc(docId).delete();
  }
}
