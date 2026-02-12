import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/providers/category_provider.dart';
import 'package:tutam_fit/providers/product_provider.dart';
import 'package:tutam_fit/widgets/searchbar_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(
      filteredProductsStreamProvider({
        'categoryId': selectedCategoryId,
        'typeName': null,
      }),
    );

    final categoriesAsync = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.deepNavy,
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(child: SearchbarWidget()),
              IconButton(
                onPressed: () {
                  context.push('/product-form');
                },
                icon: Icon(Icons.shopping_bag),
              ),
            ],
          ),
        ),
      ),
      // PRODUCTS GRID
      body: Column(
        children: [
          categoriesAsync.when(
            data: (categories) {
              return SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() => selectedCategoryId = null);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Chip(label: Text('All')),
                      ),
                    ),
                    ...categories.map((category) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedCategoryId = category.id);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Chip(label: Text(category.name)),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
            loading: () => SizedBox(
              height: 50,
              child: ListView.separated(
                itemCount: 6,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) => Shimmer.fromColors(
                  baseColor: AppColors.darkGray,
                  highlightColor: AppColors.deepNavy,
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            error: (err, stack) => const SizedBox(
              height: 50,
              child: Center(child: Text('Error loading categories')),
            ),
          ),
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('No products available'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final ProductModel product = products[index];

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
                          context.push('/product', extra: product);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.darkGray,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                ),
                                child: Image.network(
                                  product.images.first,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                product.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                              child: Text(
                                'KES ${product.price.toStringAsFixed(0)}',
                                style: TextStyle(
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
              error: (err, stack) {
                return Center(child: Text('Error : $err'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
