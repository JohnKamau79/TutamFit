import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutam_fit/models/review_model.dart';

class ReviewRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'reviews';

  // Fetch reviews for a specific product
  Stream<List<ReviewModel>> getReviewsByProduct(String productId) {
    return _firestore
        .collection(_collection)
        .where('productId', isEqualTo: productId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Fetch all reviews (admin)
  Stream<List<ReviewModel>> getAllReviews() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Fetch reviews by user
  Stream<List<ReviewModel>> getReviewsByUser(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  // Add review
  Future<void> addReview(ReviewModel review) async {
    await _firestore.collection(_collection).add(review.toJson());
  }

  // Delete review
  Future<void> deleteReview(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
