// home_searchbar_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';

class HomeSearchbarWidget extends ConsumerStatefulWidget {
  const HomeSearchbarWidget({super.key});

  @override
  ConsumerState<HomeSearchbarWidget> createState() =>
      _HomeSearchbarWidgetState();
}

class _HomeSearchbarWidgetState extends ConsumerState<HomeSearchbarWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () => context.push('/search'),
      decoration: InputDecoration(
        hintText: 'Search Products...',
        hintStyle: const TextStyle(color: AppColors.darkGray),
        prefixIcon: const Icon(Icons.search, color: AppColors.deepNavy),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
