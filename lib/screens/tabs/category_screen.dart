import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/providers/category_provider.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final selectedCategory = ref.watch(selectedCategoryProviders);

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
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => context.push('/add-category'),
                icon: Icon(Icons.add_box_rounded, color: AppColors.vibrantOrange),
              ),
            ],
          ),
        ),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          // Auto-select first category if none selected
          if (selectedCategory == null) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => ref.read(selectedCategoryProviders.notifier).state = categories.first,
            );
            return const SizedBox.shrink(); // Don't block UI
          }

          return Column(
            children: [
              // Category horizontal list
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = cat.id == selectedCategory.id;

                    return GestureDetector(
                      onTap: () => ref.read(selectedCategoryProviders.notifier).state = cat,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.vibrantOrange : const Color.fromARGB(255, 223, 223, 223),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppColors.deepNavy.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            cat.name,
                            style: TextStyle(
                              color: isSelected ? AppColors.white : AppColors.darkGray,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Types grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    itemCount: selectedCategory.types.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final type = selectedCategory.types[index];

                      return GestureDetector(
                        onTap: () => context.push('/product-filter', extra: {
                          'categoryId': selectedCategory.id,
                          'typeId': type.id,
                        }),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.white,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: type.imageUrl != null
                                      ? Image.network(type.imageUrl!, fit: BoxFit.cover)
                                      : Container(color: AppColors.darkGray),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: Text(
                                    type.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}