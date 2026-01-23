import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String name;
  final String description;
  final double price;
  final String currency;
  final String categoryId;
  final List<String> images;
  final int stock;
  final double rating;

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final Timestamp createdAt;

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final Timestamp updatedAt;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.images,
    required this.currency,
    required this.stock,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

Timestamp _timestampFromJson(Timestamp timestamp) => timestamp;
Timestamp _timestampToJson(Timestamp timestamp) => timestamp;
