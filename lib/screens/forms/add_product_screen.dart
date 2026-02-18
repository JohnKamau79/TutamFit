import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutam_fit/models/category_model.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/providers/category_provider.dart';
import 'package:tutam_fit/providers/product_provider.dart';
import 'package:tutam_fit/services/cloudinary_upload_service.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
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
    if (files.isNotEmpty) pickedImages.addAll(files);
    setState(() {});
  }

Future<void> submitForm() async {
  if (!_formKey.currentState!.validate()) return;
  if (pickedImages.isEmpty) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Pick at least one image')));
    return;
  }

  if (selectedCategoryId == null || selectedType == null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Select category and type')));
    return;
  }

  setState(() => isSubmitting = true);

  try {
    // Upload images
    uploadedImageUrls = await uploadService.uploadMultiProductImages(pickedImages);
    if (uploadedImageUrls.isEmpty) {
      throw Exception('Image upload returned empty URLs');
    }

    // Create product object
    final product = ProductModel(
      id: null,
      name: nameController.text.trim(),
      description: descController.text.trim(),
      price: double.parse(priceController.text.trim()),
      categoryId: selectedCategoryId ?? '',
      typeId: selectedType!.id ?? '',
      imageUrls: uploadedImageUrls,
      stock: int.parse(stockController.text.trim()),
      rating: 0,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    // Add to Firestore
    final productId = await ref.read(productRepositoryProvider).addProduct(product);
    print('Product added with ID: $productId');

    Navigator.pop(context); // Close screen on success
  } catch (e, st) {
    print('Error adding product: $e');
    print(st);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Failed to add product: $e')));
  } finally {
    if (mounted) setState(() => isSubmitting = false);
  }
}
  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesFutureProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories
                      .map(
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (val) => setState(() {
                    selectedCategoryId = val;
                    selectedType = null;
                  }),
                  validator: (v) => v == null ? 'Select category' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error loading categories: $e'),
              ),

              const SizedBox(height: 16),
              if (selectedCategoryId != null)
                categoriesAsync.when(
                  data: (categories) {
                    final cat = categories.firstWhere(
                      (c) => c.id == selectedCategoryId,
                    );
                    return DropdownButtonFormField<CategoryType>(
                      value: selectedType,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: cat.types
                          .map(
                            (t) =>
                                DropdownMenuItem(value: t, child: Text(t.name)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => selectedType = val),
                      validator: (v) => v == null ? 'Select type' : null,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error loading types: $e'),
                ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: pickImages,
                child: const Text('Pick Images'),
              ),
              const SizedBox(height: 8),
              if (pickedImages.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: pickedImages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
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
                            onTap: () =>
                                setState(() => pickedImages.removeAt(index)),
                            child: const Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
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
