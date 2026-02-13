import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/widgets/category_widget.dart';
import 'package:tutam_fit/widgets/product_widget.dart';
import 'package:tutam_fit/widgets/searchbar_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        children: [const CategoryListWidget(), const ProductListWidget()],
      ),
    );
  }
}
