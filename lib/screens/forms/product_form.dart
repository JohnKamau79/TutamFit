import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/models/category_model.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/providers/category_provider.dart';
import 'package:tutam_fit/providers/product_provider.dart';
import 'package:tutam_fit/services/cloudinary_upload_service.dart';

class ProductForm extends ConsumerStatefulWidget {
  const ProductForm({super.key});

  @override
  ConsumerState<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final stockController = TextEditingController();

  String? selectedCategoryId;
  CategoryType? selectedType;

  List<File> pickedImages = [];
  List<String> uploadedImageUrls = [];

  final UploadService uploadService = UploadService();

  bool isSubmitting = false;

  Future<void> pickImages() async {
    final files = await uploadService.pickMultiImages();
    if (files.isNotEmpty) {
      setState(() {
        pickedImages.addAll(files);
      });
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (pickedImages.isEmpty) return;

    setState(() {
      isSubmitting = true;
    });

    uploadedImageUrls = await uploadService.uploadMultiProductImages(
      pickedImages,
    );

    final product = ProductModel(
      id: null,
      name: nameController.text.trim(),
      description: descController.text.trim(),
      price: double.parse(priceController.text.trim()),
      categoryId: selectedCategoryId!,
      typeName: selectedType!.id,
      imageUrls: uploadedImageUrls,
      stock: int.parse(stockController.text.trim()),
      rating: 0,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    final productId = await ref
        .read(productRepositoryProvider)
        .addProduct(product);

    print('Product saved with ID: $productId');

    setState(() {
      isSubmitting = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryFetchFutureProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Add Product Form')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v!.isEmpty ? 'Enter a name' : null,
              ),

              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v!.isEmpty ? 'Enter a description' : null,
              ),

              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter a price' : null,
              ),

              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter quantity' : null,
              ),

              const SizedBox(height: 16),

              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat.id,
                          child: Text(cat.name),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCategoryId = val;
                      selectedType = null;
                    });
                  },
                  validator: (v) => v == null ? 'Select category' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, stackTrace) =>
                    Text('Error loading categories: $error'),
              ),

              const SizedBox(height: 16),

              if (selectedCategoryId != null)
                categoriesAsync.when(
                  data: (categories) {
                    final selectedCat = categories.firstWhere(
                      (c) => c.id == selectedCategoryId,
                    );

                    final types = selectedCat.types;

                    return DropdownButtonFormField<CategoryType>(
                      initialValue: selectedType,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: types
                          ?.map(
                            (type) => DropdownMenuItem<CategoryType>(
                              value: type,
                              child: Text(type.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() {
                        selectedType = val;
                      }),
                      validator: (v) => v == null ? 'Select type' : null,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (error, stackTrace) =>
                      const Text('Error loading types'),
                ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: pickImages,
                child: const Text('Pick images'),
              ),

              const SizedBox(height: 8),

              if (pickedImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: pickedImages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(12),
                          child: Image.file(
                            pickedImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                pickedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.darkGray,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: isSubmitting ? null : submitForm,
                child: isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
