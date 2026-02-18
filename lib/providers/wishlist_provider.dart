import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/repositories/wishlist_repository.dart';
import 'package:tutam_fit/models/wishlist_model.dart';

final wishlistRepositoryProvider =
    Provider<WishlistRepository>((ref) => WishlistRepository());

final wishlistStreamProvider =
    StreamProvider.autoDispose<List<WishlistModel>>((ref) {
  final repo = ref.watch(wishlistRepositoryProvider);
  return repo.streamWishlist();
});