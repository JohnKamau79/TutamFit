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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pick at least one image')));
      return;
    }
    if (selectedCategoryId == null || selectedType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select category and type')));
      return;
    }
    setState(() => isSubmitting = true);
    try {
      uploadedImageUrls = await uploadService.uploadMultiProductImages(
        pickedImages,
      );
      if (uploadedImageUrls.isEmpty)
        throw Exception('Image upload returned empty URLs');
      final product = ProductModel(
        id: '',
        name: nameController.text.trim(),
        description: descController.text.trim(),
        price: double.parse(priceController.text.trim()),
        categoryId: selectedCategoryId!,
        typeId: selectedType!.id!,
        imageUrls: uploadedImageUrls,
        stock: int.parse(stockController.text.trim()),
        rating: 0,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );
      final productId = await ref
          .read(productRepositoryProvider)
          .addProduct(product);
      print('Product added with ID: $productId');
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add product: $e')));
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesFutureProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.transparent,
        foregroundColor: theme.textTheme.titleLarge?.color,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField(controller: nameController, label: 'Product Name'),
              const SizedBox(height: 16),
              buildField(
                controller: descController,
                label: 'Description',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              buildField(
                controller: priceController,
                label: 'Price',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              buildField(
                controller: stockController,
                label: 'Stock',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<String>(
                  value: selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
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
                      decoration: InputDecoration(
                        labelText: 'Type',
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
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
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Pick Images'),
              ),
              const SizedBox(height: 12),
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
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitForm,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Product',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
