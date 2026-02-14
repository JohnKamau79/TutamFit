// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/widgets/home_searchbar_widget.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> categories = [];
  Map<String, dynamic>? selectedCategory;

  // final Map<String, List<String>> categories = {
  //   'Weights': ['Dumbbells', 'Kettlebells', 'Barbells', 'Weight Plates'],
  //   'Cardio': ['Treadmills', 'Jump Ropes', 'Exercise Bikes', 'Ellipticals'],
  //   'Resistance': [
  //     'Resistance Bands',
  //     'Yoga Mats',
  //     'Exercise Balls',
  //     'TRX Straps',
  //   ],
  //   'Supplements': [
  //     'Protein Powders',
  //     'Pre-Workout',
  //     'Post-Workout',
  //     'Vitamins',
  //   ],
  //   'Nutrition': [
  //     'Energy Bars',
  //     'Protein Shakes',
  //     'Healthy Snacks',
  //     'Meal Replacements',
  //   ],
  //   'Apparel': ['T-Shirts', 'Shorts', 'Leggings', 'Jackets'],
  //   'Footwear': [
  //     'Training Shoes',
  //     'Running Shoes',
  //     'Socks',
  //     'Weightlifting Shoes',
  //   ],
  //   'Accessories': ['Gloves', 'Belts', 'Gym Bags', 'HeadBands'],
  //   'Recovery': [
  //     'Foam Rollers',
  //     'Massage Guns',
  //     'Muscle Creams',
  //     'Stretch Straps',
  //   ],
  //   'Hydration': ['Water Bottles', 'Shakers', 'Sports Drinks', 'Electrolytes'],
  //   'Tech': [
  //     'Fitness Trackers',
  //     'Smart Watches',
  //     'Heart Rate Monitors',
  //     'Smart Scales',
  //   ],
  //   'Gear': ['Jump Ropes', 'Gloves', 'Bands', 'Mats'],
  // };

  // String? selectedCategory;
  // bool isFeatured = false;

  @override
  void initState() {
    super.initState();
    // selectedCategory = categories.keys.first;
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .get();

    final data = snapshot.docs.map((doc) {
      final map = doc.data();
      map['id'] = doc.id;

      return map;
    }).toList();

    setState(() {
      categories = List<Map<String, dynamic>>.from(data);
      if (categories.isNotEmpty) selectedCategory = categories[0];
    });
  }

  void _selectCategory(Map<String, dynamic> category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void shaffleTypes() {
    if (selectedCategory == null) return;
    final types = List<Map<String, dynamic>>.from(selectedCategory!['types']);
    types.shuffle();

    setState(() {
      selectedCategory!['types'] = types;
    });
  }

  // List<String> getTypes() {
  //   if (isFeatured) {
  //     final allTypes = categories.values.expand((list) => list).toList();
  //     allTypes.shuffle(Random());
  //     return allTypes;
  //   }
  //   return selectedCategory != null ? categories[selectedCategory!]! : [];
  // }

  @override
  Widget build(BuildContext context) {
    // final categoryKeys = ['Featured', ...categories.keys];
    // final types = getTypes();

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
              Expanded(child: HomeSearchbarWidget()),
              IconButton(
                onPressed: () {
                  context.push('/category-form');
                },
                icon: Icon(Icons.category),
              ),
            ],
          ),
        ),
      ),
      // BODY
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Container(
                  width: 120,
                  color: AppColors.primaryRed,
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected =
                          selectedCategory != null &&
                          selectedCategory!['id'] == cat['id'];

                      return Container(
                        color: isSelected
                            ? AppColors.deepNavy
                            : AppColors.primaryRed,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectCategory(cat);
                              // if (category == 'Featured') {
                              //   isFeatured = true;
                              //   selectedCategory = null;
                              // } else {
                              //   isFeatured = false;
                              //   selectedCategory = category;
                              // }
                            });
                          },
                          child: Text(
                            cat['name'],
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
                    padding: const EdgeInsets.all(40),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 0,
                      childAspectRatio: 1,
                    ),
                    itemCount: selectedCategory!['types'].length,
                    itemBuilder: (context, index) {
                      final type = selectedCategory!['types'][index];

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
                            context.push('/product-filter');
                          },
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
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      type['imageUrl'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  type['name'],
                                  style: TextStyle(
                                    fontSize: 20,
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
