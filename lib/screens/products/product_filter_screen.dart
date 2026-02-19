import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/providers/product_provider.dart';
import 'package:tutam_fit/widgets/home_searchbar_widget.dart';

class ProductFilterScreen extends ConsumerWidget {
  final String categoryId;
  final String typeId;

  const ProductFilterScreen({
    super.key,
    required this.categoryId,
    required this.typeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(productRepositoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    final productsStream = repo.streamProductsByCategory(
      categoryId,
      typeId: typeId,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.deepNavy,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            ref.read(searchQueryProvider.notifier).state = '';
            context.pop();
          },
          color: AppColors.white,
        ),

        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Expanded(child: HomeSearchbarWidget()),
        ),
      ),
      body: StreamBuilder(
        stream: productsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ProductModel> products = snapshot.data!;

          // Apply search filter
          if (searchQuery.isNotEmpty) {
            products = products
                .where(
                  (p) =>
                      p.name.toLowerCase().contains(searchQuery.toLowerCase()),
                )
                .toList();
          }

          if (products.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final product = products[index];

              return GestureDetector(
                onTap: () => context.push('/product-details', extra: product),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: product.imageUrls.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: product.imageUrls.first,
                                  fit: BoxFit.cover,
                                )
                              : Container(color: Colors.grey.shade300),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ksh ${product.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
