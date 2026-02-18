// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
  id: json['id'] as String?,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  productId: json['productId'] as String,
  productName: json['productName'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
  createdAt: _timestampFromJson(json['createdAt'] as Timestamp),
);

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'productId': instance.productId,
      'productName': instance.productName,
      'rating': instance.rating,
      'comment': instance.comment,
      'createdAt': _timestampToJson(instance.createdAt),
    };
