import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/repositories/cart_repository.dart';
import 'package:tutam_fit/models/cart_model.dart';

final cartRepositoryProvider =
    Provider<CartRepository>((ref) => CartRepository());

final cartStreamProvider =
    StreamProvider.autoDispose<List<CartModel>>((ref) {
  final repo = ref.watch(cartRepositoryProvider);
  return repo.streamCart();
});








































// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../repositories/cart_repository.dart';
// import '../models/cart_model.dart';

// final cartRepositoryProvider = Provider<CartRepository>((ref) => CartRepository());

// final cartProvider = StreamProvider.family<CartModel, String>((ref, userId) {
//   final repo = ref.read(cartRepositoryProvider);
//   return repo.getCart(userId);
// });