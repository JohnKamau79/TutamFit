// category_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/providers/category_provider.dart';
import 'package:tutam_fit/widgets/home_searchbar_widget.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final selectedCategory = ref.watch(selectedCategoryProviders);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: HomeSearchbarWidget(),
          ),
        ),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e', style: theme.textTheme.bodyMedium)),
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: Text(
                'No categories found',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
              ),
            );
          }

          if (selectedCategory == null) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => ref.read(selectedCategoryProviders.notifier).state = categories.first,
            );
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              SizedBox(
                height: 70,
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
                          color: isSelected ? theme.colorScheme.secondary : theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected
                              ? [BoxShadow(color: theme.shadowColor.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            cat.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? theme.colorScheme.onSecondary : theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
                        onTap: () => context.push('/product-filter', extra: {'categoryId': selectedCategory.id, 'typeId': type.id}),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: theme.shadowColor.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: type.imageUrl != null
                                      ? CachedNetworkImage(imageUrl: type.imageUrl!, fit: BoxFit.cover, width: double.infinity)
                                      : Container(color: theme.disabledColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: Text(
                                    type.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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

