import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/widgets/searchbar_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final Map<String, List<String>> categories = {
    'Weights': ['Dumbbells', 'Kettlebells', 'Barbells', 'Weight Plates'],
    'Cardio': ['Treadmills', 'Jump Ropes', 'Exercise Bikes', 'Ellipticals'],
    'Resistance': [
      'Resistance Bands',
      'Yoga Mats',
      'Exercise Balls',
      'TRX Straps',
    ],
    'Supplements': [
      'Protein Powders',
      'Pre-Workout',
      'Post-Workout',
      'Vitamins',
    ],
    'Nutrition': [
      'Energy Bars',
      'Protein Shakes',
      'Healthy Snacks',
      'Meal Replacements',
    ],
    'Apparel': ['T-Shirts', 'Shorts', 'Leggings', 'Jackets'],
    'Footwear': [
      'Training Shoes',
      'Running Shoes',
      'Socks',
      'Weightlifting Shoes',
    ],
    'Accessories': ['Gloves', 'Belts', 'Gym Bags', 'HeadBands'],
    'Recovery': [
      'Foam Rollers',
      'Massage Guns',
      'Muscle Creams',
      'Stretch Straps',
    ],
    'Hydration': ['Water Bottles', 'Shakers', 'Sports Drinks', 'Electrolytes'],
    'Tech': [
      'Fitness Trackers',
      'Smart Watches',
      'Heart Rate Monitors',
      'Smart Scales',
    ],
    'Gear': ['Jump Ropes', 'Gloves', 'Bands', 'Mats'],
  };

  String? selectedCategory;
  bool isFeatured = false;

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.keys.first;
  }

  List<String> getTypes() {
    if(isFeatured) {
      final allTypes = categories.values.expand((list) => list).toList();
      allTypes.shuffle(Random());
      return allTypes;
    }
    return selectedCategory != null ? categories[selectedCategory!]! : [];
  }

  @override
  Widget build(BuildContext context) {
    final categoryKeys = ['Featured', ...categories.keys];
    final types = getTypes();

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
          child: SearchbarWidget(),
        ),
      ),
      // BODY
      body: Row(
        children: [
          Container(
            width: 120,
            color: AppColors.primaryRed,
            child: ListView.builder(
              itemCount: categoryKeys.length,
              itemBuilder: (context, index) {
                final category = categoryKeys[index];
                final isSelected = (!isFeatured && category == selectedCategory) || (isFeatured && category == 'Featured');

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if(category == 'Featured') {
                        isFeatured = true;
                        selectedCategory = null;
                      }else {
                        isFeatured = false;
                        selectedCategory = category;
                      }
                    });
                  },
                  child: Container(
                    color: isSelected
                        ? AppColors.deepNavy
                        : AppColors.primaryRed,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: isFeatured ? const EdgeInsets.all(12) : const EdgeInsets.all(40),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isFeatured ? 2 : 1,
                mainAxisSpacing: 16,
                crossAxisSpacing: isFeatured ? 16 : 0,
                childAspectRatio: isFeatured ? 0.75 : 1,
              ),
              itemCount: types.length,
              itemBuilder: (context, index) {
                final type = types[index];

                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: AppColors.darkGray, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.darkGray,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: isFeatured ? EdgeInsets.all(8) : EdgeInsets.all(16),
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: isFeatured ? 16 : 20,
                              fontWeight: FontWeight.bold,
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
        ],
      ),
    );
  }
}
