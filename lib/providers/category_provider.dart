// category_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';

final categoryRepositoryProvider = Provider((ref) => CategoryRepository());

// Stream of categories
final categoriesStreamProvider = StreamProvider<List<CategoryModel>>((ref) {
  final repo = ref.read(categoryRepositoryProvider);
  return repo.streamCategories();
});

// Future fetch (one-time)
final categoriesFutureProvider = FutureProvider<List<CategoryModel>>((ref) {
  final repo = ref.read(categoryRepositoryProvider);
  return repo.fetchCategories();
});

final selectedCategoryProviders = StateProvider<CategoryModel?>((ref) => null);