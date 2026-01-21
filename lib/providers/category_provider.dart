import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';

final categoryProvider = StreamProvider<List<CategoryModel>>((ref) {
  return FirebaseFirestore.instance
      .collection('category')
      .snapshots()
      .map( (snapshot) => snapshot.docs.map( (doc) => CategoryModel.fromJson(doc.data())).toList());
});