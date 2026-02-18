import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/models/wishlist_model.dart';

class WishlistRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _wishlistRef() {
    return _firestore.collection('users').doc(_uid).collection('wishlist');
  }

  Future<void> addToWishlist(ProductModel product) async {
    if (_uid == null) throw Exception('User not logged in');

    await _wishlistRef().doc(product.id).set({
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'image': product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFromWishlist(String productId) async {
    if (_uid == null) throw Exception('User not logged in');

    await _wishlistRef().doc(productId).delete();
  }

  Stream<List<WishlistModel>> streamWishlist() {
    if (_uid == null) return const Stream.empty();

    return _wishlistRef().snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => WishlistModel.fromMap(doc.data()))
          .toList();
    });
  }
}
