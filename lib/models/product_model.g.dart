// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  categoryId: json['categoryId'] as String,
  typeName: json['typeName'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  stock: (json['stock'] as num).toInt(),
  rating: (json['rating'] as num).toDouble(),
  createdAt: _timestampFromJson(json['createdAt'] as Timestamp),
  updatedAt: _timestampFromJson(json['updatedAt'] as Timestamp),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'categoryId': instance.categoryId,
      'typeName': instance.typeName,
      'images': instance.images,
      'stock': instance.stock,
      'rating': instance.rating,
      'createdAt': _timestampToJson(instance.createdAt),
      'updatedAt': _timestampToJson(instance.updatedAt),
    };
