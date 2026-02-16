// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) =>
    WishlistItem(productId: json['productId'] as String);

Map<String, dynamic> _$WishlistItemToJson(WishlistItem instance) =>
    <String, dynamic>{'productId': instance.productId};

WishlistModel _$WishlistModelFromJson(Map<String, dynamic> json) =>
    WishlistModel(
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => WishlistItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: _timestampFromJson(json['updatedAt'] as Timestamp),
    );

Map<String, dynamic> _$WishlistModelToJson(WishlistModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'items': instance.items,
      'updatedAt': _timestampToJson(instance.updatedAt),
    };
