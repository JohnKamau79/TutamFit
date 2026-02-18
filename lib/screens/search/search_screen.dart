import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/providers/product_provider.dart';
import 'package:tutam_fit/widgets/search_searchbar_widget.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentSearchesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.deepNavy,
        leading: BackButton(onPressed: () { ref.read(searchQueryProvider.notifier).state = ''; context.pop(); }, color: AppColors.white),
        title: Container(
          height: 45,
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Expanded(child: SearchSearchbarWidget(onSearchTap: (query) { context.push('/search-filter-screen'); })),
              IconButton(onPressed: () => context.push('/product-form'), icon: const Icon(Icons.shopping_bag)),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (recent.isNotEmpty)
            Expanded(
              child: ListView(
                children: recent.map((s) {
                  return GestureDetector(
                    onTap: () { ref.read(searchQueryProvider.notifier).state = s; context.push('/search-filter-screen'); },
                    child: Container(
                      color: const Color.fromRGBO(255, 235, 59, 0.2),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: Text(s, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}