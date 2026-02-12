import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final categoryProvider = StreamProvider<List<CategoryModel>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getAllCategories();
});
