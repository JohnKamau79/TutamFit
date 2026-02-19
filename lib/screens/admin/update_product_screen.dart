import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/providers/product_provider.dart';

class UpdateProductScreen extends ConsumerStatefulWidget {
  final ProductModel product;
  const UpdateProductScreen({super.key, required this.product});

  @override
  ConsumerState<UpdateProductScreen> createState() =>
      _UpdateProductScreenState();
}

class _UpdateProductScreenState extends ConsumerState<UpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    descController = TextEditingController(text: widget.product.description);
    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    stockController = TextEditingController(
      text: widget.product.stock.toString(),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> updateProduct() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final updatedData = {
      'name': nameController.text.trim(),
      'description': descController.text.trim(),
      'price': double.parse(priceController.text.trim()),
      'stock': int.parse(stockController.text.trim()),
      'updatedAt': widget.product.updatedAt,
    };

    try {
      await ref
          .read(productRepositoryProvider)
          .updateProduct(widget.product.id, updatedData);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
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
        fillColor: theme.inputDecorationTheme.fillColor ?? theme.cardColor,
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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Update Product'),
        backgroundColor: Colors.transparent,
        foregroundColor: theme.textTheme.titleLarge?.color,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
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
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : updateProduct,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Update Product',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
