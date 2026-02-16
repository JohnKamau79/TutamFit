import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/models/cart_model.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/providers/cart_provider.dart';
import 'package:tutam_fit/providers/wishlist_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _openFullImage(String image) {
    showDialog(
      context: context,
      builder: (_) =>
          Dialog(child: InteractiveViewer(child: Image.network(image))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        child: const Icon(Icons.arrow_upward),
      ),
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          const Icon(Icons.search),
          const SizedBox(width: 16),
          if (user != null)
            Consumer(
              builder: (context, ref, _) {
                final wishlistAsync = ref.watch(wishlistProvider(user.uid));
                return wishlistAsync.when(
                  data: (wishlist) {
                    final isInWishlist = wishlist.items.any(
                      (item) => item.productId == product.id,
                    );
                    return IconButton(
                      icon: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.primaryRed,
                      ),
                      onPressed: () async {
                        final repo = ref.read(wishlistRepositoryProvider);
                        if (isInWishlist) {
                          await repo.removeItem(user.uid, product.id!);
                        } else {
                          await repo.addItem(user.uid, product.id!);
                        }
                        ref.invalidate(wishlistProvider(user.uid));
                      },
                    );
                  },
                  loading: () => const Icon(Icons.favorite_border),
                  error: (_, __) => const Icon(Icons.favorite_border),
                );
              },
            ),
          const SizedBox(width: 16),
          const Icon(Icons.shopping_cart_outlined),
          const SizedBox(width: 12),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (user != null)
              Consumer(
                builder: (context, ref, _) {
                  final wishlistAsync = ref.watch(wishlistProvider(user.uid));
                  return wishlistAsync.when(
                    data: (wishlist) {
                      final isInWishlist = wishlist.items.any(
                        (item) => item.productId == product.id,
                      );
                      return IconButton(
                        onPressed: () async {
                          final repo = ref.read(wishlistRepositoryProvider);
                          if (isInWishlist) {
                            await repo.removeItem(user.uid, product.id!);
                          } else {
                            await repo.addItem(user.uid, product.id!);
                          }
                        },
                        icon: Icon(
                          isInWishlist ? Icons.favorite : Icons.favorite_border,
                          color: AppColors.primaryRed,
                        ),
                      );
                    },
                    loading: () => const Icon(Icons.favorite_border),
                    error: (_, _) => const Icon(Icons.favorite_border),
                  );
                },
              )
            else
              IconButton(
                onPressed: null,
                icon: const Icon(Icons.favorite_border),
              ),
            const SizedBox(width: 12),
            Flexible(
              child: Consumer(
                builder: (context, ref, _) {
                  if (user == null) {
                    return ElevatedButton(
                      onPressed: null,
                      child: const Text("Login to Add to Cart"),
                    );
                  }
                  final userId = user.uid;
                  final cartAsync = ref.watch(cartProvider(userId));

                  return cartAsync.when(
                    data: (cart) {
                      final isInCart = cart.items.any(
                        (item) => item.productId == product.id,
                      );
                      final cartRepo = ref.read(cartRepositoryProvider);
                      return ElevatedButton(
                        onPressed: isInCart
                            ? null
                            : () async {
                                await cartRepo.addItem(
                                  userId,
                                  CartItem(productId: product.id!, quantity: 1),
                                );
                                ref.invalidate(cartProvider(userId));
                              },
                        child: Text(isInCart ? "Added to Cart" : "Add to Cart"),
                      );
                    },
                    loading: () => const ElevatedButton(
                      onPressed: null,
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    error: (_, __) => ElevatedButton(
                      onPressed: null,
                      child: const Text("Error"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// MAIN PRODUCT IMAGE
            GestureDetector(
              onTap: () => _openFullImage(product.imageUrls.first),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrls.first,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// PRICE
            Text(
              "KES ${product.price.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            /// RATING STARS
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < product.rating.round()
                      ? Icons.star
                      : Icons.star_border,
                  color: AppColors.vibrantOrange,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// DESCRIPTION
            Text(product.description, style: const TextStyle(fontSize: 14)),

            const SizedBox(height: 20),

            /// PRODUCT IMAGES THUMBNAILS
            const Text(
              "More Images",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product.imageUrls.length,
                itemBuilder: (context, index) {
                  final image = product.imageUrls[index];

                  return GestureDetector(
                    onTap: () => _openFullImage(image),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            /// CUSTOMER REVIEWS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Customer Reviews",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text("View All")),
              ],
            ),

            const SizedBox(height: 8),

            const Text("No reviews yet."),

            const SizedBox(height: 24),

            /// RECOMMENDED PRODUCTS
            const Text(
              "Recommended",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // replace with real data later
                itemBuilder: (context, index) {
                  return Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                    child: const Center(child: Text("Product")),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
