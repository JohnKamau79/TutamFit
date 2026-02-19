import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistModel {
  final String productId;
  final String name;
  final double price;
  final String image;
  final Timestamp? createdAt;

  WishlistModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    this.createdAt,
  });

  factory WishlistModel.fromMap(Map<String, dynamic> map) {
    return WishlistModel(
      productId: map['productId'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      image: map['image'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'image': image,
      'createdAt': createdAt,
    };
  }
}