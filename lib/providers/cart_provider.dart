// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../repositories/cart_repository.dart';
// import '../models/cart_model.dart';

// final cartRepositoryProvider = Provider<CartRepository>((ref) {
//   return CartRepository();
// });

// final cartProvider = StreamProvider.family<CartModel, String>((ref, userId) {
//   final repo = ref.read(cartRepositoryProvider);
//   return repo.getCart(userId);
// });
