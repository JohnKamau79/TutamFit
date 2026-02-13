import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

// Create a product repository instance
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});


// All selected category.
final selectedCategoryProvider = StateProvider<String>((ref) {
  return 'all';
});

final searchQueryProvider = StateProvider<String>((ref) => '');

// Filter category
final productsStreamProvider = StreamProvider.autoDispose<List<ProductModel>>((ref) {
  final repo = ref.read(productRepositoryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();


  return repo.getFilteredProducts(categoryId: selectedCategory).map((products) {
    if(searchQuery.isEmpty) return products;
    return products.where((p) => p.name.toLowerCase().contains(searchQuery)).toList();
  });
});

// // Watch for product changes
// final allProductsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
//   final repo = ref.read(productRepositoryProvider);
//   return repo.getAllProducts();
// });

// final productsFutureProvider = FutureProvider<List<ProductModel>>((ref) {
//   final repo = ref.read(productRepositoryProvider);
//   return repo.fetchProductsOnce();
// });


// final productsByCategoryFutureProvider = StreamProvider.family<List<ProductModel>, Map<String, String?>>((ref, filter) {
//   final repo = ref.read(productRepositoryProvider);
//   final categoryId = filter['categoryId']!;
//   final typeName = filter['typeName'];

//   return repo.filterProductsByCategory(categoryId: categoryId, typeName: typeName);
// });


// // final filteredProductsStreamProvider =
// //     StreamProvider.family<List<ProductModel>, Map<String, String?>>((
// //       ref,
// //       filter,
// //     ) {
// //       final repo = ref.watch(productRepositoryProvider);
// //       final categoryId = filter['categoryId'];
// //       final typeName = filter['typeName'];

// //       return repo.filterProducts(categoryId: categoryId, typeName: typeName);
// //     });

// // StreamProvider<List<ProductModel>> productsByFilterProvider({ String? categoryId, String? typeName }) {
// //   return StreamProvider<List<ProductModel>>((ref) {
// //     final repo = ref.watch(productRepositoryProvider);
// //     return repo.filterProducts(categoryId: categoryId, typeName: typeName);
// //   });
// // }
