import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/providers/product_provider.dart';
import 'package:tutam_fit/widgets/filter_list_widget.dart';
import 'package:tutam_fit/widgets/product_list_widget.dart';

class SearchFilterScreen extends ConsumerWidget {
  const SearchFilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: AbsorbPointer(
            child: TextField(
              controller: TextEditingController(text: searchQuery),
              decoration: const InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          FilterListWidget(),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final productsAsync = ref.watch(searchProductsStreamProvider);
                return ProductListWidget(products: productsAsync.asData?.value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
