import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/review_model.dart';

final reviewProvider = StreamProvider.family<List<ReviewModel>, String>((ref, productId){
  return FirebaseFirestore.instance
  .collection('review')
  .where('productId', isEqualTo: productId)
  .snapshots()
  .map((snapshot) => snapshot.docs.map((doc) => ReviewModel.fromJson(doc.data())).toList());
});