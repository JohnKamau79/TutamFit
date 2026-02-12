import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

// Create a product repository instance
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// Watch for product changes
final allProductsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getAllProducts();
});

final filteredProductsStreamProvider =
    StreamProvider.family<List<ProductModel>, Map<String, String?>>((
      ref,
      filter,
    ) {
      final repo = ref.watch(productRepositoryProvider);
      final categoryId = filter['categoryId'];
      final typeName = filter['typeName'];

      return repo.filterProducts(categoryId: categoryId, typeName: typeName);
    });

// StreamProvider<List<ProductModel>> productsByFilterProvider({ String? categoryId, String? typeName }) {
//   return StreamProvider<List<ProductModel>>((ref) {
//     final repo = ref.watch(productRepositoryProvider);
//     return repo.filterProducts(categoryId: categoryId, typeName: typeName);
//   });
// }
