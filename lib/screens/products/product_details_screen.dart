import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/providers/cart_provider.dart';
import 'package:tutam_fit/providers/product_provider.dart';
import 'package:tutam_fit/providers/review_provider.dart';
import 'package:tutam_fit/providers/wishlist_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

// import statements remain the same

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
      builder: (_) => Dialog(
        child: InteractiveViewer(child: CachedNetworkImage(imageUrl: image)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.arrow_upward),
      ),
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.push('/search'),
            icon: Icon(Icons.search, color: theme.iconTheme.color),
          ),
          const SizedBox(width: 16),
          if (user != null)
            Consumer(
              builder: (context, ref, _) {
                final wishlistAsync = ref.watch(wishlistStreamProvider);
                return wishlistAsync.when(
                  data: (wishlist) {
                    final isInWishlist = wishlist.any(
                      (item) => item.productId == product.id,
                    );
                    return IconButton(
                      icon: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist
                            ? theme.colorScheme.primary
                            : theme.iconTheme.color,
                      ),
                      onPressed: () async {
                        final repo = ref.read(wishlistRepositoryProvider);
                        try {
                          if (isInWishlist) {
                            await repo.removeFromWishlist(product.id);
                          } else {
                            await repo.addToWishlist(product);
                          }
                        } catch (_) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login first')),
                          );
                        }
                      },
                    );
                  },
                  loading: () =>
                      Icon(Icons.favorite_border, color: theme.iconTheme.color),
                  error: (_, __) =>
                      Icon(Icons.favorite_border, color: theme.iconTheme.color),
                );
              },
            ),
          const SizedBox(width: 12),
          Consumer(
            builder: (context, ref, _) {
              final cartAsync = ref.watch(cartStreamProvider);
              return cartAsync.when(
                data: (cartItems) {
                  final count = cartItems.length;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: theme.iconTheme.color,
                        ),
                        onPressed: () => context.push('/cart'),
                      ),
                      if (count > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Center(
                              child: Text(
                                count.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
                loading: () => Icon(
                  Icons.shopping_cart_outlined,
                  color: theme.iconTheme.color,
                ),
                error: (_, __) => Icon(
                  Icons.shopping_cart_outlined,
                  color: theme.iconTheme.color,
                ),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Flexible(
                child: Consumer(
                  builder: (context, ref, _) {
                    if (user == null) {
                      return ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.disabledColor,
                        ),
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
                        } catch (_) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please login first')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
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
            /// MAIN IMAGE
            GestureDetector(
              onTap: () => _openFullImage(product.imageUrls.first),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrls.first,
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
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            /// STARS
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < product.rating.round()
                      ? Icons.star
                      : Icons.star_border,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// DESCRIPTION
            Text(product.description, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 20),

            /// MORE IMAGES
            Text(
              "More Images",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
                        child: CachedNetworkImage(
                          imageUrl: image,
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

            /// CUSTOMER REVIEWS HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Customer Reviews",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user != null)
                  TextButton(
                    onPressed: () => context.push('/all-reviews'),
                    child: const Text("View All"),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            if (user != null)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push(
                      '/add-review',
                      extra: {
                        'productId': product.id,
                        'productName': product.name,
                      },
                    );
                  },
                  icon: const Icon(Icons.add_comment),
                  label: const Text('Add Review'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
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
                final reviewsAsync = ref.watch(reviewProvider(product.id));
                return reviewsAsync.when(
                  data: (reviews) {
                    if (reviews.isEmpty)
                      return Text(
                        "No reviews yet.",
                        style: theme.textTheme.bodyMedium,
                      );
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
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.15),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.userName,
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
                                      color: theme.colorScheme.primary,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Expanded(
                                  child: Text(
                                    review.comment,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 13,
                                    ),
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
                  error: (_, __) => Text(
                    "Error loading reviews",
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            /// RECOMMENDED PRODUCTS
            Text(
              "Recommended",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            Consumer(
              builder: (context, ref, _) {
                final recommendedAsync = ref.watch(
                  recommendedProductsProvider(product),
                );
                return recommendedAsync.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return Text(
                        "No recommendations",
                        style: theme.textTheme.bodyMedium,
                      );
                    }
                    return SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final p = products[index];
                          return GestureDetector(
                            onTap: () =>
                                context.push('/product-details', extra: p),
                            child: Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: theme.cardColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.shadowColor.withOpacity(0.15),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: p.imageUrls.first,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      p.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => Text(
                    "Failed to load recommendations",
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
