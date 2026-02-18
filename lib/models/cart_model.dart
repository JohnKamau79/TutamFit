import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String productId;
  final String name;
  final double price;
  final String image;
  final int quantity;
  final Timestamp? createdAt;

  CartModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    this.createdAt,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      productId: map['productId'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      image: map['image'],
      quantity: map['quantity'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
      'createdAt': createdAt,
    };
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'cart_model.g.dart';

// @JsonSerializable()
// class CartItem {
//   final String productId;
//   final int quantity;

//   CartItem({required this.productId, required this.quantity});

//   factory CartItem.fromJson(Map<String, dynamic> json) =>
//       _$CartItemFromJson(json);
//   Map<String, dynamic> toJson() => _$CartItemToJson(this);
// }

// @JsonSerializable()
// class CartModel {
//   final String userId;
//   final List<CartItem> items;

//   @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
//   final Timestamp updatedAt;

//   CartModel({
//     required this.userId,
//     required this.items,
//     required this.updatedAt,
//   });

//   factory CartModel.fromJson(Map<String, dynamic> json) =>
//       _$CartModelFromJson(json);
//   Map<String, dynamic> toJson() => _$CartModelToJson(this);
// }

// Timestamp _timestampFromJson(Timestamp timestamp) => timestamp;
// Timestamp _timestampToJson(Timestamp timestamp) => timestamp;
