import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'review';

  Stream<List<ReviewModel>> getReviewsByProduct(String productId) {
    return _firestore
        .collection(_collection)
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ReviewModel.fromJson(doc.data())).toList());
  }

  Future<void> addReview(ReviewModel review) async {
    await _firestore.collection(_collection).add(review.toJson());
  }
}