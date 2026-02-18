import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String userName;
  final List<Map<String, dynamic>>
  items; // productId, name, price, quantity, image
  final double totalAmount;
  final String paymentMethod; // 'mpesa' | 'stripe'
  final String status; // 'pending', 'paid', 'failed', 'delivered'
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.items,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'],
      userName: map['userName'],
      items: List<Map<String, dynamic>>.from(map['items']),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'],
      status: map['status'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'items': items,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
