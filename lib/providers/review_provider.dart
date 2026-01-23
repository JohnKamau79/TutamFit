import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/review_repository.dart';
import '../models/review_model.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository();
});

final reviewProvider = StreamProvider.family<List<ReviewModel>, String>((
  ref,
  productId,
) {
  final repo = ref.read(reviewRepositoryProvider);
  return repo.getReviewsByProduct(productId);
});
