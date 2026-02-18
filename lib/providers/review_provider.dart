import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/models/review_model.dart';
import 'package:tutam_fit/repositories/review_repository.dart';


// Repository
final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository();
});

// Reviews for a product
final reviewProvider =
    StreamProvider.family<List<ReviewModel>, String>((ref, productId) {
  final repo = ref.read(reviewRepositoryProvider);
  return repo.getReviewsByProduct(productId);
});

// All reviews for admin
final allReviewsProvider = StreamProvider<List<ReviewModel>>((ref) {
  final repo = ref.read(reviewRepositoryProvider);
  return repo.getAllReviews();
});

// Reviews by user
final userReviewsProvider =
    StreamProvider.family<List<ReviewModel>, String>((ref, userId) {
  final repo = ref.read(reviewRepositoryProvider);
  return repo.getReviewsByUser(userId);
});