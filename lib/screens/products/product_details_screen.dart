import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/providers/cart_provider.dart';
import 'package:tutam_fit/providers/review_provider.dart';
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
                return IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () async {
                    try {
                      await ref
                          .read(wishlistRepositoryProvider)
                          .addToWishlist(product);

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to wishlist')),
                      );
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please login first')),
                      );
                    }
                  },
                );
              },
            ),
          const SizedBox(width: 16),
          const Icon(Icons.shopping_cart_outlined),
          const SizedBox(width: 12),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (user != null)
                Consumer(
                  builder: (context, ref, _) {
                    return IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () async {
                        try {
                          await ref
                              .read(wishlistRepositoryProvider)
                              .addToWishlist(product);

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to wishlist')),
                          );
                        } catch (e) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login first')),
                          );
                        }
                      },
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

                    return ElevatedButton(
                      onPressed: () async {
                        try {
                          await ref
                              .read(cartRepositoryProvider)
                              .addToCart(product);

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to cart'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login first')),
                          );
                        }
                      },
                      child: const Text('Add to Cart'),
                    );
                  },
                ),
              ),
            ],
          ),
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

            /// Replace your old "CUSTOMER REVIEWS" section with this:
            const SizedBox(height: 24),

            /// CUSTOMER REVIEWS HEADER + ADD CTA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Customer Reviews",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    if (user != null) {
                      context.push(
                        '/all-reviews', // pass productId as path param
                      );
                    }
                  },
                  child: const Text("View All"),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Add Review CTA
            if (user != null)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      '/add-review',
                      extra: {'productId': product.id!, 'productName': product.name},
                    );
                  },
                  icon: const Icon(Icons.add_comment),
                  label: const Text('Add Review'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            /// Horizontal preview of latest 3 reviews
            Consumer(
              builder: (context, ref, _) {
                final reviewsAsync = ref.watch(reviewProvider(product.id!));

                return reviewsAsync.when(
                  data: (reviews) {
                    if (reviews.isEmpty) {
                      return const Text("No reviews yet.");
                    }

                    final preview = reviews.take(3).toList();

                    return SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: preview.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final review = preview[index];
                          return Container(
                            width: 220,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User: ${review.userId.substring(0, 6)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < review.rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: AppColors.vibrantOrange,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Expanded(
                                  child: Text(
                                    review.comment,
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => const Text("Error loading reviews"),
                );
              },
            ),

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
