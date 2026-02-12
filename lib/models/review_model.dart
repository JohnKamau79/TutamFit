import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final String id;
  final String userId;
  final String productId;
  final int rating;
  final String comment;

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final Timestamp createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}

Timestamp _timestampFromJson(Timestamp timestamp) => timestamp;
Timestamp _timestampToJson(Timestamp timestamp) => timestamp;
