import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/models/category_model.dart';
import 'package:tutam_fit/providers/category_provider.dart';
import 'package:tutam_fit/providers/product_provider.dart';

class CategoryListWidget extends ConsumerWidget {
  final List<CategoryModel>? categories;

  const CategoryListWidget({super.key, this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = categories == null
        ? ref.watch(categoriesStreamProvider)
        : AsyncValue.data(categories);

    return categoriesAsync.when(
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
      error: (err, stack) => SizedBox(
        height: 50,
        child: Center(child: Text('Error loading categories: $err')),
      ),
      data: (categories) {
        final selected = ref.watch(selectedCategoryProvider);

        return SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(selectedCategoryProvider.notifier).state = 'all';
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Chip(
                    label: const Text('All'),
                    backgroundColor: selected == 'all'
                        ? AppColors.vibrantOrange
                        : null,
                  ),
                ),
              ),
              ...categories!.map((category) {
                return GestureDetector(
                  onTap: () {
                    ref.read(selectedCategoryProvider.notifier).state =
                        category.id!;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Chip(
                      label: Text(category.name),
                      backgroundColor: selected == category.id
                          ? AppColors.vibrantOrange
                          : null,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}