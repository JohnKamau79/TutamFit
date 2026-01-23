import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'category';

  Stream<List<CategoryModel>> getAllCategories() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> addCategory(CategoryModel category) async {
    await _firestore.collection(_collection).add(category.toJson());
  }

  Future<void> updateCategory(String docId, Map<String, dynamic> data) async {
    await _firestore.collection(_collection).doc(docId).update(data);
  }
}
