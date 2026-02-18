// category_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutam_fit/models/category_model.dart';

class CategoryRepository {
  final _collection = FirebaseFirestore.instance.collection('categories');

  Stream<List<CategoryModel>> streamCategories() {
    return _collection.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final data = {...doc.data(), 'id': doc.id};
        return CategoryModel.fromJson(data);
      }).toList(),
    );
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    await _collection.add(category.toJson());
  }
}