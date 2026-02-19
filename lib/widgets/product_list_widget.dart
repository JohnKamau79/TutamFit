// product_list_widget.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/providers/product_provider.dart';

class ProductListWidget extends ConsumerWidget {
  final List<ProductModel>? products;

  const ProductListWidget({super.key, this.products});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = products == null
        ? ref.watch(allProductsStreamProvider)
        : AsyncValue.data(products);

    final selectedCategory = ref.watch(selectedCategoryProvider);

    return productsAsync.when(
      loading: () => GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: AppColors.deepNavy,
          highlightColor: AppColors.white,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      error: (err, stack) => Center(
        child: Text(
          'Failed to load products',
          style: const TextStyle(color: AppColors.warningYellow),
        ),
      ),
      data: (products) {
        if (products!.isEmpty) {
          return const Center(
            child: Text(
              'No products available',
              style: TextStyle(color: AppColors.darkGray),
            ),
          );
        }

        final filteredProducts = selectedCategory == 'all'
            ? products
            : products.where((p) => p.categoryId == selectedCategory).toList();

        if (filteredProducts.isEmpty) {
          return const Center(
            child: Text(
              'No products in this category',
              style: TextStyle(color: AppColors.darkGray),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return GestureDetector(
              onTap: () => context.push('/product-details', extra: product),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lighttGray,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.darkGray,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrls.first,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: AppColors.darkGray,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      child: Text(
                        'KES ${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.deepNavy,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
