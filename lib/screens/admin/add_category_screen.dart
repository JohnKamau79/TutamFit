import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tutam_fit/services/cloudinary_upload_service.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final UploadService _uploadService = UploadService();
  File? _categoryImageFile;
  String? _categoryImageUrl;
  final List<Map<String, String>> _types = [];
  final _typeNameController = TextEditingController();
  File? _typeImageFile;

  Future<void> _pickCategoryImage() async {
    final file = await _uploadService.pickImage();
    if (file != null) setState(() => _categoryImageFile = file);
  }

  Future<void> _pickTypeImage() async {
    final file = await _uploadService.pickImage();
    if (file != null) setState(() => _typeImageFile = file);
  }

  void _addType() async {
    if (_typeNameController.text.isEmpty || _typeImageFile == null) return;
    final url = await _uploadService.uploadTypeImage(_typeImageFile!);
    setState(() {
      _types.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _typeNameController.text,
        'imageUrl': url!,
      });
    });
    _typeNameController.clear();
    _typeImageFile = null;
  }

  void _removeType(int index) => setState(() => _types.removeAt(index));

  void _submitCategory() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryImageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pick a category image')));
      return;
    }
    if (_types.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add at least one type')));
      return;
    }

    _categoryImageUrl = await _uploadService.uploadCategoryImage(
      _categoryImageFile!,
    );
    await _uploadService.saveCategory(
      name: _nameController.text,
      imageUrl: _categoryImageUrl!,
      types: _types,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category added successfully!')),
    );

    setState(() {
      _nameController.clear();
      _categoryImageFile = null;
      _categoryImageUrl = null;
      _types.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Category'),
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
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _pickCategoryImage,
                child: Text(
                  _categoryImageFile == null
                      ? 'Pick Category Image'
                      : 'Category Image Selected',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Types',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _types.length,
                itemBuilder: (context, index) {
                  final type = _types[index];
                  return Card(
                    color: theme.cardColor,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Image.network(
                        type['imageUrl']!,
                        width: 40,
                        height: 40,
                      ),
                      title: Text(type['name']!),
                      trailing: IconButton(
                        onPressed: () => _removeType(index),
                        icon: const Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _typeNameController,
                decoration: InputDecoration(
                  labelText: 'Type Name',
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickTypeImage,
                child: Text(
                  _typeImageFile == null
                      ? 'Pick Type Image'
                      : 'Type Image Selected',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addType,
                child: const Text('Add Type'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitCategory,
                child: const Text('Submit Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
