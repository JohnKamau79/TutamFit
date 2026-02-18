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

    return Expanded(
      child: productsAsync.when(
        data: (products) {
          if (products!.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          // Filter by selected category
          final filteredProducts = selectedCategory == 'all'
              ? products
              : products.where((p) => p.categoryId == selectedCategory).toList();

          if (filteredProducts.isEmpty) {
            return const Center(child: Text('No products in this category'));
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
              final ProductModel product = filteredProducts[index];

              return Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: AppColors.darkGray, blurRadius: 6),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    context.push('/product-details', extra: product);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.darkGray,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Image.network(
                            product.imageUrls.first,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: Text(
                          'KES ${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.darkGray,
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
            baseColor: AppColors.darkGray,
            highlightColor: AppColors.deepNavy,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        error: (err, stack) => Center(child: Text('Error : $err')),
      ),
    );
  }
}