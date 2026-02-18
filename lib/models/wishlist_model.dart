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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'wishlist_model.g.dart';

// @JsonSerializable()
// class WishlistItem {
//   final String productId;

//   WishlistItem({required this.productId});

//   factory WishlistItem.fromJson(Map<String, dynamic> json) =>
//       _$WishlistItemFromJson(json);
//   Map<String, dynamic> toJson() => _$WishlistItemToJson(this);
// }

// @JsonSerializable()
// class WishlistModel {
//   final String userId;
//   final List<WishlistItem> items;

//   @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
//   final Timestamp updatedAt;

//   WishlistModel({
//     required this.userId,
//     required this.items,
//     required this.updatedAt,
//   });

//   factory WishlistModel.fromJson(Map<String, dynamic> json) =>
//       _$WishlistModelFromJson(json);
//   Map<String, dynamic> toJson() => _$WishlistModelToJson(this);
// }

// // Firestore timestamp conversion
// Timestamp _timestampFromJson(Timestamp timestamp) => timestamp;
// Timestamp _timestampToJson(Timestamp timestamp) => timestamp;
