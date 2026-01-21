import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()

class OrderItem{
  final String productId;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this); 
}


@JsonSerializable()

class OrderModel {
  final String userId;
  final List<OrderItem> products;
  final double totalPrice;
  final String currency;
  final String status;
  final String paymentMethod;

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final Timestamp createdAt;

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final Timestamp updatedAt;

  OrderModel({
    required this.userId,
    required this.products,
    required this.totalPrice,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this); 
}

Timestamp _timestampFromJson(Timestamp timestamp) => timestamp;
Timestamp _timestampToJson(Timestamp timestamp) => timestamp;