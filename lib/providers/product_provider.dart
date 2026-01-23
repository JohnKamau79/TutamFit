import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

final productProvider = StreamProvider<List<ProductModel>>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return repo.getAllProducts();
});
