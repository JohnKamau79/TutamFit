import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wishlist_model.dart';

class WishlistRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'wishlist';

  // Stream to listen to wishlist
  Stream<WishlistModel> getWishlist(String userId) {
    return _firestore
        .collection(_collection)
        .doc(userId)
        .snapshots()
        .map(
          (doc) => doc.data() != null
              ? WishlistModel.fromJson(doc.data()!)
              : WishlistModel(
                  userId: userId,
                  items: [],
                  updatedAt: Timestamp.now(),
                ),
        );
  }

  // Add product to wishlist
  Future<void> addItem(String userId, String productId) async {
    final docRef = _firestore.collection(_collection).doc(userId);
    final snapshot = await docRef.get();

    WishlistModel wishlist;

    if (snapshot.exists) {
      wishlist = WishlistModel.fromJson(snapshot.data()!);
      if (!wishlist.items.any((i) => i.productId == productId)) {
        wishlist.items.add(WishlistItem(productId: productId));
      }
      wishlist = WishlistModel(
        userId: wishlist.userId,
        items: wishlist.items,
        updatedAt: Timestamp.now(),
      );
    } else {
      wishlist = WishlistModel(
        userId: userId,
        items: [WishlistItem(productId: productId)],
        updatedAt: Timestamp.now(),
      );
    }

    await docRef.set(wishlist.toJson());
  }

  // Remove product from wishlist
  Future<void> removeItem(String userId, String productId) async {
    final docRef = _firestore.collection(_collection).doc(userId);
    final snapshot = await docRef.get();
    if (!snapshot.exists) return;

    WishlistModel wishlist = WishlistModel.fromJson(snapshot.data()!);
    wishlist.items.removeWhere((i) => i.productId == productId);

    if (wishlist.items.isEmpty) {
      await docRef.delete();
    } else {
      wishlist = WishlistModel(
        userId: wishlist.userId,
        items: wishlist.items,
        updatedAt: Timestamp.now(),
      );
      await docRef.set(wishlist.toJson());
    }
  }

  // Clear wishlist
  Future<void> clearWishlist(String userId) async {
    await _firestore.collection(_collection).doc(userId).delete();
  }

  // Check if product is in wishlist
  Future<bool> isInWishlist(String userId, String productId) async {
    final snapshot = await _firestore.collection(_collection).doc(userId).get();
    if (!snapshot.exists) return false;

    final wishlist = WishlistModel.fromJson(snapshot.data()!);
    return wishlist.items.any((i) => i.productId == productId);
  }
}
