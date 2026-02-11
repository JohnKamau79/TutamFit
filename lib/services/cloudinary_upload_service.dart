import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadService {
  final String cloudName = 'tutamfit';
  final String productUploadPreset = 'tutam_product_images';
  final String typeUploadPreset = 'tutam_type_images';
  final String categoryUploadPreset = 'tutam_category_images';

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      return File(picked.path);
    }
    return null;
  }

  // Upload Product Image
  Future<String?> _uploadImage(File imageFile, String preset) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
    );
    request.fields['upload_preset'] = preset;
    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();
    var resData = await response.stream.bytesToString();
    var data = json.decode(resData);

    return data['secure_url'];
  }

  Future<String?> uploadTypeImage(File imageFile) => _uploadImage(imageFile, typeUploadPreset);
  Future<String?> uploadCategoryImage(File imageFile) => _uploadImage(imageFile, categoryUploadPreset);
  Future<String?> uploadProductImage(File imageFile) => _uploadImage(imageFile, productUploadPreset);

  Future<void> saveProduct({
    required String name,
    required double price,
    required String imageUrl,
  }) async {
    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  Future<void> saveCategory({
    required String name,
    required String imageUrl,
    required List<Map<String, String>> types,
  }) async {
    await FirebaseFirestore.instance.collection('categories').add({
      'name': name,
      'imageUrl': imageUrl,
      'types': types,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
