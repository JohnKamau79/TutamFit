// home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/widgets/category_list_widget.dart';
import 'package:tutam_fit/widgets/product_list_widget.dart';
import 'package:tutam_fit/widgets/home_searchbar_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: HomeSearchbarWidget(),
          ),
        ),
      ),
      body: const Column(
        children: [
          SizedBox(height: 12),
          CategoryListWidget(),
          SizedBox(height: 12),
          Expanded(child: ProductListWidget()),
        ],
      ),
    );
  }
}
