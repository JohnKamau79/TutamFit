import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'categories';

  // Listen for categories
  Stream<List<CategoryModel>> getAllCategories() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(),
        );
  }

  // Fetch all categories once
  Future<List<CategoryModel>> fetchCategories() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  // Add new category
  Future<void> addCategory(CategoryModel category) async {
    await _firestore.collection(_collection).add(category.toJson());
  }

  // Update existing category by id
  Future<void> updateCategory(String docId, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(docId).update(data);
  }

  // Delete category by id
  Future<void> deleteCategory(String docId) async {
    await _firestore.collection(_collection).doc(docId).delete();
  }
}
