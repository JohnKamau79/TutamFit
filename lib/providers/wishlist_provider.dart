import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/wishlist_repository.dart';
import '../models/wishlist_model.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>(
  (ref) => WishlistRepository(),
);

final wishlistProvider = StreamProvider.family<WishlistModel, String>((
  ref,
  userId,
) {
  final repo = ref.read(wishlistRepositoryProvider);
  return repo.getWishlist(userId);
});
